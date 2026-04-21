# Conventional Commits 상세 가이드

## Type 선택 기준

| type | 사용 시점 | 예시 |
|---|---|---|
| `feat` | 새 기능 추가 | `feat(auth): add OAuth login` |
| `fix` | 버그 수정 | `fix(api): handle null user response` |
| `refactor` | 기능 변경 없는 코드 개선 | `refactor(db): extract query builder` |
| `test` | 테스트 추가·수정 | `test(auth): add edge case for expired token` |
| `docs` | 문서만 변경 | `docs(api): update endpoint description` |
| `chore` | 빌드·의존성·설정 | `chore(deps): bump pytest to 8.0` |
| `perf` | 성능 개선 | `perf(query): add index on user_id` |

## 좋은 예 vs 나쁜 예

```
# ✅ 좋음
feat(auth): add email verification on signup

- Sends verification email after registration
- Expires link after 24 hours

Refs: JIRA-123

# ❌ 나쁨
fix bug          # type 없음
feat: 기능추가     # scope 없음, 설명 불충분
Fixed the login  # 과거형, type 없음
```
