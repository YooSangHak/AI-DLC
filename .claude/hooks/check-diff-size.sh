#!/usr/bin/env bash
# FR-8.3: 300 LOC 초과 커밋 차단 (pre-commit hook)

set -euo pipefail

LIMIT=300

# staged diff 라인 수 계산 (추가+삭제)
TOTAL=$(git diff --cached --numstat | awk '{add+=$1; del+=$2} END {print add+del}')
TOTAL="${TOTAL:-0}"

if [[ "$TOTAL" -gt "$LIMIT" ]]; then
  echo "❌ [FR-8.3] diff 크기 초과: ${TOTAL} LOC > ${LIMIT} LOC 한도" >&2
  echo "   작업을 AC 단위 또는 기능 단위로 분할하세요." >&2
  exit 1
fi

echo "✅ [FR-8.3] diff 크기 OK: ${TOTAL} LOC"
exit 0
