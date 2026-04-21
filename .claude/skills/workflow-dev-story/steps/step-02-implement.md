# Step 2: AC 기반 구현

## 목적
`.claude/prompts/PT-01-IMPLEMENT-v1.md`를 로드하여 test-first로 코드를 구현한다.

## 작업
1. `.claude/prompts/PT-01-IMPLEMENT-v1.md`를 로드하라
2. PT-01의 지시에 따라 다음 순서로 구현한다:
   - **Red**: AC 각 항목에 대응하는 실패하는 테스트 작성
   - **Green**: 테스트를 통과하는 최소 구현
   - **Refactor**: 중복 제거·명명 개선
3. 300 LOC 초과 시 작업을 분할하고 단계적으로 커밋한다
4. 각 커밋은 Conventional Commits 형식을 따른다

## 출력
```
src/<module>/<feature>.py
tests/<module>/test_<feature>.py
```

## 완료 조건
- [ ] 모든 단위 테스트 통과 (`pytest` 또는 `vitest`)
- [ ] 300 LOC 이내
- [ ] Conventional Commits 커밋 완료

## 다음 단계
step-03-test.md로 진행
