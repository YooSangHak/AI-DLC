---
name: workflow-create-prd
description: |
  PRD 작성 워크플로. 요구 분석 → PRD 작성 → 검증 3단계.
  "/workflow-create-prd", "PRD 작성", "요구사항 정리", "제품 요구사항 문서" 요청 시 트리거.
allowed-tools: Read Write Edit Grep Glob
---

# 📋 workflow-create-prd

## 역할
Jira 티켓·자유 입력을 기반으로 PRD를 3단계로 작성한다.

## Phase 0: 기존 자료 감사 (필수)
1. `docs/prd/<ID>.md` 존재 여부 확인
2. 있으면 내용 읽고 현재 상태 파악
3. 사용자 선택: (a) 이어서 (b) 재작성 (c) 취소

## 단계 구성

| Step | 파일 | 담당 | PT |
|---|---|---|---|
| 1 | `steps/step-01-analyze.md` | agent-analyst | — |
| 2 | `steps/step-02-write.md` | agent-pm | — |
| 3 | `steps/step-03-validate.md` | agent-pm | — |

## 실행 방식 (위임)

단계 구성 표의 **담당** 컬럼은 표기가 아니라 실행 지시다. 각 step 은 해당
에이전트에게 **Task 도구로 위임**하며, 메인 세션에서 직접 수행하지 않는다.
위임하지 않으면 모델 라우팅·컨텍스트 격리·HITL 책임 소재가 모두 무효가 된다.

- 규약 전문: `.claude/skills/_shared/delegation.md`
- `subagent_type` 은 접두사 없는 이름을 쓴다 (`agent-dev` → `dev`)
- 위임 프롬프트에 step 파일 경로·입력 산출물 절대 경로·PT 경로·반환 형식을 명시한다
- 서브에이전트 실패 시 해당 step 에서 중단하고 보고한다 (메인 세션이 대신 수행 금지)

## Input
- Jira 티켓 ID 또는 자유 설명
- 기존 `docs/requirements/*.md` (analyst 산출물, 있으면)

## Output
- `docs/prd/<ticket>.md`

## HITL
- L2: PRD 작성 완료 후 사람 승인
