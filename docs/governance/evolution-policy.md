---
artifact_type: governance-policy
story: AIDD-S038
produced_by: agent-architect
consumed_by: [all-agents, agent-janitor, retrospective-skill]
version: 1.0
date: 2026-04-21
---

# CLAUDE.md 진화 정책 (Harness Phase 7)

> ADR-015, PRD FR-11.1·AC-22 기반.
> CLAUDE.md·Skills·Workflows는 정적 산출물이 아닌 실행 후 피드백을 반영하는 시스템.

---

## 진화 트리거 조건

아래 조건 중 하나라도 충족되면 해당 자산을 수정하고 변경 이력에 기록한다:

| 조건 | 판단 기준 | 수정 주체 |
|---|---|---|
| 같은 유형 피드백 **2회+ 반복** | 회고 기록·이벤트 로그에서 패턴 확인 | agent-janitor 주간 감사 |
| Agent **반복 실패 패턴** | 동일 단계에서 3회+ 오류 | 아키텍트 수동 확인 |
| 사용자가 Orchestrator **우회** 수동 작업 | `.aidd/events/*.jsonl` 이상 패턴 | 아키텍트 수동 확인 |
| **분기 회고**에서 개선 합의 | `retrospective` Skill 결과 | 팀 합의 |

---

## 피드백 유형 → 수정 대상 매핑

| 피드백 유형 | 수정 대상 | 예시 |
|---|---|---|
| 결과물 품질 부족 | 해당 Agent의 SKILL.md | "분석이 피상적" → Skill에 깊이 기준 추가 |
| Agent 역할 불명확 | Agent 정의 `.md` | "보안 검토 필요" → agent-security 신규 |
| Workflow 순서 비효율 | Workflow steps/ | "검증 먼저" → steps 순서 변경 |
| 팀 구성 중복 | Orchestrator + Agent | "둘 합쳐도 됨" → Agent 병합 |
| 트리거 누락 | Skill description | "이 표현으로 안 됨" → description 확장 |
| HITL 과다/부족 | CLAUDE.md HITL Matrix | L2 → L1 격하 또는 L2 격상 |

---

## 변경 이력 기록 규칙

1. **즉시 기록**: 모든 Agent·Skill·Workflow 변경 시 CLAUDE.md 하단 `## 변경 이력` 테이블에 추가
2. **형식 준수**: `날짜 | 변경 내용 | 대상 | 사유` (사유에 Story ID 또는 피드백 출처 명시)
3. **자동 회고 연계**: `retrospective` Skill 실행 시 → 변경 이력 자동 반영
4. **최소 단위**: 1줄 1변경 (여러 파일 묶어서 1줄 기록 가능, 단 사유 명확히)

---

## 변경 이력 테이블 포맷

```markdown
## 변경 이력
| 날짜 | 변경 내용 | 대상 | 사유 |
|---|---|---|---|
| 2026-05-01 | 초기 구성 | 전체 | 5월 통합 AIDD 환경 구축 (AIDD-S018) |
| 2026-05-15 | agent-qa 경계면 체크리스트 추가 | skills/agent-qa | Dogfooding: 경계면 버그 누락 패턴 |
| 2026-05-22 | security-review Skill 강화 | skills/security-review | OWASP ASI 2026 반영 |
```

---

## 분기 회고 주기

| 주기 | 트리거 | 담당 |
|---|---|---|
| 주간 | agent-janitor 감사 리포트 | 아키텍트 검토 |
| 월간 | `retrospective` Skill 실행 | 팀 전체 |
| 분기 | 누적 분석 → 구조 변경 결정 | 팀장 + 아키텍트 |

---

## 자산별 변경 영향 범위

```
CLAUDE.md 변경
  └─ 모든 Agent에 즉시 반영 (다음 세션부터)

SKILL.md 변경
  └─ 해당 Agent/Skill만 영향
  └─ CLAUDE.md 변경 이력 기록 필수

Workflow steps/ 변경
  └─ 해당 Workflow만 영향
  └─ phase-selection-matrix.md 업데이트 필요 시

Orchestrator SKILL.md 변경
  └─ 전체 SDLC 흐름 영향 → L2 승인 필수
```
