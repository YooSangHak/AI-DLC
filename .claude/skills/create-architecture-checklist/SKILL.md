---
name: create-architecture-checklist
description: |
  ADR·아키텍처 설계 완성도 점검 체크리스트.
  "/create-architecture-checklist", "ADR 검토", "아키텍처 완성도 점검" 요청 시 트리거.
  workflow-create-architecture step-05-validation에서 자동 로드.
allowed-tools: Read Grep Glob
---

# 📐 create-architecture-checklist

## 목적
ADR과 설계 상세 문서가 완성도 기준을 충족하는지 점검한다.

## When to use
- ADR 작성 완료 후 HITL L2 승인 전
- `workflow-create-architecture` step-05에서 자동 실행

## Steps
1. `references/adr-completeness.md`를 로드한다
2. ADR 파일(`docs/adr/*.md`)을 읽는다
3. 체크리스트 각 항목을 점검한다
4. 미충족 항목을 보고하고 보완을 요청한다

## Checklist

### ADR 필수 섹션
- [ ] 상태 (Proposed·Accepted·Deprecated)
- [ ] 컨텍스트 — 왜 결정이 필요한가
- [ ] 결정 — 무엇을 선택했는가
- [ ] 대안 검토 — 최소 3가지
- [ ] 근거 — 왜 이 대안인가
- [ ] 결과 — 영향 범위

### 시각화
- [ ] Mermaid 다이어그램 포함
- [ ] 컴포넌트 간 관계 명확

### 하류 Agent 연계 (ADR-016)
- [ ] AI Consumer Metadata frontmatter 포함
- [ ] `consumed_by` 명시
- [ ] `constraints` 하류 Agent가 따를 제약 기술
- [ ] `explicit_ambiguities` 불명확 사항 기록

## References
- `references/adr-completeness.md`
