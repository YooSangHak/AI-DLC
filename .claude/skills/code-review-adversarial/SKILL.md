---
name: code-review-adversarial
description: |
  적대적 코드 리뷰 Skill. Blind Hunter → Edge Case Hunter → Acceptance Auditor 3단계.
  "/code-review-adversarial", "적대적 리뷰", "코드 품질 검토" 요청 시 트리거.
  workflow-code-review-adversarial 각 step에서 자동 로드.
  일반 리뷰보다 버그 발견율이 높음 — PR merge 전 반드시 실행 권장.
allowed-tools: Read Grep Glob
---

# 🎯 code-review-adversarial

## 목적
3단계 적대적 관점으로 코드를 검토하여 일반 리뷰가 놓치는 버그·경계 조건·AC 미충족을 발견한다.

## When to use
- PR merge 전 (workflow-code-review-adversarial에서 자동)
- 중요 로직 변경 시 수동 호출
- pre-handoff adversarial review (ADR-018) 시

## 3단계 프로세스

### Phase 1: Blind Hunter
`references/blind-hunter-guide.md` 로드
- Story·AC 정보 없이 diff만 보고 탐색
- 명백한 버그·오탈자·로직 오류
- AI Usage Rules 위반
- 300 LOC 초과

### Phase 2: Edge Case Hunter
`references/edge-case-patterns.md` 로드
- 경계값: 0·최댓값·off-by-one
- null·None·undefined·빈 컬렉션
- 타임아웃·네트워크 오류·동시성

### Phase 3: Acceptance Auditor
`references/acceptance-audit-checklist.md` 로드
- Story AC 각 항목 충족 여부 대조
- 테스트 커버리지 적절성
- 문서화 완성도

## References
- `references/blind-hunter-guide.md`
- `references/edge-case-patterns.md`
- `references/acceptance-audit-checklist.md`
