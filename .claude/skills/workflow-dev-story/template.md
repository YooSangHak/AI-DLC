---
artifact_type: pr-description
produced_by: workflow-dev-story/step-05-self-check
consumed_by: agent-reviewer, agent-qa, aidd-review-orchestrator
constraints:
  - AC 충족 여부 명시 필수
  - 테스트 결과 포함 필수
explicit_ambiguities: []
---

# PR: {제목}

## 개요
<!-- 변경 사항 한 문단 요약 -->

## 관련 티켓
Refs: {ticket_id}

## AC 충족 여부
- AC-1: ✅ / ❌ — {설명}
- AC-2: ✅ / ❌ — {설명}

## 변경 파일
```
src/<module>/<feature>.py    # 구현
tests/<module>/test_*.py     # 테스트
docs/...                     # 문서 (해당 시)
```

## 테스트 결과
```
pytest: N passed, 0 failed
coverage: N%
```

## 체크리스트
- [ ] 300 LOC 이내
- [ ] 단위 테스트 통과
- [ ] 문서 업데이트
- [ ] AI Usage Rules 위반 없음
