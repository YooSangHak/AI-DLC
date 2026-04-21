# Step 1: Phase 0 감사 + 컨텍스트 로드 + 브랜치 생성

<!-- Phase 0 공통: _shared/phase0-common.md 참조 — 먼저 수행 -->
> **[Phase 0]** `_shared/phase0-common.md` 의 A·B·C 절차를 먼저 수행한다.
> Quick 모드: A만 수행 후 즉시 아래 작업으로 진입.

---

## 목적
구현에 필요한 모든 컨텍스트를 수집하고 작업 브랜치를 생성한다.

## 작업
1. CLAUDE.md를 읽어 Stack·Conventions·AI Usage Rules를 숙지한다
2. Story 파일을 읽어 AC 목록과 Implementation Steps를 파악한다
3. 관련 ADR을 읽어 설계 결정을 따른다
4. 기존 `src/` 유사 모듈을 확인하여 패턴 일관성을 파악한다
5. 작업 브랜치를 생성한다:
   ```bash
   git checkout -b feature/{ticket}-{slug}
   ```
6. `_workspace/<workflow_run_id>/00_input/` 에 입력 요약을 저장한다

## 완료 조건
- [ ] AC 목록 파악 완료
- [ ] 브랜치 생성 완료
- [ ] 불명확한 AC는 사용자에게 확인 (HITL L2)

## 다음 단계
step-02-implement.md로 진행
