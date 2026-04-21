---
name: commit-guardrail
description: |
  커밋 전 300 LOC·비밀·PII 위반 자동 차단. 모든 코드 작업에 항상 적용.
  "/commit-guardrail", "커밋 전 점검", "diff 크기 확인" 요청 시 트리거.
  agent-dev·agent-qa가 커밋 전 자동 참조 — 위반 시 커밋 중단하고 분할 방법 제안.
allowed-tools: Grep Bash(git *)
---

# 🛡️ commit-guardrail

## 목적
커밋 전 300 LOC 초과·비밀·PII 위반을 차단하여 품질 게이트를 지킨다.

## When to use
- 모든 `git commit` 전 (자동 참조)
- PR 생성 전 self-check

## Steps

### 1. Diff 크기 점검
```bash
git diff --cached --stat | tail -1
# 또는
git diff HEAD --stat | tail -1
```
- 300 LOC 초과 시: 커밋 중단 → 작업 분할 제안
- 분할 기준: 기능 단위·AC 단위·파일 단위

### 2. 비밀·PII 스캔
```bash
# API 키·토큰
git diff --cached | grep -E "(api[_-]?key|api[_-]?token|secret)\s*=\s*['\"][^'\"]{8,}"
# 비밀번호
git diff --cached | grep -E "(password|passwd)\s*=\s*['\"][^'\"]+"
```
발견 시: 즉시 커밋 차단, 환경변수로 대체 안내

### 3. .env 파일 점검
```bash
git diff --cached --name-only | grep "\.env"
```
`.env` 커밋 시 즉시 차단

## 판정 기준
| 항목 | 통과 | 실패 |
|---|---|---|
| diff 크기 | ≤300 LOC | >300 LOC → 분할 요청 |
| 비밀·토큰 | 없음 | 발견 → 커밋 차단 |
| PII | 없음 | 발견 → 커밋 차단 |
| .env 파일 | 스테이징 없음 | 스테이징됨 → 차단 |

## 실패 시 대응
- **300 LOC 초과**: "이 커밋을 AC별로 분할하겠습니다" → 분할 실행
- **비밀 발견**: "환경변수(`os.environ.get`)로 대체하겠습니다" → 수정 후 재시도
- **PII 발견**: 즉시 보고 후 마스킹 처리
