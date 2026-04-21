# Step 5: Self-check + PR 생성

## 목적
checklist.md의 DoD를 전부 확인하고 PR을 생성한다.

## 작업
1. `checklist.md`를 로드하여 전 항목을 확인한다
2. AI Usage Rules 5개 위반 여부를 재확인한다
3. `commit-guardrail` Skill을 참조하여 최종 diff를 검토한다
4. PR을 생성한다:
   ```bash
   gh pr create --title "feat(<module>): <기능 요약>" \
     --body "Refs: <ticket>\n\n## AC 충족\n- AC-1: ✅\n- AC-2: ✅"
   ```
5. `aidd-review-orchestrator`가 자동 트리거됨을 확인한다

## 완료 조건
- [ ] checklist.md 전 항목 통과
- [ ] PR 생성 완료
- [ ] aidd-review-orchestrator 트리거 확인

## HITL L2
PR 생성 후 사람 리뷰어 최종 승인 대기.
