---
name: workflow-create-story
description: |
  Epic·Story 분해 워크플로. PRD·ADR 읽기 → Epic/Story 분해 → AC 작성 3단계.
  "/workflow-create-story", "Story 분해", "Epic 분해", "AC 작성" 요청 시 트리거.
allowed-tools: Read Write Edit Grep Glob
---

# 📋 workflow-create-story

## 역할
PRD·ADR을 기반으로 Epic을 Story로 분해하고 AC를 작성한다.

## Phase 0: 기존 자료 감사 (필수)
1. `docs/prd/<ticket>.md` (PRD) 존재 확인
2. `docs/adr/*.md` 존재 확인
3. `docs/stories/*.md` 기존 Story 존재 확인

## 단계 구성

| Step | 파일 | 담당 |
|---|---|---|
| 1 | `steps/step-01-read-prd-adr.md` | agent-pm |
| 2 | `steps/step-02-decompose.md` | agent-pm |
| 3 | `steps/step-03-write-ac.md` | agent-pm |

## 실행 방식 (위임)

단계 구성 표의 **담당** 컬럼은 표기가 아니라 실행 지시다. 각 step 은 해당
에이전트에게 **Task 도구로 위임**하며, 메인 세션에서 직접 수행하지 않는다.
위임하지 않으면 모델 라우팅·컨텍스트 격리·HITL 책임 소재가 모두 무효가 된다.

- 규약 전문: `.claude/skills/_shared/delegation.md`
- `subagent_type` 은 접두사 없는 이름을 쓴다 (`agent-dev` → `dev`)
- 위임 프롬프트에 step 파일 경로·입력 산출물 절대 경로·PT 경로·반환 형식을 명시한다
- 서브에이전트 실패 시 해당 step 에서 중단하고 보고한다 (메인 세션이 대신 수행 금지)

## Output
- `docs/stories/<ticket>-EPIC-<n>.md` (Epic 파일들)
- `docs/stories/<ticket>-S*.md` (Story 파일들)

## HITL
- L2: Story 분해 결과 사람 승인
