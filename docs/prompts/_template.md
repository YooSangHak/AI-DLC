# PT-NN 공통 헤더 템플릿

모든 PT 파일은 아래 YAML frontmatter로 시작한다.

```yaml
---
id: PT-NN-<purpose>-v<n>
# 예: PT-01-IMPLEMENT-v1
purpose: <한 줄 목적>
# 예: Story AC 기반 코드 구현
subagent: <호출 대상 Agent>
# agent-dev | agent-qa | agent-architect | agent-reviewer | 공통
model_hint: <권장 모델>
# Sonnet 4.6 | Opus 4.7 | Haiku 4.5 | Gemini 2.5 Pro
inputs:
  - <입력 변수 1>
  - <입력 변수 2>
outputs:
  - <출력 형태>
hitl_gate: L1
# L1(자동) | L2(인간 리뷰) | L3(2인+SRE)
automation_tier: high
# high(완전 자동) | medium(부분 확인) | low(인간 주도)
---
```

## 본문 구조

```markdown
# <PT 제목>

## 목적
<!-- 이 PT가 해결하는 문제 -->

## 전제 조건
<!-- 실행 전 준비되어야 하는 것 -->

## 입력
<!-- inputs 상세 설명 -->

## 작업 지시
<!-- AI에게 전달하는 구체적 지시 (동사 시작) -->
1.
2.
3.

## 출력 형식
<!-- 생성되는 파일 경로·포맷 -->

## 제약
<!-- AI Usage Rules 중 이 PT에 특히 적용되는 것 -->

## 이벤트
\`\`\`yaml
event_type: aidd_<stage>_event
prompt_template_id: PT-NN-<purpose>-v1
\`\`\`
```
