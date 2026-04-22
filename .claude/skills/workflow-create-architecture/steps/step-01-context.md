# Step 1: Phase 0 감사 + 컨텍스트 수집

<!-- Phase 0 공통: _shared/phase0-common.md 참조 — 먼저 수행 -->
> **[Phase 0]** `_shared/phase0-common.md` 의 A·B·C 절차를 먼저 수행한다.
> Quick 모드: A만 수행 후 즉시 아래 작업으로 진입.

---

## 목적
설계에 필요한 모든 컨텍스트(PRD·기존 ADR·기술 스택)를 수집한다.

## 작업
1. PRD(`docs/prd/<ticket>.md`)를 읽고 요구사항을 파악한다
2. 기존 ADR(`docs/adr/*.md`)을 검토하여 기존 결정과 일관성을 확인한다
3. CLAUDE.md의 Stack·Conventions를 숙지한다
4. 설계 결정이 필요한 항목 목록을 작성한다

## 완료 조건
- [ ] 요구사항 파악 완료
- [ ] 기존 ADR 검토 완료
- [ ] 설계 결정 필요 항목 목록 작성

## 다음 단계
step-02-decisions.md로 진행
