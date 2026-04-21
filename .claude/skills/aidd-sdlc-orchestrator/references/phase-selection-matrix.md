# Phase 선택 매트릭스

> Phase 0 감사 결과에 따라 어떤 Workflow를 호출할지 결정하는 기준표.

## Workflow 호출 매트릭스

| 요구사항 | Spec | ADR | 구현 | 테스트 | 호출 Workflow |
|---|---|---|---|---|---|
| ❌ | ❌ | ❌ | ❌ | ❌ | create-prd → create-architecture → create-story → dev-story |
| ✅ | ❌ | ❌ | ❌ | ❌ | create-architecture → create-story → dev-story |
| ✅ | ✅ | ❌ | ❌ | ❌ | create-architecture → dev-story |
| ✅ | ✅ | ✅ | ❌ | ❌ | dev-story |
| ✅ | ✅ | ✅ | ✅ | ❌ | dev-story (step-03-test부터) |
| ✅ | ✅ | ✅ | ✅ | ✅ | PR 생성 → aidd-review-orchestrator |

## 파일 모드별 진입 단계

| 파일 유형 | 경로 패턴 | 진입 단계 |
|---|---|---|
| Story | `stories/AIDD-S*.md` | AC·Steps 추출 → dev-story |
| 요구사항 | `docs/requirements/*.md` | create-architecture부터 |
| ADR | `docs/adr/*.md` | dev-story부터 |
| Spec | `docs/specs/*.md` | create-architecture부터 |
| 일반 Markdown | 그 외 `.md` | 내용을 자유 입력으로 취급 → create-prd부터 |

## Workflow 실행 순서 (순차, ADR-003)

```
create-prd
  └── create-architecture
        └── create-story
              └── dev-story
                    └── [PR 생성] → aidd-review-orchestrator
```

## 단독 Workflow 호출 가능 (Harness 원칙)

오케스트레이터 없이도 각 Workflow를 직접 호출 가능:
- `/workflow-create-prd`
- `/workflow-create-architecture`
- `/workflow-create-story`
- `/workflow-dev-story`
- `/workflow-code-review-adversarial`
