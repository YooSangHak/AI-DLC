---
name: workflow-code-review-adversarial
description: |
  적대적 코드 리뷰 워크플로. Blind Hunter → Edge Case Hunter → Acceptance Auditor 3단계.
  "/workflow-code-review-adversarial", "코드 리뷰", "적대적 리뷰", "PR 리뷰" 요청 시 트리거.
  aidd-review-orchestrator의 reviewer-deep이 자동 호출하거나 수동 호출 가능.
allowed-tools: Read Grep Glob Bash(git *)
---

# 🔎 workflow-code-review-adversarial

## 역할
PR diff를 3단계 적대적 관점에서 검토하여 버그·보안·AC 미충족을 발견한다. (BMAD 차용)

## Phase 0: 기존 자료 감사 (필수)
1. PR diff 접근 확인
2. Story AC 목록 확인

## 단계 구성

| Step | 파일 | 관점 | 담당 |
|---|---|---|---|
| 1 | `steps/step-01-blind-hunter.md` | 힌트 없이 버그 탐색 | `agent-reviewer` |
| 2 | `steps/step-02-edge-case-hunter.md` | 경계 조건 탐지 | `agent-reviewer` |
| 3 | `steps/step-03-acceptance-auditor.md` | AC 충족 검증 | `agent-reviewer` |

> 모델은 `.claude/agents/reviewer.md` 의 tier 배정을 따른다. step 표에 모델명을
> 직접 적으면 에이전트 정의와 이중 관리가 되어 반드시 어긋난다.
>
> Step 1(Blind Hunter)은 **Story·AC 를 위임 프롬프트에 넣지 않는다.** 구현 의도를
> 모르는 상태에서 diff 만 보는 것이 이 단계의 전제다. Step 3 에서 비로소 AC 를 준다.

## 실행 방식 (위임)

단계 구성 표의 **담당** 컬럼은 표기가 아니라 실행 지시다. 각 step 은 해당
에이전트에게 **Task 도구로 위임**하며, 메인 세션에서 직접 수행하지 않는다.
위임하지 않으면 모델 라우팅·컨텍스트 격리·HITL 책임 소재가 모두 무효가 된다.

- 규약 전문: `.claude/skills/_shared/delegation.md`
- `subagent_type` 은 접두사 없는 이름을 쓴다 (`agent-dev` → `dev`)
- 위임 프롬프트에 step 파일 경로·입력 산출물 절대 경로·PT 경로·반환 형식을 명시한다
- 서브에이전트 실패 시 해당 step 에서 중단하고 보고한다 (메인 세션이 대신 수행 금지)

## Input
- PR diff
- Story AC 목록

## Output
- PR 리뷰 comment (`template.md` 형식)

## HITL
- L2: 사람 최종 승인 (Merge 전 필수)
