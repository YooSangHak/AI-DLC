# Step 1: Phase 0 감사 + PRD·ADR 읽기

<!-- Phase 0 공통: _shared/phase0-common.md 참조 — 먼저 수행 -->
> **[Phase 0]** `_shared/phase0-common.md` 의 A·B·C 절차를 먼저 수행한다.
> Quick 모드: A만 수행 후 즉시 아래 작업으로 진입.

---

## 목적
PRD와 ADR을 읽고 Story 분해 기준을 파악한다.

## 작업
1. `docs/prd/<ticket>.md` PRD를 읽고 FR 목록을 파악한다
2. `docs/adr/*.md` ADR을 읽고 기술 제약을 파악한다
3. 기존 Story가 있으면 중복 여부를 확인한다
4. 분해 기준(INVEST 원칙)을 정의한다

## 완료 조건
- [ ] FR 목록 파악 완료
- [ ] 기술 제약 파악 완료

## 다음 단계
step-02-decompose.md로 진행
