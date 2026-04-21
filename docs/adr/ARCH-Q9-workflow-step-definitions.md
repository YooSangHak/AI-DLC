---
artifact_type: adr
story: AIDD-S039
produced_by: agent-architect
consumed_by: [workflow-dev-story, workflow-create-prd, workflow-create-architecture, workflow-create-story, workflow-code-review-adversarial]
status: Accepted
date: 2026-04-21
---

# ARCH-Q9: Workflow 5종 단계 정확한 정의

## Status
Accepted

## Context
S035 L2 Workflow 구현 전 5개 Workflow의 단계 이름과 책임을 확정해야 블로킹 해소.

## Decision
아래 5종 Workflow의 단계를 확정. 단계 이름은 명사(컨텍스트·구현·테스트 등)로 통일.

### workflow-create-prd (3단계)
| Step | 이름 | 책임 |
|---|---|---|
| 01 | analyze | 입력 분석·이해관계자·제약 파악 |
| 02 | write | FR·NFR·AC 작성 |
| 03 | validate | 완전성·INVEST 검증 |

### workflow-create-architecture (5단계)
| Step | 이름 | 책임 |
|---|---|---|
| 01 | context | PRD·기존 ADR·기술 스택 수집 |
| 02 | decisions | 핵심 결정 3~5개 + ADR 작성 |
| 03 | pattern | 6 아키텍처 패턴 중 선택 |
| 04 | structure | 컴포넌트·다이어그램·데이터 흐름 |
| 05 | validation | create-architecture-checklist Skill |

### workflow-create-story (3단계)
| Step | 이름 | 책임 |
|---|---|---|
| 01 | read-prd-adr | PRD·ADR 읽기·FR 목록 파악 |
| 02 | decompose | INVEST 원칙으로 Story 분해 |
| 03 | write-ac | AC 작성·DoD 정의 |

### workflow-dev-story (5단계)
| Step | 이름 | 책임 |
|---|---|---|
| 01 | context | 컨텍스트 로드·브랜치 생성 |
| 02 | implement | PT-01 기반 test-first 구현 |
| 03 | test | PT-06 기반 경계면·엣지케이스 테스트 |
| 04 | docs | PT-07 기반 API·모듈 문서 |
| 05 | self-check | commit-guardrail·PR 생성 |

### workflow-code-review-adversarial (3단계)
| Step | 이름 | 책임 |
|---|---|---|
| 01 | blind-hunter | AC 없이 diff만 보고 버그·보안 탐색 |
| 02 | edge-case-hunter | 경계 조건 6축 검증 |
| 03 | acceptance-auditor | AC별 구현 증빙 검사 |

## Consequences
### 긍정적
- S035 구현 블로킹 해소
- 5종 Workflow 단계 이름이 파일명·SKILL.md와 일치 (step-01-context.md 등)
- 향후 추가 Workflow도 동일 패턴 적용 가능

### 부정적
- 5단계 Workflow(create-architecture·dev-story)는 단계 수가 많아 컨텍스트 누적 위험
  → Phase 0 감사로 필요 단계만 실행하여 완화

### 중립적
- 모든 단계 이름이 S035 산출물 파일명과 이미 일치 확인됨

## Alternatives Considered
1. **단계 추가** (6단계+) — 거부: 컨텍스트 과부하
2. **단계명 동사형** ("구현하라") — 거부: 파일명 가독성 저하, 명사형 유지

## References
- AIDD-S035 (L2 Workflow 구현)
- phase-selection-matrix.md
