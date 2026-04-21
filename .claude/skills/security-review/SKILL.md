---
name: security-review
description: |
  보안 취약점 스캔. OWASP LLM Top 10 (2025) + 비밀·PII 패턴 탐지.
  "/security-review", "보안 검토", "취약점 스캔", "보안 리뷰" 요청 시 트리거.
  PR 생성 시 aidd-review-orchestrator의 security Agent가 자동 로드.
  코드 변경 시 항상 실행 권장 — 보안 이슈는 발견 시점이 늦을수록 비용이 급증.
allowed-tools: Read Grep Glob
---

# 🔒 security-review

## 목적
코드·PR diff에서 보안 취약점·비밀 노출·PII 처리 오류를 탐지한다.

## When to use
- PR 생성 전 자체 점검
- `aidd-review-orchestrator` security Agent 자동 호출 시
- 신규 의존성 추가 시
- 인증·권한·암호화 관련 코드 변경 시

## Steps

### 1. 비밀·PII 스캔
`references/secret-patterns.md`의 패턴으로 다음을 탐지:
- API 키·토큰·비밀번호 하드코딩
- PII (이메일·전화·주민번호) 코드 노출
- `.env` 파일 커밋 여부

### 2. OWASP LLM Top 10 점검
`references/owasp-llm-top10.md` 로드하여 해당 항목 점검:
- LLM01: Prompt Injection
- LLM02: Insecure Output Handling
- LLM06: Sensitive Information Disclosure
- LLM08: Excessive Agency (과도한 권한)

### 3. 일반 보안 점검
- SQL Injection / XSS / CSRF
- 인증·권한 우회 가능성
- 안전하지 않은 역직렬화
- 의존성 알려진 취약점 (CVE)

## 판정 기준
| 등급 | 조건 | 조치 |
|---|---|---|
| Critical | 비밀 노출·인증 우회 | 즉시 커밋 차단, HITL L3 |
| High | OWASP Top 10 해당 | Blocker, HITL L2 |
| Medium | 잠재적 취약점 | 권장 수정 |
| Low | 개선 사항 | 참고 |

## 출력 형식
```markdown
## 보안 리뷰 결과

### 🔴 Critical
- [ ] {항목}

### 🟠 High
- [ ] {항목}

### 🟡 Medium
- [ ] {항목}

### ✅ 이상 없음
- {항목}
```

## References
- `references/owasp-llm-top10.md`
- `references/secret-patterns.md`
- `references/checklist.md`
