---
name: <skill-name>
# 예: commit-guardrail, convention-py, security-review
description: |
  <!-- 언제 이 Skill이 사용되는지 구체적으로 기술 -->
  <!-- Reference 타입: "항상 자동 로드" / Task 타입: "명시적 /skill-name 호출 시" -->
  <!-- 예: 커밋 전 300 LOC·비밀·PII 위반 검사. 모든 코드 작업에 자동 적용 -->
allowed-tools: Read Grep Bash
# Task 타입이면 Write·Edit 추가 가능
---

# <Skill 이름>

## 목적
<!-- 이 Skill이 해결하는 문제를 한 문장으로 -->

## When to use
<!-- 어떤 상황에서 이 Skill을 적용하는가 -->
- <!-- 예: 모든 git commit 전 -->
- <!-- 예: PR 생성 전 -->

## Steps
1. <!-- 구체적인 절차 (동사 시작) -->
2.
3.

## Checklist
- [ ] <!-- 검증 항목 -->
- [ ] <!-- 검증 항목 -->

## 판정 기준
| 항목 | 통과 | 실패 |
|---|---|---|
| <!-- 예: diff 크기 --> | <!-- ≤300 LOC --> | <!-- >300 LOC → 분할 요청 --> |

## 실패 시 대응
<!-- 실패 발견 시 Agent가 취해야 할 행동 -->
- <!-- 예: 커밋 중단 → 분할 방법 제안 -->

## References
- <!-- 관련 ADR, 문서 링크 -->
