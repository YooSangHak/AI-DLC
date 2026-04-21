---
name: pre-handoff-adversarial
description: |
  핸드오프 전 Adversarial 시뮬레이션 (재귀 품질 방어 3/3, ADR-018).
  H2(pm→architect)·H3(architect→dev)·H5(dev→qa) 3개 중요 핸드오프에 적용.
  "/pre-handoff-adversarial", "핸드오프 전 검증", "adversarial 리뷰" 요청 시 트리거.
  agent-reviewer·aidd-sdlc-orchestrator가 핸드오프 직전 자동 호출.
allowed-tools: Read Grep
---

# 🎯 Pre-handoff Adversarial Review (ADR-018)

## 목적
중요 핸드오프 전 상류 산출물의 모호함을 adversarial 시뮬레이션으로 사전 발견.
하류 AI가 추측으로 채울 만한 지점을 차단한다.

## When to use
- H2: pm → architect 핸드오프 직전
- H3: architect → dev 핸드오프 직전
- H5: dev → qa 핸드오프 직전

## 3단 Adversarial 절차

### Phase 1: Blind Hunter
상류 산출물을 처음 받은 AI처럼 읽는다 (컨텍스트 없이):
- "이 문서만으로 다음 단계를 진행할 수 있는가?"
- 누락된 정보 목록화
- 모호한 표현 식별 ("적절히", "빠르게", "일반적으로" 등)

### Phase 2: Edge Case Hunter
하류 AI가 처리하기 어려운 엣지 케이스 시뮬레이션:
- 입력이 null/empty일 때 어떻게 처리하는가?
- 최대값 처리 전략이 명시되어 있는가?
- 동시성 이슈가 발생하는 지점이 있는가?
- 에러 발생 시 복구 전략이 있는가?

### Phase 3: Assumption Hunter (핸드오프 특화)
"하류 AI가 추측으로 채울 가능성이 높은 항목":
```
H2 (Spec → ADR):
  - 기술 스택 선택지가 열려있는가?
  - DB 타입 결정이 명시되지 않았는가?
  - 인증 방식이 모호한가?

H3 (ADR → 구현):
  - 명명 규칙이 명시되지 않았는가?
  - 에러 코드 정의가 없는가?
  - 의존성 주입 방식이 불명확한가?

H5 (구현 → QA):
  - mock 전략이 명시되지 않았는가?
  - 외부 서비스 연동 테스트 방법 불명확한가?
  - 성능 테스트 기준값이 없는가?
```

## Output Format

```markdown
## Pre-handoff Adversarial Report — {handoff_type}

**산출물**: {path}
**핸드오프**: {upstream_agent} → {downstream_agent}

### 🔴 차단 필요 (Blocker)
- [ASSUMPTION] `{필드/섹션}`: "{모호한 내용}" — 하류 AI가 추측할 가능성 높음
  → 권고: {구체적 수정 방법}

### 🟡 주의 (Warning)
- [AMBIGUITY] `{필드/섹션}`: 여러 해석 가능
  → 권고: explicit_ambiguities에 기록 후 진행

### ✅ 통과
- {통과 항목 수}개 항목 문제 없음

### 결론
{통과|수정 필요} — {한 줄 요약}
```

## 연계
- 발견 사항 → `explicit_ambiguities`에 추가
- Blocker 존재 시 HITL L2 승인 전 상류 산출물 수정
- 상세 체크리스트: `docs/governance/handoff-hitl-checklist.md`

## References
- ADR-017: handoff-hitl-checklist.md
- ADR-018: 본 Skill
- code-review-adversarial Skill (기존 리뷰용)
