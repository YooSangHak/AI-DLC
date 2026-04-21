---
artifact_type: adr
story: AIDD-S039
produced_by: agent-architect
consumed_by: [agent-dev, aidd-sdlc-orchestrator]
status: Accepted
date: 2026-04-21
---

# ARCH-Q8: customize.toml 3-layer 도입 시점

## Status
Accepted

## Context
BMAD의 `base → team → user` 3-layer 커스터마이즈 구조를 5월 스코프에 포함할지 결정.
5월은 SKILL.md 단일 파일로 Agent·Skill 정의. toml 레이어는 팀별 오버라이드를 위한 확장.

## Decision
**(b) 6월+ 이연** — 5월은 단일 SKILL.md 유지, 6월 팀 운영 안정화 후 도입.

## Consequences
### 긍정적
- 5월 스코프 과부하 방지 — 핵심 기능에 집중
- 단순성 유지 — 신규 개발자 진입 장벽 낮음

### 부정적
- 팀별 커스터마이즈 불가 — 5월 중 단일 표준만 적용
- 6월 도입 시 SKILL.md → toml 마이그레이션 작업 필요

### 중립적
- S014 스켈레톤에 `customize.toml` 미포함 확정 (현 상태 유지)

## Alternatives Considered
1. **(a) 5월 도입** — 거부 이유: W3~W4 다른 P0 스토리와 충돌, 과부하
2. **(c) 영구 미도입** — 거부 이유: 팀 규모 확대 시 단일 표준 경직성 문제

## References
- AIDD-S014 (스켈레톤 3종)
- BMAD customize.toml 설계 문서
