---
artifact_type: decision
produced_by: AIDD-S015
consumed_by: agent-analyst, agent-pm, agent-architect, agent-dev, agent-qa, agent-reviewer, agent-deployer, aidd-sdlc-orchestrator
constraints:
  - 모든 Agent는 아래 경로 규약을 따라 산출물을 읽고 저장한다
  - 경로 규약 변경 시 이 문서와 CLAUDE.md 변경 이력 테이블 동시 업데이트
explicit_ambiguities: []
---

# 단계별 산출물 경로 규약 (AIDD-S015)

> Agent 간 순차 핸드오프의 유일한 매개체는 **Git 파일**.
> 경로·명명이 일관되어야 다음 단계 Agent가 입력을 안정적으로 참조한다.

## 경로 규약 표

| # | 단계 | 산출물 경로 | 명명 규약 | correlation |
|---|---|---|---|---|
| 1 | 요구 분석 | `docs/requirements/<ticket>.md` | `JIRA-123.md` | ticket |
| 2 | Spec | `docs/specs/<feature>.md` | `<feature-slug>.md` | ticket |
| 3 | Design (ADR) | `docs/adr/<nnn>-<title>.md` | `001-auth-login.md` | ticket |
| 4 | Design (상세) | `docs/design/<feature>.md` | `<feature-slug>.md` | ticket |
| 5 | Implement | `src/<module>/<feature>.py` (Py) / `src/<module>/<Feature>.ts` (TS) | 프로젝트 관례 | branch |
| 6 | Test | `tests/<module>/test_<feature>.py` (Py) / `tests/<module>/<feature>.test.ts` (TS) | pytest·Vitest 관례 | branch |
| 7 | Review | PR comment (GitHub) | — | PR number |
| 8 | Deploy | `CHANGELOG.md` + GitHub Release | SemVer (`v1.2.3`) | semver |
| 9 | Ops | `docs/postmortem/<incident>.md` | `YYYY-MM-DD-<slug>.md` | incident ID |

> **Ops(9)**: 6월+ 스코프. 5월은 수동 작성.

## Correlation Key 규약

```yaml
ticket: JIRA-123                  # 최상위 correlation — 모든 단계 공통
session_id: <uuid>                # Claude Code 세션 ID (선택)
branch: feature/JIRA-123-<slug>   # 브랜치명 표준
workflow_run_id: <uuid>           # 오케스트레이터 실행 단위
step_id: <workflow-name>/step-NN  # 단계 추적
```

## _workspace/ 중간 산출물 규약

```
_workspace/
└── <workflow_run_id>/
    ├── 00_input/                  # 초기 입력 (티켓·파일·자유 설명)
    ├── 01_requirements.md         # 요구 분석 산출물
    ├── 02_adr.md                  # Design ADR
    ├── 03_code_diff.md            # 구현 diff 요약
    ├── 04_test_report.md          # QA 테스트 결과
    └── 05_review_findings.md      # 리뷰 결과
```

## 브랜치 명명 규약

| 유형 | 패턴 | 예시 |
|---|---|---|
| 기능 구현 | `feature/<ticket>-<slug>` | `feature/JIRA-123-login` |
| 버그 수정 | `fix/<ticket>-<slug>` | `fix/JIRA-456-null-pointer` |
| 리팩터링 | `refactor/<ticket>-<slug>` | `refactor/JIRA-789-auth-cleanup` |
| 핫픽스 | `hotfix/<ticket>-<slug>` | `hotfix/JIRA-999-prod-crash` |

## ADR 번호 규약

- 3자리 숫자 (`001`, `002`, ...) + kebab-case 제목
- 예: `docs/adr/001-auth-jwt-strategy.md`
- ADR 상태: `Proposed` → `Accepted` → `Deprecated` / `Superseded`

## 변경 이력

| 날짜 | 변경 | 사유 |
|---|---|---|
| 2026-04-21 | 초안 작성 | AIDD-S015 |
