# 비밀·PII 탐지 패턴

## 비밀 패턴 (Grep 정규식)

```bash
# API 키·토큰
grep -rE "(api[_-]?key|api[_-]?token|access[_-]?token|secret[_-]?key)\s*=\s*['\"][^'\"]{8,}" src/

# AWS
grep -rE "AKIA[0-9A-Z]{16}" src/

# 비밀번호 하드코딩
grep -rE "(password|passwd|pwd)\s*=\s*['\"][^'\"]{4,}" src/

# JWT
grep -rE "eyJ[A-Za-z0-9+/]{20,}" src/

# Private Key
grep -rE "-----BEGIN (RSA |EC )?PRIVATE KEY-----" src/
```

## PII 패턴

```bash
# 이메일
grep -rE "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" src/

# 한국 전화번호
grep -rE "0[0-9]{1,2}-[0-9]{3,4}-[0-9]{4}" src/

# 주민등록번호 패턴
grep -rE "[0-9]{6}-[1-4][0-9]{6}" src/
```

## 안전한 패턴 (False Positive 제외)
- 환경변수 참조: `os.environ.get("API_KEY")` — 안전
- 플레이스홀더: `"your-api-key-here"` — 안전
- 테스트 픽스처: `tests/fixtures/` 하위 — 별도 검토
