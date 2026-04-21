---
artifact_type: adr
story: AIDD-S039
produced_by: agent-architect
consumed_by: [agent-dev, aidd-sdlc-orchestrator]
status: Accepted
date: 2026-04-21
---

# ARCH-Q7: PM 역할 신설

## Status
Accepted

## Context
기술 상세 PDF는 "기획" 단일 단계로 기술. BMAD 차용으로 **분석가(analyst) + PM** 2역할 분리 검토.
현재 구현된 Agent: analyst·pm·architect·dev·qa·reviewer·deployer·janitor (8종).

## Decision
**(a) PM 신설** — analyst(요구수집·현황분석)와 pm(PRD·Story·우선순위)을 분리 유지.

## Consequences
### 긍정적
- BMAD 역할 분담 명확성 — 요구수집과 우선순위 결정이 분리되어 책임 명확
- 외부 고객 전파 시 "PM 에이전트"로 소통 창구 명확
- Story AC 작성 품질 향상 (전담 역할)

### 부정적
- Agent 수 증가 (6→8종) — 컨텍스트·비용 증가 가능성
- analyst↔pm 핸드오프 경계 불명확 시 중복 작업 위험

### 중립적
- S020에서 8종 Agent 이미 구현 완료 — 변경 없음

## Alternatives Considered
1. **(b) PM 통합** — analyst가 두 역할 겸임. 거부 이유: PRD·Story 품질 저하 우려, 단일 Agent 컨텍스트 과부하
2. **(c) 분석가 제거** — PM만 남김. 거부 이유: 요구수집 특화 역할 필요

## References
- AIDD-S020 (8종 Agent 구현)
- BMAD Agent 설계 원칙
