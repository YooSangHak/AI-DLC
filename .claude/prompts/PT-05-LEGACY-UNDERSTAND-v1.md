---
id: PT-05-LEGACY-UNDERSTAND-v1
purpose: 레거시 코드 이해·구조 문서화
subagent: 공통
model_hint: Gemini 2.5 Pro (2M context)
inputs:
  - 레거시 코드 파일 또는 디렉터리
  - 분석 목적 (이해·마이그레이션·리팩터링)
outputs:
  - docs/design/<module>-legacy-analysis.md
hitl_gate: L1
automation_tier: medium
---

# PT-05 — 레거시 코드 이해·문서화

## 목적
2M 컨텍스트를 활용해 대규모 레거시 코드베이스를 분석하고
구조·의존성·핵심 로직을 문서화한다.

## 전제 조건
- Gemini 2.5 Pro (2M) 모델 사용 (대용량 컨텍스트 필수)
- 분석 대상 코드 경로 확정

## 입력
```
분석 대상: {legacy_path}
분석 목적: {purpose}
  # understand | migration | refactoring
출력 경로: docs/design/{module}-legacy-analysis.md
```

## 작업 지시
1. 대상 경로의 파일 구조 전체를 파악한다
2. 진입점(main·entry·bootstrap)을 찾아 흐름을 추적한다
3. 핵심 모듈·클래스·함수 목록을 작성한다
4. 외부 의존성(라이브러리·API·DB)을 식별한다
5. 순환 의존성·기술 부채를 표시한다
6. Mermaid 다이어그램으로 구조를 시각화한다
7. 마이그레이션/리팩터링 시 주의사항을 기록한다

## 출력 형식
```markdown
# {module} 레거시 분석

## 요약
<!-- 3~5줄 핵심 요약 -->

## 파일 구조
<!-- 트리 형식 -->

## 핵심 컴포넌트
| 컴포넌트 | 역할 | 의존성 |
|---|---|---|

## 데이터 흐름
\`\`\`mermaid
flowchart TD
  ...
\`\`\`

## 기술 부채
- <항목>

## 마이그레이션 주의사항
- <항목>
```

## 제약
- 코드 수정 금지 (분석·문서화만)
- PII·비밀이 포함된 코드는 분석 결과에서 마스킹

## 이벤트
```yaml
event_type: aidd_interaction_event
prompt_template_id: PT-05-LEGACY-UNDERSTAND-v1
sdlc_stage: understand
```
