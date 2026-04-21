#!/usr/bin/env bash
# FR-8.1: 비밀·PII 입력 차단
# FR-8.2: 프롬프트 인젝션 방어
# Hook type: UserPromptSubmit
# Input: $CLAUDE_PROMPT_TEXT (env) or stdin (Claude Code hooks pass via env)

set -euo pipefail

INPUT="${CLAUDE_PROMPT_TEXT:-}"
LOG_DIR="${AIDD_LOG_DIR:-.aidd/events}"
LOG_FILE="${LOG_DIR}/hooks-$(date +%Y%m).jsonl"

mkdir -p "$LOG_DIR"

log_event() {
  local type="$1" detail="$2"
  printf '{"ts":"%s","hook":"pre-prompt","type":"%s","detail":"%s"}\n' \
    "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$type" "$detail" >> "$LOG_FILE"
}

# FR-8.1: Secret patterns
SECRET_PATTERN='(sk-[a-zA-Z0-9]{20,}|AKIA[0-9A-Z]{16}|ghp_[a-zA-Z0-9]{36}|[Aa][Pp][Ii][_-]?[Kk][Ee][Yy]\s*[:=]\s*["\x27][^"'\'']{8,})'
if echo "$INPUT" | grep -qE "$SECRET_PATTERN"; then
  log_event "BLOCKED_SECRET" "secret_pattern_detected"
  echo "❌ [FR-8.1] 비밀 정보 감지됨 — 입력 차단." >&2
  exit 1
fi

# FR-8.1: PII patterns (한국 주민번호, 카드번호, 이메일 대량)
PII_PATTERN='([0-9]{6}-[0-9]{7}|[0-9]{4}[- ]?[0-9]{4}[- ]?[0-9]{4}[- ]?[0-9]{4})'
if echo "$INPUT" | grep -qE "$PII_PATTERN"; then
  log_event "BLOCKED_PII" "pii_pattern_detected"
  echo "❌ [FR-8.1] PII 감지됨 (주민번호/카드번호) — 입력 차단." >&2
  exit 1
fi

# FR-8.2: Prompt injection patterns
INJECTION_PATTERN='(?i)(ignore (all |the )?previous instructions?|disregard (all |your )?instructions?|new instructions?:|system\s*:\s*you are|forget (everything|all)|act as (an? )?(DAN|jailbreak|unrestricted))'
if echo "$INPUT" | grep -qP "$INJECTION_PATTERN" 2>/dev/null || \
   echo "$INPUT" | grep -qiE '(ignore previous|disregard instructions|system: you are|forget everything|act as DAN)'; then
  log_event "WARNED_INJECTION" "injection_pattern_detected"
  echo "⚠️  [FR-8.2] 인젝션 패턴 의심 — 로그 기록 후 계속." >&2
fi

exit 0
