---
name: <workflow-name>
# 예: workflow-dev-story
description: |
  <!-- 언제 이 Workflow가 호출되는지 구체적으로 기술 -->
  <!-- 예: Story 구현 요청 시. "구현 시작", "코딩 해줘", "/workflow-dev-story" 트리거 -->
allowed-tools: Read Write Edit Grep Glob Bash(git *)
---

# 📋 <Workflow 이름>

## 역할
<!-- 이 Workflow가 담당하는 도메인과 결과물 한 문단 -->

## Phase 0: 기존 자료 감사 (필수, ADR-011)
<!-- 모든 Workflow 진입 시 수행 -->

1. 대상 산출물 경로에서 기존 파일 존재 확인
2. 파일이 있으면 내용 읽고 현재 상태 파악
3. 사용자 선택:
   - (a) 이어서 진행 (누락된 step만)
   - (b) 처음부터 재작성 (기존 보관 후 신규)
   - (c) 취소

## 단계 구성 (최대 5단계, ADR-012)
<!-- 각 step은 steps/ 하위 별도 파일로 관리 -->

| Step | 파일 | 담당 Agent | PT |
|---|---|---|---|
| 1 | `steps/step-01-<name>.md` | <!-- 예: agent-dev --> | <!-- 예: PT-01 --> |
| 2 | `steps/step-02-<name>.md` | | |
| 3 | `steps/step-03-<name>.md` | | |

## Input
- <!-- 입력 파일/데이터 목록 -->

## Output
- <!-- 생성되는 파일 목록 및 경로 규약 (S015) -->

## HITL
- L2: <!-- 사람 승인이 필요한 지점 -->

## 이벤트
```yaml
event_type: aidd_<stage>_event
workflow_id: <workflow-name>
step_id: <workflow-name>/step-NN
```
