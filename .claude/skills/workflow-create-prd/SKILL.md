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

## Input
- Jira 티켓 ID 또는 자유 설명
- 기존 `docs/requirements/*.md` (analyst 산출물, 있으면)

## Output
- `docs/prd/<ticket>.md`

## HITL
- L2: PRD 작성 완료 후 사람 승인
