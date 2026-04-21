# Project: AIDD Agent Test Workspace

## Stack
- Language: Python 3.13 (기본) / TypeScript 5.6
- Build: uv (Py) / pnpm (TS)

## Architecture
- AIDD 5계층 자산 구조 Agent 단위 검증용 워크스페이스
- 상세: `../Workspace_AX_Enabling_Tech_AIDD/doc/AIDD_2026_05월_아키텍처.md`

## Conventions
- Code style: ruff (Py) / biome (TS)
- Commit: Conventional Commits
- Branch: feature/<ticket>-<slug>

## AI Usage Rules
1. 300 LOC 초과 diff 금지
2. 신규 의존성: 공급망 체크
3. 비밀·PII 입력 금지
4. 블랙리스트 명령은 2인 확인
5. Spec 없는 기능 구현 금지

## HITL
- L1 (자동): 린트·단위 테스트·PR diff 요약
- L2 (인간): Spec·ADR·PR 최종 승인
- L3 (2인+): 프로덕션 배포·파괴적 작업

## Agents (8종, 한국어 역할명)
- `agent-analyst` 🔍 분석가 — 요구 분석
- `agent-pm` 📋 PM — PRD·Story
- `agent-architect` 🏗️ 아키텍트 — ADR·Design
- `agent-dev` 💻 개발자 — 구현
- `agent-qa` 🧪 QA — 테스트·경계면
- `agent-reviewer` 🔎 리뷰어 — PR 리뷰
- `agent-deployer` 🚀 배포 담당 — Release·Canary
- `agent-janitor` 🧹 청소부 — 주간 감사

## 변경 이력
| 날짜 | 변경 | 대상 | 사유 |
|---|---|---|---|
| 2026-04-20 | 초기 구성 | 전체 | Agent 8종 검증 환경 구축 |
