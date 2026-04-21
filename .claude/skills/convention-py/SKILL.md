---
name: convention-py
description: |
  Python 코딩 컨벤션. ruff·mypy·bandit·Snyk 규칙·실행 명령.
  Python 리포에서 agent-dev·agent-qa가 자동 참조.
  "/convention-py", "Python 컨벤션", "lint 실행" 요청 시 트리거.
allowed-tools: Bash(uv *) Bash(ruff *) Bash(mypy *) Bash(bandit *)
---

# 🐍 convention-py

## 목적
Python 코드가 부서 품질 기준(ruff·mypy·bandit·Snyk)을 충족하도록 강제한다.

## When to use
- Python 리포에서 코드 작성·수정 시 (자동 참조)
- 커밋 전 lint 실행 시

## 도구 및 실행 명령

### ruff (린트·포맷)
```bash
uv run ruff check src/ tests/          # 린트
uv run ruff check src/ tests/ --fix   # 자동 수정
uv run ruff format src/ tests/        # 포맷
```
설정: `pyproject.toml` → `[tool.ruff]`

### mypy (타입 체크)
```bash
uv run mypy src/ --strict
```
설정: `pyproject.toml` → `[tool.mypy]`

### bandit (보안 정적 분석)
```bash
uv run bandit -r src/ -ll
```
`-ll`: Medium 이상 이슈만 보고

### Snyk (의존성 취약점)
```bash
snyk test
```
신규 의존성 추가 시 반드시 실행 (AI Usage Rule 2)

## 코딩 스타일 규칙
- Line length: 88 (Black 호환)
- Import 순서: stdlib → third-party → local (isort)
- Type hint: 모든 public 함수 필수
- Docstring: public 클래스·함수에 한 줄 이상
- 예외: 구체적 예외 타입 (`except ValueError`, `except Exception` 지양)

## 자동 실행 순서
1. `ruff check --fix` → 자동 수정
2. `ruff format` → 포맷
3. `mypy` → 타입 오류 수동 수정
4. `bandit` → 보안 이슈 수동 수정
5. `pytest` → 테스트 통과 확인
