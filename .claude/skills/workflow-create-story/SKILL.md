---
name: workflow-create-story
description: |
  Epic·Story 분해 워크플로. PRD·ADR 읽기 → Epic/Story 분해 → AC 작성 3단계.
  "/workflow-create-story", "Story 분해", "Epic 분해", "AC 작성" 요청 시 트리거.
allowed-tools: Read Write Edit Grep Glob
---

# 📋 workflow-create-story

## 역할
PRD·ADR을 기반으로 Epic을 Story로 분해하고 AC를 작성한다.

## Phase 0: 기존 자료 감사 (필수)
1. `docs/prd/<ticket>.md` (PRD) 존재 확인
2. `docs/adr/*.md` 존재 확인
3. `docs/stories/*.md` 기존 Story 존재 확인

## 단계 구성

| Step | 파일 | 담당 |
|---|---|---|
| 1 | `steps/step-01-read-prd-adr.md` | agent-pm |
| 2 | `steps/step-02-decompose.md` | agent-pm |
| 3 | `steps/step-03-write-ac.md` | agent-pm |

## Output
- `docs/stories/<ticket>-EPIC-<n>.md` (Epic 파일들)
- `docs/stories/<ticket>-S*.md` (Story 파일들)

## HITL
- L2: Story 분해 결과 사람 승인
