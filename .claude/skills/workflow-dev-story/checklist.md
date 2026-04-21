# workflow-dev-story — DoD 체크리스트

## 산출물 존재
- [ ] `src/<module>/<feature>.py` 또는 `.ts` 존재
- [ ] `tests/<module>/test_<feature>.py` 또는 `.test.ts` 존재
- [ ] PR 생성 완료

## 품질
- [ ] 모든 단위 테스트 통과
- [ ] 테스트 커버리지 80% 이상
- [ ] 300 LOC 이내 diff
- [ ] Conventional Commits 형식

## AI Usage Rules
- [ ] 300 LOC 초과 diff 없음
- [ ] 신규 의존성 공급망 체크 완료
- [ ] 비밀·PII 커밋 없음
- [ ] Spec·ADR 기반 구현 (추측 없음)

## AC 충족 (ADR-017 핸드오프 체크)
- [ ] Story AC 전 항목 대조 완료
- [ ] explicit_ambiguities 항목 HITL L2 처리 완료
- [ ] AI Consumer Metadata (ADR-016) PR description 포함

## HITL
- [ ] L2 사람 리뷰어 승인 대기 중
