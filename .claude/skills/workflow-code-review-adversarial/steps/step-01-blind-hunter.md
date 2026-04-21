# Step 1: Phase 0 감사 + Blind Hunter

<!-- Phase 0 공통: _shared/phase0-common.md 참조 — 먼저 수행 -->
> **[Phase 0]** `_shared/phase0-common.md` 의 A·B·C 절차를 먼저 수행한다.
> (리뷰 Workflow는 PR diff를 입력으로 사용 — 파일 모드 또는 자유 입력 모드로 감지)
> Quick 모드: A만 수행 후 즉시 Blind Hunter로 진입.

---

## 목적
AC·Story 정보 없이 diff만 보고 명백한 버그·위반·보안 이슈를 찾는다.

## 작업 (힌트 없이 수행)
1. diff를 처음부터 읽으며 다음을 탐색한다:
   - 명백한 버그 (null 참조, 오탈자, 로직 오류)
   - AI Usage Rules 5개 위반 여부
   - 300 LOC 초과 여부
   - 비밀·PII 하드코딩
   - 보안 취약점 (SQL injection, XSS 등)
2. 발견 사항을 `template.md` 🔴 Blocker 섹션에 기록한다

## 완료 조건
- [ ] diff 전체 검토 완료
- [ ] 발견 사항 기록

## 다음 단계
step-02-edge-case-hunter.md로 진행
