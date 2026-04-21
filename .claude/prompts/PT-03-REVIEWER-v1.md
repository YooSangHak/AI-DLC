---
id: PT-03-REVIEWER-v1
purpose: PR diff 코드 리뷰 (Blind Hunter → Edge Case → Acceptance)
subagent: agent-reviewer
model_hint: Haiku 4.5 (diff 수준) + Sonnet 4.6 (심화)
inputs:
  - PR diff
  - Story AC 목록
  - CLAUDE.md AI Usage Rules
outputs:
  - PR comment (리뷰 결과)
hitl_gate: L2
automation_tier: medium
---

# PT-03 — PR diff 코드 리뷰

## 목적
PR diff를 3단계(Blind Hunter → Edge Case Hunter → Acceptance Auditor)로 검토하여
버그·보안 취약점·AC 미충족을 발견한다.

## 전제 조건
- PR diff 접근 가능
- 대응 Story AC 목록 확인

## 입력
```
PR 번호: {pr_number}
PR diff: {pr_diff}
Story AC: {ac_list}
```

## 작업 지시

### Phase 1: Blind Hunter (Haiku 4.5)
1. diff만 보고 버그·오탈자·명백한 오류 탐색
2. AI Usage Rules 5개 위반 여부 확인
3. 300 LOC 초과 여부 확인
4. 비밀·PII 노출 여부 확인

### Phase 2: Edge Case Hunter (Sonnet 4.6)
1. 경계값·null·빈 컬렉션·타임아웃 처리 확인
2. 동시성 이슈 탐색
3. 오류 처리 누락 확인
4. 보안 취약점 (OWASP Top 10) 스캔

### Phase 3: Acceptance Auditor
1. Story AC 각 항목 충족 여부 대조
2. 테스트 커버리지 적절성 확인
3. 문서화 완성도 확인

## 출력 형식
```markdown
## 코드 리뷰 결과 — PR #{pr_number}

### 🔴 필수 수정 (Blocker)
- [ ] <항목>

### 🟡 권장 수정
- [ ] <항목>

### ✅ AC 충족 여부
- AC-1: ✅ / ❌
- AC-2: ✅ / ❌

### 💡 개선 제안
- <항목>
```

## 제약
- 주관적 스타일 지적 금지 (린트가 처리)
- AC 미충족은 반드시 Blocker로 분류
- HITL L2: 사람 최종 승인 필수

## 이벤트
```yaml
event_type: aidd_review_event
prompt_template_id: PT-03-REVIEWER-v1
sdlc_stage: review
```
