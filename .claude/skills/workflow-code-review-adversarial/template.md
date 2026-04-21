---
artifact_type: review-report
produced_by: workflow-code-review-adversarial
consumed_by: agent-dev, 사람 리뷰어
constraints:
  - AC 미충족은 반드시 Blocker로 분류
explicit_ambiguities: []
---

## 🤖 코드 리뷰 리포트 — PR #{pr_number}

### 🔴 필수 수정 (Blocker)
- [ ] {항목}

### 🟡 권장 수정
- [ ] {항목}

### 🔒 보안
- {항목 또는 "이슈 없음"}

### ✅ AC 충족 여부
- AC-1: ✅ / ❌
- AC-2: ✅ / ❌

### 🧪 테스트
- 커버리지: {N}%
- 누락 케이스: {항목}

---
*Blind Hunter → Edge Case Hunter → Acceptance Auditor 3단계 검토*
*최종 승인은 사람 리뷰어 필수 (HITL L2)*
