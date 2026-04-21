# Step 2: 설계 결정 (ADR 작성)

## 목적
`.claude/prompts/PT-11-DESIGN-v1.md`를 로드하여 ADR을 작성한다.

## 작업
1. `.claude/prompts/PT-11-DESIGN-v1.md`를 로드하라
2. PT-11의 지시에 따라:
   - 각 설계 결정에 대해 3가지 대안 검토
   - 트레이드오프 분석
   - 최선 대안 선택 및 근거 명시
3. `docs/adr/<nnn>-<title>.md`에 저장한다
4. 불명확한 부분은 `explicit_ambiguities`에 기록하고 HITL L2로 승격한다

## 완료 조건
- [ ] ADR 작성 완료
- [ ] explicit_ambiguities 처리 완료
- [ ] 사람 승인 완료 (HITL L2)

## 다음 단계
step-03-pattern.md로 진행
