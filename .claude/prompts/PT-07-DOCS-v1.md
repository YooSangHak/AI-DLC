---
id: PT-07-DOCS-v1
purpose: 코드·API 문서화
subagent: 공통
model_hint: Sonnet 4.6
inputs:
  - 구현 코드 또는 API spec
  - 문서화 대상 (module | api | architecture)
outputs:
  - docs/<type>/<name>.md
hitl_gate: L1
automation_tier: high
---

# PT-07 — 코드·API 문서화

## 목적
구현 코드 또는 API를 기반으로 개발자가 바로 사용할 수 있는 문서를 생성한다.

## 전제 조건
- 구현 코드 또는 OpenAPI spec 존재

## 입력
```
문서화 대상: {target_path}
문서 유형: {doc_type}
  # module | api | architecture
출력 경로: docs/{doc_type}/{name}.md
```

## 작업 지시
1. 대상 코드·스펙을 읽고 핵심 인터페이스·엔드포인트를 파악한다
2. 문서 유형에 맞게 작성한다:
   - **module**: 역할·입출력·사용 예시·제약
   - **api**: 엔드포인트·요청·응답·에러코드·예시
   - **architecture**: 컴포넌트·데이터 흐름·Mermaid 다이어그램
3. 코드 예시는 실제 동작하는 스니펫으로 작성한다
4. AI Consumer Metadata(ADR-016) frontmatter를 포함한다

## 출력 형식 (module)
```markdown
---
artifact_type: docs
produced_by: PT-07-DOCS-v1
consumed_by: 개발자, agent-dev
---

# {모듈명}

## 역할
<!-- 한 문단 -->

## 인터페이스
| 함수/클래스 | 입력 | 출력 | 설명 |
|---|---|---|---|

## 사용 예시
\`\`\`python
...
\`\`\`

## 제약·주의사항
```

## 제약
- 구현 상세가 아닌 **사용자 관점** 문서화
- 예시 코드에 실제 비밀·PII 사용 금지

## 이벤트
```yaml
event_type: aidd_interaction_event
prompt_template_id: PT-07-DOCS-v1
sdlc_stage: docs
```
