---
name: self-healing
description: |
  린트·타입·단위 테스트 실패 시 Agent 자체 수정 루프 (최대 3회).
  OpenAI 기둥2 — 성공은 조용히, 실패만 시끄럽게.
  "/self-healing", "자동 수정", "lint 고쳐줘", "테스트 실패 수정" 요청 시 트리거.
  agent-dev·agent-qa가 CI 실패 후 자동 호출.
allowed-tools: Read Edit Write Bash(uv * ruff * mypy * pytest * pnpm * npx * tsc *)
---

# 🔧 Self-Healing 자동 교정 루프 (ADR-019)

## 목적
린트·타입·단위 테스트 실패 시 최대 3회 자동 수정 시도. 성공 시 조용히, 실패 시만 보고.

## 적용 범위

| 자동 수정 가능 | 인간 판단 필요 (자동 수정 불가) |
|---|---|
| 린트 (ruff, biome, eslint, Checkstyle) | Mutation 테스트 |
| 타입 오류 (mypy, tsc) | 보안 스캔 이슈 |
| 단위 테스트 실패 (pytest, Vitest, JUnit) | E2E 테스트 |
| Import 정렬 (isort) | 성능 회귀 |
| 포맷 오류 | 비즈니스 로직 버그 |

## 실행 흐름

```
실패 감지 → 원인 분석 → 수정 시도 (1회)
           ↓ 성공 → 조용히 완료 (✅ 1줄)
           ↓ 실패 → 재시도 (2회)
                    ↓ 성공 → 조용히 완료
                    ↓ 실패 → 재시도 (3회)
                             ↓ 성공 → 조용히 완료
                             ↓ 실패 → ❌ 시끄럽게 보고 (원인·위치·수정 제안)
```

## Python 자동 수정 절차

```bash
# 1회차: 자동 수정 가능 항목
uv run ruff check src/ tests/ --fix --silent
uv run ruff format src/ tests/ --silent

# 타입 오류 확인
MYPY_OUT=$(uv run mypy src/ --strict 2>&1)
if [[ -n "$MYPY_OUT" ]]; then
  # 타입 오류는 코드 수정 필요 — Read→Edit 루프
  echo "$MYPY_OUT" | head -20
fi

# 테스트 재실행
uv run pytest --tb=short -q
```

## TypeScript 자동 수정 절차

```bash
# biome 자동 수정
pnpm biome check src/ --write --silent

# tsc 오류 확인 (수동 수정 필요)
TSC_OUT=$(npx tsc --noEmit 2>&1)
if [[ -n "$TSC_OUT" ]]; then
  echo "$TSC_OUT" | head -20
fi

# vitest 재실행
npx vitest run --silent
```

## 실패 보고 포맷 (3회 모두 실패 시)

```
❌ Self-healing 실패 (3/3회 시도)

원인: {lint|type|test} 오류 — {파일}:{라인}
위치: {정확한 파일 경로 + 라인 번호}
오류: {오류 메시지}
수정 제안: {구체적 수정 방법 1~3가지}

수동 수정 후 재시도하세요.
```

## 성공 보고 포맷

```
✅ self-healing 완료 ({N}회 시도)
```

## 제한 사항
- 비즈니스 로직 변경 금지 — 린트·포맷·타입 힌트만 수정
- 300 LOC 초과 수정 불가 (commit-guardrail 연계)
- 3회 실패 시 중단, 사람 개입 요청
