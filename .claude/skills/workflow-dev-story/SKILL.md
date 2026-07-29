---
name: workflow-dev-story
description: |
  Story 구현 워크플로. AC 기반 test-first 구현 → 테스트 → 문서화 → self-check 5단계.
  "/workflow-dev-story", "Story 구현", "기능 개발 시작", "AC 기반 구현" 요청 시 트리거.
  aidd-sdlc-orchestrator가 자동 호출하거나 개발자가 직접 호출.
allowed-tools: Read Write Edit Grep Glob Bash(git *) Bash(uv *) Bash(pnpm *) Bash(pytest *) Bash(vitest *)
---

# 💻 workflow-dev-story

## 역할
Story의 AC를 기반으로 test-first 원칙에 따라 구현·테스트·문서화·검증을 5단계로 수행한다.

## Phase 0: 기존 자료 감사 (필수)
1. Story 파일 존재 확인 (`docs/stories/<ID>.md`)
2. 관련 ADR 존재 확인 (`docs/adr/*.md`)
3. `src/` 기존 구현 여부 확인 (`git log --oneline feature/<ID>*`)
4. 사용자에게 상태 보고:
   - (a) 처음부터 시작
   - (b) 이어서 진행 (중단된 step부터)
   - (c) 취소

## 단계 구성

| Step | 파일 | 담당 | PT |
|---|---|---|---|
| 1 | `steps/step-01-context.md` | agent-dev | — |
| 2 | `steps/step-02-implement.md` | agent-dev | PT-01 |
| 3 | `steps/step-03-test.md` | agent-qa | PT-06 |
| 4 | `steps/step-04-docs.md` | agent-dev | PT-07 |
| 5 | `steps/step-05-self-check.md` | agent-dev | — |

## 실행 방식 (위임)

단계 구성 표의 **담당** 컬럼은 표기가 아니라 실행 지시다. 각 step 은 해당
에이전트에게 **Task 도구로 위임**하며, 메인 세션에서 직접 수행하지 않는다.
위임하지 않으면 모델 라우팅·컨텍스트 격리·HITL 책임 소재가 모두 무효가 된다.

- 규약 전문: `.claude/skills/_shared/delegation.md`
- `subagent_type` 은 접두사 없는 이름을 쓴다 (`agent-dev` → `dev`)
- 위임 프롬프트에 step 파일 경로·입력 산출물 절대 경로·PT 경로·반환 형식을 명시한다
- 서브에이전트 실패 시 해당 step 에서 중단하고 보고한다 (메인 세션이 대신 수행 금지)

## Input
- Story 파일 (`docs/stories/<ID>.md`)
- ADR (`docs/adr/*.md`)
- CLAUDE.md (Stack·Conventions)

## Output
- `src/<module>/<feature>.py` 또는 `.ts`
- `tests/<module>/test_<feature>.py` 또는 `.test.ts`
- PR (GitHub)

## HITL
- L1: 단위 테스트 통과 시 자동 커밋
- L2: PR 생성 후 사람 최종 승인
- L3: DB 마이그레이션·스키마 변경 2인+SRE

## 이벤트
```yaml
event_type: aidd_interaction_event
workflow_id: workflow-dev-story
```
