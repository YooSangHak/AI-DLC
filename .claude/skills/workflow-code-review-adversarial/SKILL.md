---
name: workflow-code-review-adversarial
description: |
  적대적 코드 리뷰 워크플로. Blind Hunter → Edge Case Hunter → Acceptance Auditor 3단계.
  "/workflow-code-review-adversarial", "코드 리뷰", "적대적 리뷰", "PR 리뷰" 요청 시 트리거.
  aidd-review-orchestrator의 reviewer-deep이 자동 호출하거나 수동 호출 가능.
allowed-tools: Read Grep Glob Bash(git *)
---

# 🔎 workflow-code-review-adversarial

## 역할
PR diff를 3단계 적대적 관점에서 검토하여 버그·보안·AC 미충족을 발견한다. (BMAD 차용)

## Phase 0: 기존 자료 감사 (필수)
1. PR diff 접근 확인
2. Story AC 목록 확인

## 단계 구성

| Step | 파일 | 관점 | 모델 |
|---|---|---|---|
| 1 | `steps/step-01-blind-hunter.md` | 힌트 없이 버그 탐색 | Haiku 4.5 |
| 2 | `steps/step-02-edge-case-hunter.md` | 경계 조건 탐지 | Sonnet 4.6 |
| 3 | `steps/step-03-acceptance-auditor.md` | AC 충족 검증 | Sonnet 4.6 |

## Input
- PR diff
- Story AC 목록

## Output
- PR 리뷰 comment (`template.md` 형식)

## HITL
- L2: 사람 최종 승인 (Merge 전 필수)
