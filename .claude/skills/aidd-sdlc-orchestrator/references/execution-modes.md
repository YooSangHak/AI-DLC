# 실행 모드 (Quick / Standard / Full)

> ADR-011: 3가지 실행 모드로 사용자 진입 장벽 최소화.
> NFR-10: Quick 모드는 Standard 대비 ≤50% 시간 내 완료.

---

## 비교 요약

| 항목 | Quick | Standard | Full |
|---|---|---|---|
| **트리거** | `--quick` | (기본, 플래그 없음) | `--full` |
| **Phase 0 감사** | 생략 | 수행 (≤3초) | 수행 후 기존 자료 보관 |
| **사용자 승인** | L3만 강제 | 계획 승인 (L2) | 전체 재작성 승인 (L2) |
| **기존 자료** | 덮어쓸 수 있음 | 활용 (skip/재개) | `_workspace_<ts>/`로 보관 |
| **예상 시간** | ≤50% (NFR-10) | 100% (baseline) | 120%+ |
| **적합 상황** | 프로토타입, 익숙한 패턴 | 일반 Story 구현 | 요구사항 대폭 변경 |

---

## Standard (기본)

**트리거**: `/aidd-sdlc <입력>`

**실행 흐름**:
1. Phase 0 — 입력 모드 감지 (4종)
2. Phase 0 — 컨텍스트 감사 + 실행 계획 리포트
3. 사용자 승인 (HITL L2)
4. 필요한 단계만 선택 실행 (기존 자료 skip)
5. 각 Workflow 완료 후 HITL L2 확인
6. PR 생성 + 리뷰 요청

**Phase 선택 로직** (phase-selection-matrix.md 참조):
```
감사 결과에 따라 누락된 단계만 실행:
- REQ 없음   → workflow-create-prd 포함
- ADR 없음   → workflow-create-architecture 포함
- 구현 없음  → workflow-dev-story Step 1부터
- 구현 중단  → workflow-dev-story 중단 Step부터
- 테스트 없음 → workflow-dev-story Step 3 (test)부터
```

---

## Quick (`--quick`)

**트리거**: `/aidd-sdlc <입력> --quick`

**실행 흐름**:
1. Phase 0 — 입력 모드 감지만 수행 (Part A)
2. 감사 생략 → 기본값으로 전 단계 즉시 실행
3. 중간 확인 최소화 (L3 HITL만 강제 유지)
4. 자동 커밋·PR 생성

**기본값 설정**:
```
- 요구사항: 입력 텍스트 그대로 사용
- ADR: 최소 1개 (설계 결정 사항)
- 테스트: 단위 테스트 최소 3개
- 커버리지 목표: 80%
- PR 타이틀: Conventional Commits 자동 생성
```

**주의사항**:
- 기존 자료를 덮어쓸 수 있음
- 중요 작업에는 Standard 권장
- L3 HITL (DB 마이그레이션·인증 변경·배포)은 Quick 모드에서도 반드시 확인

---

## Full (`--full`)

**트리거**: `/aidd-sdlc <입력> --full`

**실행 흐름**:
1. Phase 0 — 입력 모드 감지 + 컨텍스트 감사
2. **기존 자료 보관** (HITL L2 확인 후):
   ```bash
   TIMESTAMP=$(date +%Y%m%d_%H%M%S)
   mv _workspace/ "_workspace_${TIMESTAMP}/"
   mv docs/requirements/<ID>.md "docs/requirements/<ID>.${TIMESTAMP}.bak"
   # 관련 ADR·Spec도 동일 처리
   ```
3. `_workspace/` 새로 생성
4. Phase 1부터 전체 재실행 (Standard 흐름과 동일)

**AC-5 구현**:
```bash
# Full 모드 진입 시 기존 _workspace/ 타임스탬프 보관
if [ -d "_workspace" ]; then
  TS=$(date +%Y%m%d_%H%M%S)
  mv "_workspace" "_workspace_${TS}"
  echo "기존 자료 보관: _workspace_${TS}/"
fi
mkdir -p _workspace
```

**주의사항**:
- 되돌리기 어려움 (보관 디렉토리에서 수동 복구 가능)
- 실행 전 반드시 HITL L2 승인 필수
- 보관 디렉토리는 30일 후 자동 삭제 권장 (cost-monitor cron 연계)
