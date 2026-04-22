# 피드백 유형 분류 → 수정 대상 매핑

| 피드백 유형 | 수정 대상 | 우선순위 |
|---|---|---|
| Agent 페르소나 부정확 | `.claude/skills/agent-*/SKILL.md` | P1 |
| Workflow 단계 누락 | `workflow-*/steps/*.md` | P0 |
| PT 지시 불명확 | `.claude/prompts/PT-*.md` | P1 |
| AI Usage Rules 위반 반복 | `CLAUDE.md` 규칙 추가 | P0 |
| 컨텍스트 감사 누락 | Workflow Phase 0 보강 | P0 |
| 산출물 경로 불일치 | 해당 스킬 `Output` 섹션 경로 수정 | P1 |
| 보안 취약점 반복 | `security-review` Skill 체크리스트 추가 | P0 |
| 테스트 커버리지 미달 | `commit-guardrail` 기준 강화 | P1 |
