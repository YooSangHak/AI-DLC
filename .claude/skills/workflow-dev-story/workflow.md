# workflow-dev-story — 전체 흐름

## 목적
Story AC를 기반으로 test-first 원칙에 따라 구현·테스트·문서화를 수행하고 PR을 생성한다.

## 전제 조건
- [ ] Story 파일 존재 (`doc/epic-story/stories/<ID>.md`)
- [ ] ADR 존재 또는 설계 결정 명확 (`docs/adr/*.md`)
- [ ] CLAUDE.md Stack·Conventions 숙지

## 흐름

```
Phase 0 (감사)
  └── Step 1: 컨텍스트 로드 + 브랜치 생성
        └── Step 2: AC 기반 구현 (PT-01, test-first)
              └── Step 3: 테스트 보강 (PT-06)
                    └── Step 4: 문서화 (PT-07)
                          └── Step 5: Self-check (DoD 검증)
                                └── PR 생성 → aidd-review-orchestrator
```

## 단계별 설명

### Step 1: 컨텍스트 로드
- Story·ADR·CLAUDE.md 읽기
- 브랜치 생성 (`feature/<ticket>-<slug>`)
- AC 목록 확인 및 구현 범위 파악

### Step 2: 구현 (PT-01)
- Red → Green → Refactor (test-first)
- 300 LOC 초과 시 분할
- AC별 단위 테스트 포함

### Step 3: 테스트 보강 (PT-06)
- 경계값·null·오류 케이스 추가
- 테스트 커버리지 80% 이상 목표
- `pytest` 또는 `vitest` 전체 통과 확인

### Step 4: 문서화 (PT-07)
- 변경된 모듈·API 문서 업데이트
- CHANGELOG.md 업데이트

### Step 5: Self-check
- checklist.md DoD 전항목 확인
- AI Usage Rules 5개 위반 여부 재확인
- PR 생성

## 중단·재개
Phase 0 감사로 자동 감지. `_workspace/<run_id>/` 에 중간 산출물 보존.
