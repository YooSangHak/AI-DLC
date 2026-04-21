---
name: review-checklist
description: |
  AI 리뷰어 이중 검토 + 인간 승인 체크리스트. PR 리뷰 시 자동 참조.
  "/review-checklist", "리뷰 체크리스트", "PR 검토 기준" 요청 시 트리거.
  agent-reviewer가 PR 리뷰 시 자동 로드. aidd-review-orchestrator 팀 모드에서도 사용.
allowed-tools: Read
---

# ✅ review-checklist

## 목적
AI 리뷰어(이중)와 사람 리뷰어가 동일한 기준으로 PR을 검토하도록 체크리스트를 제공한다.

## When to use
- PR 리뷰 시 (agent-reviewer 자동 로드)
- aidd-review-orchestrator 팀 모드
- 사람 리뷰어 최종 승인 전

## Tier 1 — AI 자동 검토 (L1)

### 코드 품질
- [ ] 300 LOC 이내 (commit-guardrail)
- [ ] lint·타입 오류 없음 (convention-py 또는 convention-ts)
- [ ] 단위 테스트 존재 및 통과
- [ ] 커버리지 80% 이상

### 보안
- [ ] 비밀·PII 하드코딩 없음
- [ ] 신규 의존성 공급망 체크 완료
- [ ] OWASP 명백한 취약점 없음

### 스타일
- [ ] Conventional Commits 형식 (pr-hygiene)
- [ ] 브랜치명 표준 준수

## Tier 2 — 사람 리뷰 (L2)

### 기능
- [ ] Story AC 전 항목 충족
- [ ] 엣지 케이스 처리 적절
- [ ] 오류 처리 완전

### 설계
- [ ] ADR 결정 준수
- [ ] 기존 패턴과 일관성
- [ ] 불필요한 복잡성 없음

### 문서
- [ ] 변경된 API 문서 업데이트
- [ ] CHANGELOG.md 업데이트
- [ ] explicit_ambiguities 해소 완료 (ADR-016)

## Tier 3 — 고위험 변경 (L3, 2인+SRE)
- [ ] DB 마이그레이션·스키마 변경
- [ ] 인증·권한 로직 변경
- [ ] 프로덕션 배포 설정 변경
