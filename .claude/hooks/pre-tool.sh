#!/usr/bin/env bash
# FR-8.5: 블랙리스트 명령 2인 확인 · .env 쓰기 차단
# FR-8.7: Kill-switch + runaway cost 방어 (도구 실행 *전*에 차단해야 의미가 있음)
# Hook type: PreToolUse
#
# 입력: stdin으로 JSON 페이로드
#       {"hook_event_name","tool_name","tool_input",{...},"transcript_path",...}
#       ※ CLAUDE_TOOL_NAME / CLAUDE_TOOL_INPUT 환경변수는 존재하지 않는다.
# 차단: exit 2 (도구 호출이 차단되고 stderr가 Claude에게 전달됨)
#       exit 1은 "비차단 에러"라 차단 효과가 없으므로 사용 금지.

set -uo pipefail

INPUT_JSON=$(cat)
LOG_DIR="${AIDD_LOG_DIR:-.aidd/events}"
LOG_FILE="${LOG_DIR}/hooks-$(date +%Y%m).jsonl"
COST_LOG="${LOG_DIR}/cost-$(date +%Y%m).jsonl"
HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$LOG_DIR"

# 페이로드를 한 번만 파싱해 셸 변수로 받는다.
# shlex.quote로 이스케이프하므로 명령·경로에 개행이나 따옴표가 있어도 안전하다.
TOOL_NAME=""; TRANSCRIPT=""; CMD=""; FILE_PATH=""
eval "$(printf '%s' "$INPUT_JSON" | python3 -c '
import sys, json, shlex
try:
    d = json.load(sys.stdin)
except Exception:
    d = {}
if not isinstance(d, dict):
    d = {}
ti = d.get("tool_input")
if not isinstance(ti, dict):
    ti = {}
def q(v):
    return shlex.quote(v if isinstance(v, str) else "")
print("TOOL_NAME="  + q(d.get("tool_name")))
print("TRANSCRIPT=" + q(d.get("transcript_path")))
print("CMD="        + q(ti.get("command")))
print("FILE_PATH="  + q(ti.get("file_path")))
' 2>/dev/null)" || true

# detail에는 정규식(백슬래시)·명령 문자열이 들어오므로 printf로 조립하면 JSON이 깨진다.
# json.dumps로 이스케이프해야 감사 로그가 기계 판독 가능한 상태로 유지된다.
log_event() {
  python3 -c '
import sys, json
print(json.dumps({"ts": sys.argv[1], "hook": "pre-tool", "type": sys.argv[2],
                  "tool": sys.argv[3], "detail": sys.argv[4]}, ensure_ascii=False))
' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$1" "$TOOL_NAME" "$2" >> "$LOG_FILE" 2>/dev/null || true
}

# ─────────────────────────────────────────────
# FR-8.7: 수동 Kill-switch 파일
# ─────────────────────────────────────────────
KILL_FILE="${AIDD_KILL_SWITCH:-.aidd/KILL_SWITCH}"
if [[ -f "$KILL_FILE" ]]; then
  log_event "KILL_SWITCH_FILE" "manual_kill_switch_activated"
  echo "🛑 [FR-8.7] 수동 Kill-switch 활성화됨: $KILL_FILE" >&2
  echo "   해제하려면 해당 파일을 삭제하세요." >&2
  exit 2
fi

# ─────────────────────────────────────────────
# FR-8.7: 세션 누적 비용 (경고 $10 / 차단 $50)
# transcript의 토큰 사용량으로 추정한다 — 훅 페이로드에 비용 필드가 없다.
# 경고를 한도의 비율이 아닌 절대값으로 둔다: 한도가 크면 비율 경고는 너무 늦게 뜬다.
# ─────────────────────────────────────────────
COST_LIMIT="${AIDD_COST_LIMIT_USD:-50.00}"
COST_WARN="${AIDD_COST_WARN_USD:-10.00}"

# 자기 수리 예외: 훅 자신을 고치는 작업은 비용 가드를 건너뛴다.
# 이게 없으면 한도 초과 시 훅을 수정할 방법이 사라져 셸 직접 개입 외에는 복구 불가.
# (수동 Kill-switch는 사람의 명시적 정지 의사이므로 예외를 적용하지 않는다)
SKIP_COST_GUARD=0
case "$FILE_PATH" in
  */.claude/hooks/*|.claude/hooks/*) SKIP_COST_GUARD=1 ;;
esac

SESSION_COST=0
if [[ -n "$TRANSCRIPT" && -f "$TRANSCRIPT" ]]; then
  SESSION_COST=$(python3 "${HOOK_DIR}/session-cost.py" "$TRANSCRIPT" 2>/dev/null) || SESSION_COST=0
  SESSION_COST="${SESSION_COST:-0}"
fi

python3 -c '
import sys, json
try:
    cost = float(sys.argv[3])
except ValueError:
    cost = 0.0
print(json.dumps({"ts": sys.argv[1], "tool": sys.argv[2],
                  "session_cost_usd": cost, "estimated": True}, ensure_ascii=False))
' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$TOOL_NAME" "$SESSION_COST" >> "$COST_LOG" 2>/dev/null || true

if [[ "$SKIP_COST_GUARD" -eq 0 ]]; then
  VERDICT=$(python3 -c "
c = float('${SESSION_COST}'); lim = float('${COST_LIMIT}'); warn = float('${COST_WARN}')
print('exceeded' if c > lim else ('warn' if c > warn else 'ok'))
" 2>/dev/null) || VERDICT="ok"

  if [[ "$VERDICT" == "exceeded" ]]; then
    log_event "KILL_SWITCH_TRIGGERED" "session_cost=${SESSION_COST} limit=${COST_LIMIT}"
    echo "🛑 [FR-8.7] Kill-switch: 세션 추정 비용 \$${SESSION_COST} > 한도 \$${COST_LIMIT}" >&2
    echo "   한도 변경: AIDD_COST_LIMIT_USD 환경변수 또는 이 스크립트의 기본값" >&2
    exit 2
  elif [[ "$VERDICT" == "warn" ]]; then
    log_event "COST_WARNING" "session_cost=${SESSION_COST} warn=${COST_WARN} limit=${COST_LIMIT}"
    echo "⚠️  [FR-8.7] 비용 경고: \$${SESSION_COST} (경고선 \$${COST_WARN} / 한도 \$${COST_LIMIT})" >&2
  fi
fi

# ─────────────────────────────────────────────
# FR-8.5: Bash 블랙리스트
# ─────────────────────────────────────────────
if [[ "$TOOL_NAME" == "Bash" ]]; then
  # Tier-1: 즉시 차단 (절대 실행 불가)
  BLACKLIST_HARD=(
    'rm[[:space:]]+-rf[[:space:]]+/'
    'dd[[:space:]]+if='
    'mkfs\.'
    ':\(\)[[:space:]]*\{.*\}'          # fork bomb
    'chmod[[:space:]]+-R[[:space:]]+777[[:space:]]+/'
    'curl[[:space:]]+.*\|[[:space:]]*bash'
    'wget[[:space:]]+.*\|[[:space:]]*bash'
  )
  for pattern in "${BLACKLIST_HARD[@]}"; do
    if printf '%s' "$CMD" | grep -qE "$pattern"; then
      log_event "BLOCKED_HARDLIST" "$pattern"
      echo "❌ [FR-8.5] 위험 명령 차단: $CMD" >&2
      exit 2
    fi
  done

  # Tier-2: 2인 확인 필요 (AIDD_SECOND_APPROVER 환경변수 있어야 통과)
  BLACKLIST_SOFT=(
    'git[[:space:]]+push[[:space:]]+.*--force'
    'git[[:space:]]+reset[[:space:]]+--hard'
    'kubectl[[:space:]]+delete'
    'helm[[:space:]]+uninstall'
    'DROP[[:space:]]+TABLE'
    'DELETE[[:space:]]+FROM[[:space:]]+[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*;'
  )
  for pattern in "${BLACKLIST_SOFT[@]}"; do
    if printf '%s' "$CMD" | grep -qiE "$pattern"; then
      if [[ -z "${AIDD_SECOND_APPROVER:-}" ]]; then
        log_event "BLOCKED_SOFT_NO_APPROVER" "$pattern"
        echo "❌ [FR-8.5] 2인 승인 필요: AIDD_SECOND_APPROVER 환경변수를 설정하세요." >&2
        echo "   명령: $CMD" >&2
        exit 2
      else
        log_event "ALLOWED_SOFT_APPROVED" "approver=${AIDD_SECOND_APPROVER}"
      fi
    fi
  done
fi

# ─────────────────────────────────────────────
# FR-8.5: .env 파일 직접 쓰기 차단
# ─────────────────────────────────────────────
if [[ "$TOOL_NAME" == "Write" || "$TOOL_NAME" == "Edit" || "$TOOL_NAME" == "NotebookEdit" ]]; then
  if printf '%s' "$FILE_PATH" | grep -qE '(^|/)\.env($|\.)'; then
    log_event "BLOCKED_ENV_WRITE" "$FILE_PATH"
    echo "❌ [FR-8.5] .env 파일 직접 쓰기 차단: $FILE_PATH" >&2
    exit 2
  fi
fi

exit 0
