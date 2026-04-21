---
artifact_type: governance-policy
story: AIDD-S040
produced_by: agent-architect
consumed_by: [all-agents, aidd-sdlc-orchestrator, agent-janitor]
version: 2.0
date: 2026-04-21
---

# `_workspace/` 규약 + 이벤트 스키마 v2

---

## `_workspace/` 디렉터리 규약

### 구조
```
_workspace/
└── <workflow_run_id>/          # UUID, Orchestrator가 생성
    ├── 00_input/               # 초기 입력 (티켓·파일·자유 설명)
    │   └── input.md
    ├── 01_requirements.md      # agent-analyst 산출물
    ├── 02_adr.md               # agent-architect 산출물
    ├── 03_code_diff.md         # agent-dev diff 요약
    ├── 04_test_report.md       # agent-qa 결과
    └── 05_review_findings.md   # agent-reviewer 결과
```

### 운영 규칙
| 규칙 | 내용 |
|---|---|
| **삭제 금지** | Workflow 종료 후 즉시 삭제 불가 — 감사 추적용 보관 |
| **보관 기간** | 90일 (agent-janitor가 만료 파일 정리) |
| **Full 모드** | 기존 `_workspace/` → `_workspace_<YYYYMMDD_HHMMSS>/` 이동 후 신규 생성 |
| **읽기 전용** | Workflow 완료 후 수동 수정 금지 (감사 무결성) |
| **git-ignore** | `.gitignore`에 `_workspace/` 추가 (중간 산출물은 미커밋) |

### `.gitignore` 추가 항목
```gitignore
_workspace/
_workspace_*/
.aidd/events/
```

---

## 이벤트 스키마 v2

저장 위치: `.aidd/events/<YYYY-MM>.jsonl` (JSONL, 1줄 1이벤트)

### 공통 필드

```json
{
  "ts": "2026-04-21T09:00:00Z",
  "event_type": "aidd_interaction_event",
  "version": "2",
  "ticket_id": "JIRA-123",
  "session_id": "<claude-session-uuid>",
  "workflow_id": "workflow-dev-story",
  "workflow_run_id": "<uuid>",
  "step_id": "workflow-dev-story/step-02",
  "agent": "agent-dev",
  "model": "claude-sonnet-4-6",
  "result": "success",
  "detail": {}
}
```

### 신규 필드 (v2)

| 필드 | 타입 | 설명 |
|---|---|---|
| `workflow_id` | string | Workflow 이름 (e.g. `workflow-dev-story`) |
| `workflow_run_id` | string | UUID — 단일 실행 단위 식별 |
| `step_id` | string | `<workflow_id>/step-NN` 형식 |

### 이벤트 유형별 스키마

**aidd_interaction_event** (Agent 작업)
```json
{
  "event_type": "aidd_interaction_event",
  "agent": "agent-dev",
  "action": "implement",
  "input_tokens": 12000,
  "output_tokens": 3500,
  "cost_usd": 0.045,
  "duration_ms": 8200
}
```

**aidd_test_event** (QA 결과)
```json
{
  "event_type": "aidd_test_event",
  "agent": "agent-qa",
  "tests_total": 24,
  "tests_passed": 24,
  "coverage_pct": 87.3,
  "mutation_score": 0.72
}
```

**aidd_deploy_event** (배포)
```json
{
  "event_type": "aidd_deploy_event",
  "agent": "agent-deployer",
  "version": "v1.2.3",
  "canary_weight": 10,
  "environment": "canary"
}
```

**aidd_hitl_event** (HITL 승인)
```json
{
  "event_type": "aidd_hitl_event",
  "level": "L2",
  "approver": "user@org.com",
  "action": "approved",
  "artifact": "docs/adr/001-auth.md"
}
```

---

## 6월+ 계획

`mcp-observability` 연동으로 `.aidd/events/` → 사내 lakehouse 자동 적재.
5월은 로컬 JSONL 파일로 운영.
