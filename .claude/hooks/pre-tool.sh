#!/usr/bin/env bash
# FR-8.5: 블랙리스트 명령 2인 확인
# Hook type: PreToolUse
# Claude Code passes: CLAUDE_TOOL_NAME, CLAUDE_TOOL_INPUT (JSON)

set -euo pipefail

TOOL_NAME="${CLAUDE_TOOL_NAME:-}"
TOOL_INPUT="${CLAUDE_TOOL_INPUT:-}"
LOG_DIR="${AIDD_LOG_DIR:-.aidd/events}"
LOG_FILE="${LOG_DIR}/hooks-$(date +%Y%m).jsonl"

mkdir -p "$LOG_DIR"

log_event() {
  local type="$1" detail="$2"
  printf '{"ts":"%s","hook":"pre-tool","type":"%s","tool":"%s","detail":"%s"}\n' \
    "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$type" "$TOOL_NAME" "$detail" >> "$LOG_FILE"
}

# Bash tool: 블랙리스트 명령 검사
if [[ "$TOOL_NAME" == "Bash" ]]; then
  CMD=$(echo "$TOOL_INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('command',''))" 2>/dev/null || echo "")

  # Tier-1: 즉시 차단 (절대 실행 불가)
  BLACKLIST_HARD=(
    'rm\s+-rf\s+/'
    'dd\s+if='
    'mkfs\.'
    ':\(\)\s*\{.*\}'          # fork bomb
    'chmod\s+-R\s+777\s+/'
    'curl\s+.*\|\s*bash'
    'wget\s+.*\|\s*bash'
  )
  for pattern in "${BLACKLIST_HARD[@]}"; do
    if echo "$CMD" | grep -qE "$pattern"; then
      log_event "BLOCKED_HARDLIST" "$pattern"
      echo "❌ [FR-8.5] 위험 명령 차단: $CMD" >&2
      exit 1
    fi
  done

  # Tier-2: 2인 확인 필요 (환경변수 AIDD_SECOND_APPROVER 있어야 통과)
  BLACKLIST_SOFT=(
    'git\s+push\s+.*--force'
    'git\s+reset\s+--hard'
    'kubectl\s+delete'
    'helm\s+uninstall'
    'DROP\s+TABLE'
    'DELETE\s+FROM\s+\w+\s*;'
  )
  for pattern in "${BLACKLIST_SOFT[@]}"; do
    if echo "$CMD" | grep -qiE "$pattern"; then
      if [[ -z "${AIDD_SECOND_APPROVER:-}" ]]; then
        log_event "BLOCKED_SOFT_NO_APPROVER" "$pattern"
        echo "❌ [FR-8.5] 2인 승인 필요: AIDD_SECOND_APPROVER 환경변수를 설정하세요." >&2
        echo "   명령: $CMD" >&2
        exit 1
      else
        log_event "ALLOWED_SOFT_APPROVED" "approver=${AIDD_SECOND_APPROVER}"
      fi
    fi
  done
fi

# Write/Edit tool: .env 파일 수정 차단
if [[ "$TOOL_NAME" == "Write" || "$TOOL_NAME" == "Edit" ]]; then
  FILE_PATH=$(echo "$TOOL_INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('file_path',''))" 2>/dev/null || echo "")
  if echo "$FILE_PATH" | grep -qE '(^|/)\.env($|\.)'; then
    log_event "BLOCKED_ENV_WRITE" "$FILE_PATH"
    echo "❌ [FR-8.5] .env 파일 직접 쓰기 차단: $FILE_PATH" >&2
    exit 1
  fi
fi

exit 0
