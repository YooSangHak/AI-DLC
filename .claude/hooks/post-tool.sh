#!/usr/bin/env bash
# FR-8.7: 도구 실행 결과 감사 로그 (기록 전용)
# Hook type: PostToolUse
#
# 입력: stdin으로 JSON 페이로드
#       {"hook_event_name","tool_name","tool_input","tool_response",...}
#
# ⚠️ 여기서는 차단하지 않는다.
#    PostToolUse는 도구가 *이미 실행된 뒤*라 비용도 부작용도 되돌릴 수 없다.
#    Kill-switch·비용 한도·블랙리스트는 전부 pre-tool.sh(PreToolUse)가 담당한다.

set -uo pipefail

INPUT_JSON=$(cat)
LOG_DIR="${AIDD_LOG_DIR:-.aidd/events}"
LOG_FILE="${LOG_DIR}/hooks-$(date +%Y%m).jsonl"

mkdir -p "$LOG_DIR"

# 도구 결과 본문은 기록하지 않는다 (비밀·PII가 섞여 들어올 수 있다).
# 이름과 성공/실패 여부만 json.dumps로 안전하게 직렬화한다.
printf '%s' "$INPUT_JSON" | python3 -c '
import sys, json, datetime
try:
    d = json.load(sys.stdin)
except Exception:
    d = {}
if not isinstance(d, dict):
    d = {}
name = d.get("tool_name")
resp = d.get("tool_response")
print(json.dumps({
    "ts": datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
    "hook": "post-tool",
    "type": "TOOL_COMPLETED",
    "tool": name if isinstance(name, str) else "",
    "is_error": bool(resp.get("is_error")) if isinstance(resp, dict) else False,
}, ensure_ascii=False))
' >> "$LOG_FILE" 2>/dev/null || true

exit 0
