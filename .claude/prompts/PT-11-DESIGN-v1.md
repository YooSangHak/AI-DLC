---
id: PT-11-DESIGN-v1
purpose: ADR·API 설계 결정 문서화
subagent: agent-architect
model_hint: Opus 4.7 + GPT-5 교차 검증
inputs:
  - Spec (docs/specs/<feature>.md)
  - 기존 ADR (docs/adr/*.md)
  - PRD (docs/requirements/<ticket>.md)
outputs:
  - docs/adr/<nnn>-<title>.md
  - docs/design/<feature>.md
hitl_gate: L2
automation_tier: medium
---

# PT-11 — ADR·설계 결정 문서화

## 목적
Spec을 기반으로 아키텍처 결정을 내리고 ADR과 설계 상세 문서를 작성한다.
Opus 4.7과 GPT-5 교차 검증으로 설계 품질을 높인다.

## 전제 조건
- Spec 존재 (`docs/specs/<feature>.md`)
- 기존 ADR 확인 (`docs/adr/`)

## 입력
```
Spec 경로: {spec_path}
티켓 ID: {ticket_id}
ADR 번호: {adr_number}  # 예: 001
제목: {adr_title}       # kebab-case
```

## 작업 지시
1. Spec을 읽고 설계 결정이 필요한 사항을 식별한다
2. 기존 ADR을 검토하여 일관성을 확인한다
3. 각 설계 결정에 대해 **3가지 대안**을 검토한다
4. 트레이드오프(성능·보안·복잡성·비용)를 분석한다
5. 최선의 대안을 선택하고 근거를 명시한다
6. Mermaid 다이어그램으로 구조를 시각화한다
7. AI Consumer Metadata(ADR-016)를 포함한다
8. GPT-5 교차 검증: 다른 모델 관점에서 설계 검토 (`agent-architect` 메뉴 OP 활용)

## 출력 형식 (ADR)
```markdown
---
artifact_type: adr
produced_by: PT-11-DESIGN-v1/agent-architect
consumed_by: agent-dev, agent-qa
constraints:
  - <하류 Agent가 반드시 따라야 할 제약>
explicit_ambiguities:
  - <불명확한 부분 — HITL L2 승격>
---

# ADR-{nnn}: {제목}

## 상태
Proposed

## 컨텍스트
<!-- 왜 이 결정이 필요한가 -->

## 결정
<!-- 무엇을 결정했는가 -->

## 대안 검토
| 대안 | 장점 | 단점 |
|---|---|---|

## 근거
<!-- 왜 이 대안을 선택했는가 -->

## 결과
<!-- 이 결정의 영향 -->

## 다이어그램
\`\`\`mermaid
...
\`\`\`
```

## 제약
- HITL L2: 사람 최종 승인 필수 (설계 결정은 되돌리기 어려움)
- explicit_ambiguities 항목은 반드시 사람에게 확인
- 기존 ADR과 충돌 시 즉시 보고

## 이벤트
```yaml
event_type: aidd_design_event
prompt_template_id: PT-11-DESIGN-v1
sdlc_stage: design
```
