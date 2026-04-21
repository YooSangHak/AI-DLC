---
id: PT-01-IMPLEMENT-v1
purpose: Story AC 기반 코드 구현
subagent: agent-dev
model_hint: Sonnet 4.6 (Py/TS) / GPT-5 (Java)
inputs:
  - Story 파일 (doc/epic-story/stories/<ID>.md)
  - ADR (docs/adr/*.md)
  - 기존 src/ 유사 모듈
outputs:
  - src/<module>/<feature>.py 또는 .ts
  - tests/<module>/test_<feature>.py 또는 .test.ts
hitl_gate: L1
automation_tier: high
---

# PT-01 — Story AC 기반 코드 구현

## 목적
Story의 Acceptance Criteria를 기반으로 test-first 원칙에 따라 코드를 구현한다.

## 전제 조건
- Story 파일 존재 (`doc/epic-story/stories/<ID>.md`)
- 관련 ADR 존재 (`docs/adr/*.md`)
- CLAUDE.md Stack·Conventions 숙지

## 입력
```
Story ID: {story_id}
Story 파일: {story_path}
ADR 경로: {adr_path}
구현 대상 AC: {ac_ids}  # 예: AC-1, AC-2
```

## 작업 지시
1. CLAUDE.md의 Stack·Conventions·AI Usage Rules 5개를 먼저 읽는다
2. Story의 AC 목록을 확인하고 구현 범위를 파악한다
3. 관련 ADR을 읽고 설계 결정을 따른다
4. **Red**: AC 각 항목에 대응하는 실패하는 테스트를 먼저 작성한다
5. **Green**: 테스트를 통과하는 최소 구현을 작성한다
6. **Refactor**: 중복 제거·명명 개선·구조 정리
7. 300 LOC 초과 시 작업을 분할하고 재시도한다
8. Conventional Commits 형식으로 커밋한다
9. `aidd_interaction_event` 이벤트를 기록한다

## 출력 형식
```
src/<module>/<feature>.py         # 구현 코드
tests/<module>/test_<feature>.py  # 테스트 코드
```

커밋 메시지 형식:
```
feat(<module>): <기능 요약>

- AC-1: <설명>
- AC-2: <설명>
- Tests: N cases (<케이스 요약>)

Refs: {story_id}
```

## 제약
- **300 LOC 초과 diff 금지** — 초과 시 분할
- 단위 테스트 없이 PR 금지
- 비밀·PII 코드에 하드코딩 금지
- Spec·ADR 없는 기능 추가 금지

## 이벤트
```yaml
event_type: aidd_interaction_event
prompt_template_id: PT-01-IMPLEMENT-v1
sdlc_stage: implement
```
