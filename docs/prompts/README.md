# Prompt Templates (PT-NN) 인덱스

> PT 파일 위치: `.claude/prompts/PT-NN-<purpose>-v1.md`
> 공통 헤더 포맷: `docs/prompts/_template.md`
> Workflow step이 PT를 로드해서 사용 (ADR-013, S022c 배포)

## P0 — 5월 배포 대상 (7종)

| PT | 파일명 | 목적 | 담당 Agent | 모델 | 입력 | 출력 | HITL |
|---|---|---|---|---|---|---|---|
| PT-01 | `PT-01-IMPLEMENT-v1.md` | Story AC 기반 코드 구현 | agent-dev | Sonnet 4.6 / GPT-5(Java) | Design + Spec + Story | `src/` 코드 diff | L1 |
| PT-03 | `PT-03-REVIEWER-v1.md` | PR diff 코드 리뷰 | agent-reviewer | Haiku 4.5 + Sonnet 4.6 | PR diff | 리뷰 comment | L2 |
| PT-05 | `PT-05-LEGACY-UNDERSTAND-v1.md` | 레거시 코드 이해·문서화 | 공통 | Gemini 2.5 Pro (2M) | 레거시 코드 | 요약·구조 문서 | L1 |
| PT-06 | `PT-06-TEST-ADD-v1.md` | 테스트 코드 생성 | agent-qa | Sonnet 4.6 | 구현 코드 | `tests/` 테스트 | L1 |
| PT-07 | `PT-07-DOCS-v1.md` | 코드·API 문서화 | 공통 | Sonnet 4.6 | 코드 / API spec | Markdown 문서 | L1 |
| PT-09 | `PT-09-DEPS-UPDATE-v1.md` | 의존성 업데이트 제안 | 공통 | Sonnet 4.6 | deps lockfile | 업데이트 제안·공급망 체크 | L2 |
| PT-11 | `PT-11-DESIGN-v1.md` | ADR·API 설계 결정 | agent-architect | Opus 4.7 + GPT-5 교차 | Spec | ADR + Mermaid 다이어그램 | L2 |

## Workflow 참조 매핑

| Workflow | Step | PT |
|---|---|---|
| `workflow-dev-story` | step-02-implement | PT-01 |
| `workflow-dev-story` | step-03-test | PT-06 |
| `workflow-dev-story` | step-04-docs | PT-07 |
| `workflow-create-architecture` | step-02-decisions | PT-11 |
| `workflow-code-review-adversarial` | step-01-blind-hunter | PT-03 |

## P1/P2 이연 — 6월+ 추가 예정 (15종)

| PT | 목적 | 예정 |
|---|---|---|
| PT-02 | 요구사항 정제 | 6월 |
| PT-04 | 보안 취약점 분석 | 6월 |
| PT-08 | 성능 최적화 | 6월 |
| PT-10 | DB 마이그레이션 | 6월 |
| PT-12 | API 계약 테스트 | 6월 |
| PT-13 | 인프라 IaC 생성 | 7월 |
| PT-14 | 접근성 검사 (WCAG) | 7월 |
| PT-15 | 라이선스 검사 | 7월 (법무 협의 후) |
| PT-16 | 회고 분석 | 7월 |
| PT-17 | 기술 부채 식별 | 7월 |
| PT-18 | 모니터링 알림 설계 | 8월 |
| PT-19 | 데이터 품질 검사 | 8월 |
| PT-20 | 멀티모달 분석 | 8월 |
| PT-21 | 변경 영향도 분석 | 9월 |
| PT-22 | 아키텍처 진화 제안 | 9월 |

## 변경 이력

| 날짜 | 변경 | 사유 |
|---|---|---|
| 2026-04-21 | 인덱스 초안 | AIDD-S022a |
