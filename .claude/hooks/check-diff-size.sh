#!/usr/bin/env bash
# FR-8.3: 300 LOC 초과 커밋 차단 (pre-commit, commit-msg 단계)
#
# 우회: 커밋 메시지에 `loc_ok` 를 포함하면 통과한다.
#       대량 생성 코드·포맷 일괄 적용처럼 분할이 무의미한 경우를 위한 탈출구다.
#       우회 사실은 .aidd/events 감사 로그에 남는다 (규칙 우회는 추적되어야 한다).
#       CI 등 비대화 환경에서는 AIDD_LOC_OK=1 로도 우회 가능.
#
# 인자: $1 = 커밋 메시지 파일 (commit-msg 단계에서 pre-commit이 전달)

set -uo pipefail

LIMIT="${AIDD_LOC_LIMIT:-300}"
MSG_FILE="${1:-}"
LOG_DIR="${AIDD_LOG_DIR:-.aidd/events}"

# 계산 대상은 "코드"만. 300 LOC 한도는 AI가 한 번에 생성하는 산출물을
# 사람이 리뷰 가능한 범위로 묶기 위한 규칙이므로, 설계 문서·락파일처럼
# 리뷰 부담 성격이 다른 파일은 제외한다.
#
# ⚠️ 확장자(*.md)로 일괄 제외하지 않는다. .claude/skills/·.claude/agents/ 의
#    마크다운은 문서가 아니라 하네스 로직 본체이므로 반드시 계산에 포함한다.
#    (이 리포는 자산 대부분이 .md 라 확장자 제외 시 규칙이 통째로 무력화된다)
#    제외는 경로 기준으로만 한다. glob 매직은 `*` 가 `/` 를 넘지 않게 해
#    루트의 README.md 만 빠지고 하위 디렉터리 .md 는 포함되도록 만든다.
EXCLUDES=(
  ':(exclude)docs/**'
  ':(exclude)templates/**'
  ':(exclude).claude/prompts/**'
  ':(exclude,glob)*.md'
  ':(exclude)*.lock'
  ':(exclude)*-lock.json'
  ':(exclude)pnpm-lock.yaml'
  ':(exclude)uv.lock'
)

count() { git diff --cached --numstat -- "$@" | awk '{add+=$1; del+=$2} END {print add+del+0}'; }
TOTAL=$(count . "${EXCLUDES[@]}")
TOTAL="${TOTAL:-0}"
ALL=$(count .)
ALL="${ALL:-0}"

if [[ "$TOTAL" -le "$LIMIT" ]]; then
  if [[ "$ALL" -ne "$TOTAL" ]]; then
    echo "✅ [FR-8.3] diff 크기 OK: 코드 ${TOTAL} LOC (문서·락파일 제외 / 전체 ${ALL})"
  else
    echo "✅ [FR-8.3] diff 크기 OK: ${TOTAL} LOC"
  fi
  exit 0
fi

# ── 한도 초과 — 우회 태그 확인 ──
# 커밋 메시지 파일이 없으면 git이 준비해 둔 기본 경로를 본다.
if [[ -z "$MSG_FILE" || ! -f "$MSG_FILE" ]]; then
  GIT_DIR=$(git rev-parse --git-dir 2>/dev/null) || GIT_DIR=".git"
  MSG_FILE="${GIT_DIR}/COMMIT_EDITMSG"
fi

BYPASS=0
if [[ -n "${AIDD_LOC_OK:-}" ]]; then
  BYPASS=1
elif [[ -f "$MSG_FILE" ]] && grep -qi 'loc_ok' "$MSG_FILE"; then
  BYPASS=1
fi

if [[ "$BYPASS" -eq 1 ]]; then
  mkdir -p "$LOG_DIR" 2>/dev/null || true
  python3 -c '
import sys, json, datetime
print(json.dumps({
    "ts": datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
    "hook": "check-diff-size",
    "type": "LOC_LIMIT_BYPASSED",
    "detail": f"loc={sys.argv[1]} limit={sys.argv[2]}",
}, ensure_ascii=False))
' "$TOTAL" "$LIMIT" >> "${LOG_DIR}/hooks-$(date +%Y%m).jsonl" 2>/dev/null || true

  echo "⚠️  [FR-8.3] diff ${TOTAL} LOC > ${LIMIT} — loc_ok 태그로 우회함 (감사 로그 기록됨)" >&2
  exit 0
fi

echo "❌ [FR-8.3] diff 크기 초과: ${TOTAL} LOC > ${LIMIT} LOC 한도" >&2
echo "   작업을 AC 단위 또는 기능 단위로 분할하세요." >&2
echo "   분할이 불가능하면 커밋 메시지에 loc_ok 를 넣어 우회할 수 있습니다." >&2
exit 1
