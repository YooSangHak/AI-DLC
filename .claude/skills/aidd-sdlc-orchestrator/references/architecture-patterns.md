# 6 아키텍처 패턴 참고 (Harness 차용)

> Orchestrator·Workflow 설계 시 참고하는 6가지 패턴.
> AIDD는 하이브리드 모드 (ADR-010).

## 1. 파이프라인 (Pipeline)
**언제**: 순차 의존 작업
**AIDD 적용**: SDLC 본류 (PRD → Architecture → Story → Dev → QA) ✅

```
입력 → 단계A → 단계B → 단계C → 출력
```

## 2. 팬아웃/팬인 (Fan-out/Fan-in)
**언제**: 병렬 독립 작업 후 결과 통합
**AIDD 적용**: 6월+ Forward Mode 자료 수집

```
입력 → [Agent A, Agent B, Agent C] → 통합 → 출력
```

## 3. 전문가 풀 (Expert Pool)
**언제**: 상황별 다른 전문가 선택
**AIDD 적용**: Agent 8종이 각 Workflow에 부분 참여 ✅

## 4. 생성-검증 (Generate-Validate)
**언제**: 생성 후 품질 검수
**AIDD 적용**: workflow-code-review-adversarial ✅

```
생성 (dev) → 검증 (reviewer·qa·security) → 수정 → 재검증
```

## 5. 감독자 (Supervisor)
**언제**: 중앙 Agent가 동적으로 분배
**AIDD 적용**: aidd-sdlc-orchestrator ✅

```
감독자(Orchestrator)
  ├── Agent A 할당
  ├── Agent B 할당
  └── 결과 수집·보고
```

## 6. 계층적 위임 (Hierarchical Delegation)
**언제**: 상위→하위 재귀 위임
**AIDD 적용**: 6월+ 복잡 프로젝트

## AIDD 하이브리드 모드 (ADR-010)

| 단계 | 패턴 | 이유 |
|---|---|---|
| SDLC 본류 | 파이프라인 + 감독자 | 순차 의존, 오케스트레이터 조율 |
| PR Review | 팬아웃/팬인 | 교차 검증 본질 |
| Design 교차검증 | 생성-검증 | Opus·GPT-5 상호 검증 |
