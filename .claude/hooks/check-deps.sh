#!/usr/bin/env bash
# FR-8.4: 신규 의존성 공급망 체크 (pre-commit hook)

set -euo pipefail

# Snyk CLI 없으면 경고만
if ! command -v snyk &>/dev/null; then
  echo "⚠️  [FR-8.4] snyk CLI 없음 — 의존성 체크 건너뜀 (CI에서 재검증)" >&2
  exit 0
fi

# Snyk 인증 토큰 없으면 건너뜀
if [[ -z "${SNYK_TOKEN:-}" ]]; then
  echo "⚠️  [FR-8.4] SNYK_TOKEN 미설정 — 의존성 체크 건너뜀 (CI에서 재검증)" >&2
  exit 0
fi

echo "[FR-8.4] Snyk 의존성 취약점 스캔 중..."
if ! snyk test --severity-threshold=high 2>&1; then
  echo "❌ [FR-8.4] High 이상 취약점 발견. 커밋 차단." >&2
  exit 1
fi

echo "✅ [FR-8.4] 의존성 취약점 OK"
exit 0
