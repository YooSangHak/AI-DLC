#!/usr/bin/env bash
# FR-8.7: Kill-switch + runaway cost 방어
# Hook type: PostToolUse
# Claude Code passes: CLAUDE_TOOL_NAME, CLAUDE_TOOL_RESULT, CLAUDE_SESSION_COST_USD

set -euo pipefail

TOOL_NAME="${CLAUDE_TOOL_NAME:-}"
SESSION_COST="${CLAUDE_SESSION_COST_USD:-0}"
LOG_DIR="${AIDD_LOG_DIR:-.aidd/events}"
LOG_FILE="${LOG_DIR}/hooks-$(date +%Y%m).jsonl"
COST_LOG="${LOG_DIR}/cost-$(date +%Y%m).jsonl"

mkdir -p "$LOG_DIR"

log_event() {
  local type="$1" detail="$2"
  printf '{"ts":"%s","hook":"post-tool","type":"%s","tool":"%s","detail":"%s"}\n' \
    "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$type" "$TOOL_NAME" "$detail" >> "$LOG_FILE"
}

# 비용 기록
printf '{"ts":"%s","tool":"%s","session_cost_usd":%s}\n' \
  "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$TOOL_NAME" "$SESSION_COST" >> "$COST_LOG"

# Kill-switch: 세션당 비용 한도 (기본 $5.00, AIDD_COST_LIMIT_USD로 override)
COST_LIMIT="${AIDD_COST_LIMIT_USD:-5.00}"

# Python으로 float 비교 (bash bc fallback)
EXCEEDED=0
if command -v python3 &>/dev/null; then
  EXCEEDED=$(python3 -c "print(1 if float('${SESSION_COST}') > float('${COST_LIMIT}') else 0)" 2>/dev/null || echo 0)
elif command -v bc &>/dev/null; then
  EXCEEDED=$(echo "$SESSION_COST > $COST_LIMIT" | bc 2>/dev/null || echo 0)
fi

if [[ "$EXCEEDED" == "1" ]]; then
  log_event "KILL_SWITCH_TRIGGERED" "session_cost=${SESSION_COST} limit=${COST_LIMIT}"
  echo "🛑 [FR-8.7] Kill-switch: 세션 비용 \$${SESSION_COST} > 한도 \$${COST_LIMIT}" >&2
  echo "   세션을 종료합니다. 비용 한도 변경: AIDD_COST_LIMIT_USD 환경변수 설정" >&2
  exit 1
fi

# 경고: 한도 80% 도달
WARNING_THRESHOLD=$(python3 -c "print(float('${COST_LIMIT}') * 0.8)" 2>/dev/null || echo "4.00")
WARNED=0
if command -v python3 &>/dev/null; then
  WARNED=$(python3 -c "print(1 if float('${SESSION_COST}') > float('${WARNING_THRESHOLD}') else 0)" 2>/dev/null || echo 0)
fi

if [[ "$WARNED" == "1" ]]; then
  log_event "COST_WARNING" "session_cost=${SESSION_COST} threshold=${WARNING_THRESHOLD}"
  echo "⚠️  [FR-8.7] 비용 경고: \$${SESSION_COST} (한도의 80%+)" >&2
fi

# Kill-switch 파일 확인 (수동 비상 정지)
KILL_FILE="${AIDD_LOG_DIR:-.aidd}/KILL_SWITCH"
if [[ -f "$KILL_FILE" ]]; then
  log_event "KILL_SWITCH_FILE" "manual_kill_switch_activated"
  echo "🛑 [FR-8.7] 수동 Kill-switch 활성화됨: $KILL_FILE" >&2
  exit 1
fi

exit 0
