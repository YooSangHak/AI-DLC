# Step 3: QA 2차 방어선

## 목적
agent-dev의 TDD(Red→Green→Refactor) 이후, **파괴자 시각**으로 dev가 놓친 취약점을 찾는다.
dev는 "기능이 동작한다"를 증명했고, qa는 "기능이 망가지지 않는다"를 검증한다.

## 담당
`agent-qa` — `.claude/prompts/PT-06-TEST-ADD-v1.md` 로드

## 작업
1. `.claude/prompts/PT-06-TEST-ADD-v1.md`를 로드하라
2. Step 2 산출물(`src/`, `tests/`)을 읽고 **dev TDD가 커버하지 못한 영역**을 식별한다
3. 다음 6축 기준으로 추가 테스트를 작성한다:
   - **Property-based**: `hypothesis`(Py) / `fast-check`(TS) — 생성 기반 임의 입력
   - **Mutation**: `mutmut`(Py) / `stryker`(TS) — 테스트 자체의 품질 검증
   - **경계면 교차**: API 응답 shape ↔ 클라이언트 기대 shape 일치 확인 (해당 시)
   - **동시성**: race condition·타임아웃 (해당 시)
4. 전체 테스트 스위트를 실행하여 통과를 확인한다
5. 커버리지 80% 미달 시 갭 시나리오를 추가한다

## 완료 조건
- [ ] dev TDD 커버리지 갭 식별 및 추가 테스트 작성
- [ ] 전체 테스트 통과
- [ ] 커버리지 80% 이상

## 다음 단계
step-04-docs.md로 진행
