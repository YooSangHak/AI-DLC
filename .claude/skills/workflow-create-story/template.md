---
artifact_type: story
produced_by: workflow-create-story
consumed_by: agent-dev, workflow-dev-story
constraints:
  - AC는 Given-When-Then 형식
  - 각 AC는 독립적으로 테스트 가능
explicit_ambiguities: []
---

# AIDD-S{nnn} — {Story 제목}

## Metadata
| Field | Value |
|---|---|
| Story Key | AIDD-S{nnn} |
| Priority | P0/P1/P2 |
| Estimation | {N}d |
| Assignee | {담당자} |

## User Story
**As a** {역할}, **I want** {목표}, **so that** {가치}.

## Acceptance Criteria
- [ ] **AC-1** Given {전제}, When {행동}, Then {결과}
- [ ] **AC-2** Given {전제}, When {행동}, Then {결과}

## Implementation Steps
1. [ ] {구현 단계}
2. [ ] {구현 단계}

## References
- PRD: `docs/prd/{ticket}.md`
- ADR: `docs/adr/*.md`
