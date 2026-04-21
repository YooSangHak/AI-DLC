# Step 4: 문서화

## 목적
`.claude/prompts/PT-07-DOCS-v1.md`를 로드하여 변경된 모듈·API를 문서화한다.

## 작업
1. `.claude/prompts/PT-07-DOCS-v1.md`를 로드하라
2. PT-07의 지시에 따라 문서를 작성한다:
   - 변경된 모듈 README 또는 docstring 업데이트
   - API 변경 시 `docs/design/<feature>.md` 업데이트
3. CHANGELOG.md에 변경 사항을 기록한다:
   ```markdown
   ## [Unreleased]
   ### Added
   - <기능 설명> (Refs: <ticket>)
   ```

## 완료 조건
- [ ] 변경된 모듈 문서 업데이트
- [ ] CHANGELOG.md 업데이트

## 다음 단계
step-05-self-check.md로 진행
