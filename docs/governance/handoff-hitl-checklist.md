---
artifact_type: governance-policy
story: AIDD-S042
produced_by: agent-architect
consumed_by: [all-agents, all-developers]
version: 1.0
date: 2026-04-21
---

# 핸드오프별 HITL L2 체크리스트 (ADR-017)

> 재귀 품질 방어 2/3 — 각 핸드오프에서 "하류 AI가 추측으로 채울 만한 지점"을 사전 차단.
> 상위 정책: docs/governance/hitl-matrix.md

---

## 체크리스트 공통 구조

모든 핸드오프 체크리스트는 3개 섹션:
1. **메타 필드 검증** (ADR-016 준수)
2. **구조적 검증** (산출물 완전성)
3. **하류 AI 추측 차단** (explicit_ambiguities 해소)

---

## H1: analyst → pm (요구사항 → Spec)

```markdown
### 메타 필드
- [ ] `artifact_type: requirements` 존재
- [ ] `consumed_by: [agent-pm]` 명시
- [ ] `explicit_ambiguities` 목록 확인 — 미해소 항목 0건

### 구조적 검증
- [ ] 이해관계자 목록 완전
- [ ] 기능적/비기능적 요구사항 분리됨
- [ ] 제약사항(성능·보안·규정) 명시됨

### 하류 AI 추측 차단
- [ ] 우선순위 기준 명시 (MoSCoW 또는 점수)
- [ ] 외부 시스템 연동 방식 명시
- [ ] 용어집(도메인 용어) 포함 또는 참조 링크
```

---

## H2: pm → architect (Spec → ADR)

```markdown
### 메타 필드
- [ ] `artifact_type: spec` 존재
- [ ] `consumed_by: [agent-architect]` 명시
- [ ] `constraints.stack` 기술 스택 명시
- [ ] `explicit_ambiguities` 미해소 항목 0건

### 구조적 검증
- [ ] FR 번호별 AC 완전 (FR-N.M 형식)
- [ ] NFR(성능·보안·가용성) 수치 명시
- [ ] 다이어그램 또는 흐름도 포함

### 하류 AI 추측 차단 ⭐
- [ ] 기술 스택 선택지가 명시되거나 아키텍트에게 위임 명시
- [ ] DB 스키마 요구사항(RDBMS vs NoSQL) 방향 명시
- [ ] 인증 방식(JWT·세션·OAuth) 요구사항 명시
- [ ] 성능 예산(`constraints.performance_budget_ms`) 존재
```

---

## H3: architect → dev (ADR → 구현)

```markdown
### 메타 필드
- [ ] `artifact_type: adr` 존재
- [ ] `consumed_by: [agent-dev, agent-qa]` 명시
- [ ] `constraints.forbidden_patterns` 명시
- [ ] `explicit_ambiguities` 미해소 항목 0건

### 구조적 검증
- [ ] Status: Accepted (Proposed 상태로 구현 금지)
- [ ] Alternatives 3개 이상 + 거부 이유
- [ ] 컴포넌트 책임 경계 명확
- [ ] API 인터페이스 또는 데이터 모델 포함

### 하류 AI 추측 차단 ⭐
- [ ] 파일·함수 명명 규칙 명시 (또는 CLAUDE.md 참조)
- [ ] 에러 처리 전략 명시 (exception 유형별)
- [ ] 트랜잭션 경계 명시 (해당 시)
- [ ] 비동기 처리 방식 명시 (async/sync 결정)
```

---

## H4: dev → qa (구현 → 테스트)

```markdown
### 메타 필드
- [ ] `_workspace/<run_id>/03_code_diff.md` 존재
- [ ] `consumed_by: [agent-qa]` 명시
- [ ] diff 크기 ≤300 LOC 확인

### 구조적 검증
- [ ] 커밋 메시지 Conventional Commits 형식
- [ ] 모든 AC에 대응하는 구현 확인 (AC 번호 주석)
- [ ] 린트·타입 오류 0건 (CI 통과)

### 하류 AI 추측 차단
- [ ] 테스트하기 어려운 의존성 목(mock) 전략 명시
- [ ] 통합 테스트 필요 외부 서비스 명시
- [ ] 경계 조건(max/min 값) 문서화
```

---

## H5: qa → reviewer (테스트 → 리뷰)

```markdown
### 메타 필드
- [ ] `_workspace/<run_id>/04_test_report.md` 존재
- [ ] 커버리지 ≥80% 확인

### 구조적 검증
- [ ] 테스트 케이스 AC별 매핑 완전
- [ ] 경계 조건 6축(0/max/null/empty/concurrent/failure) 각 1건+
- [ ] Mutation 점수 기록 (해당 시)

### 하류 AI 추측 차단
- [ ] flaky 테스트 목록 명시 (있으면)
- [ ] 미테스트 AC 명시 + 이유
```

---

## H6: reviewer → deployer (리뷰 → 배포)

```markdown
### 메타 필드
- [ ] PR comment에 agent-reviewer 결과 존재
- [ ] Blocker 0건 확인

### 구조적 검증
- [ ] 모든 AC ✅ 확인
- [ ] 보안 이슈 없음 (또는 L3 승인 완료)
- [ ] 사람 리뷰어 Approve 완료 (HITL L2)

### 배포 사전 확인 (HITL L2 → L3 진입)
- [ ] 릴리즈 노트 초안 검토
- [ ] canary 대상 환경 확인
- [ ] 롤백 계획 존재
```

---

## H7: deployer → (완료)

```markdown
### 배포 후 검증 (HITL L2 최종)
- [ ] 헬스체크 200 OK
- [ ] 핵심 메트릭 정상 범위 (레이턴시·에러율)
- [ ] CHANGELOG.md 업데이트 커밋
- [ ] GitHub Release 생성
- [ ] HITL L3 승인자에게 완료 통보
```
