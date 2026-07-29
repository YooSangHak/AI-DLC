#!/usr/bin/env bash
# FR-8.1: 비밀·PII 입력 차단
# FR-8.2: 프롬프트 인젝션 방어
# Hook type: UserPromptSubmit
#
# 입력: stdin으로 JSON 페이로드 ({"hook_event_name","prompt","session_id",...})
#       ※ CLAUDE_PROMPT_TEXT 같은 환경변수는 Claude Code가 설정하지 않는다.
# 차단: exit 2 (stderr가 사용자에게 표시되고 프롬프트가 처리되지 않음)
#       exit 1은 "비차단 에러"라 차단 효과가 없으므로 사용 금지.

set -uo pipefail

INPUT_JSON=$(cat)
LOG_DIR="${AIDD_LOG_DIR:-.aidd/events}"
LOG_FILE="${LOG_DIR}/hooks-$(date +%Y%m).jsonl"

mkdir -p "$LOG_DIR"

# 프롬프트 원문은 절대 로그에 남기지 않는다 (비밀·PII 유출 방지).
# detail에는 패턴 종류만 기록하되, 이스케이프는 json.dumps에 맡긴다.
log_event() {
  python3 -c '
import sys, json
print(json.dumps({"ts": sys.argv[1], "hook": "pre-prompt",
                  "type": sys.argv[2], "detail": sys.argv[3]}, ensure_ascii=False))
' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$1" "$2" >> "$LOG_FILE" 2>/dev/null || true
}

INPUT=$(printf '%s' "$INPUT_JSON" | python3 -c \
  'import sys,json; print(json.load(sys.stdin).get("prompt",""))' 2>/dev/null) || INPUT=""

# FR-8.1: Secret patterns
SECRET_PATTERN='(sk-[a-zA-Z0-9]{20,}|AKIA[0-9A-Z]{16}|ghp_[a-zA-Z0-9]{36}|[Aa][Pp][Ii][_-]?[Kk][Ee][Yy][[:space:]]*[:=][[:space:]]*["'\''][^"'\'']{8,})'
if printf '%s' "$INPUT" | grep -qE "$SECRET_PATTERN"; then
  log_event "BLOCKED_SECRET" "secret_pattern_detected"
  echo "❌ [FR-8.1] 비밀 정보 감지됨 — 입력 차단." >&2
  exit 2
fi

# FR-8.1: PII patterns (한국 주민번호, 카드번호)
PII_PATTERN='([0-9]{6}-[0-9]{7}|[0-9]{4}[- ]?[0-9]{4}[- ]?[0-9]{4}[- ]?[0-9]{4})'
if printf '%s' "$INPUT" | grep -qE "$PII_PATTERN"; then
  log_event "BLOCKED_PII" "pii_pattern_detected"
  echo "❌ [FR-8.1] PII 감지됨 (주민번호/카드번호) — 입력 차단." >&2
  exit 2
fi

# FR-8.2: Prompt injection patterns (경고만 — 오탐 시 작업 중단 비용이 크다)
# grep -P(PCRE)는 macOS의 BSD grep에 없으므로 -iE 단독으로 처리한다.
INJECTION_PATTERN='(ignore (all |the )?previous instructions?|disregard (all |your )?instructions?|new instructions?:|system[[:space:]]*:[[:space:]]*you are|forget (everything|all)|act as (an? )?(DAN|jailbreak|unrestricted))'
if printf '%s' "$INPUT" | grep -qiE "$INJECTION_PATTERN"; then
  log_event "WARNED_INJECTION" "injection_pattern_detected"
  echo "⚠️  [FR-8.2] 인젝션 패턴 의심 — 로그 기록 후 계속." >&2
fi

exit 0
