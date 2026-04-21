---
name: aidd-review-orchestrator
description: |
  PR 이중 리뷰 팀 모드 오케스트레이터. PR open·synchronize 시 GitHub Actions가 자동 트리거.
  reviewer-diff·reviewer-deep·qa·security 4명 병렬 실행 후 통합 리포트를 PR comment로 게시.
  "PR 리뷰 시작", "코드 리뷰 요청", "/aidd-review" 요청 시 수동 트리거도 가능.
allowed-tools: Read Glob Bash(git *) Bash(gh *)
---

# 🔍 AIDD Review Orchestrator

## 역할
PR 생성·업데이트 시 4명의 리뷰어 팀을 병렬로 구성하여 이중 검증을 수행하고
통합 리뷰 리포트를 PR comment로 게시한다.

## 진입 트리거
- **자동**: GitHub Actions `pr-review.yml` — PR open·synchronize 이벤트
- **수동**: `/aidd-review` 또는 "PR 리뷰 시작" 요청

## 팀 구성 (TeamCreate, 병렬 실행)

```yaml
TeamCreate:
  team_name: pr-review-team
  members:
    - name: reviewer-diff
      agent_type: general-purpose
      model: claude-haiku-4-5
      prompt: |
        PR diff 수준 빠른 리뷰. 3분 이내 완료.
        PT-03-REVIEWER-v1 Phase 1(Blind Hunter) 수행.
        AI Usage Rules 5개 위반, 300 LOC 초과, 비밀·PII 노출 확인.

    - name: reviewer-deep
      agent_type: general-purpose
      model: claude-sonnet-4-6
      prompt: |
        심화 리뷰. code-review-adversarial Skill 로드.
        PT-03-REVIEWER-v1 Phase 2(Edge Case Hunter) + Phase 3(Acceptance Auditor) 수행.
        Story AC 충족 여부 대조. OWASP Top 10 간이 스캔.

    - name: qa-boundary
      agent_type: general-purpose
      model: claude-sonnet-4-6
      prompt: |
        경계면 교차 테스트 검증 (Harness QA 가이드).
        테스트 커버리지 적절성, 누락된 경계값 케이스 확인.
        SendMessage로 reviewer-deep에게 발견 공유.

    - name: security
      agent_type: general-purpose
      model: claude-sonnet-4-6
      prompt: |
        security-review Skill 로드하여 보안 취약점 스캔.
        OWASP LLM Top 10 기준 검토.
        SendMessage로 reviewer-deep에게 보안 이슈 공유.
```

## 실행 흐름

```
PR 생성/업데이트
  └── TeamCreate (4명 병렬 시작)
        ├── reviewer-diff  → Blind Hunter 결과 → SendMessage → reviewer-deep
        ├── reviewer-deep  → 심화 리뷰 + 통합
        ├── qa-boundary    → 경계면 결과 → SendMessage → reviewer-deep
        └── security       → 보안 결과 → SendMessage → reviewer-deep
              └── 통합 리포트 작성 → PR comment 게시
  └── TeamDelete
```

## 통합 리포트 형식

```markdown
## 🤖 AIDD 자동 리뷰 리포트 — PR #{pr_number}

### 🔴 필수 수정 (Blocker)
- [ ] <항목>

### 🟡 권장 수정
- [ ] <항목>

### 🔒 보안
- <항목 또는 "이슈 없음">

### ✅ AC 충족 여부
- AC-1: ✅
- AC-2: ❌ — <미충족 이유>

### 🧪 테스트 커버리지
- <평가>

---
*reviewer-diff(Haiku) + reviewer-deep(Sonnet) + qa(Sonnet) + security(Sonnet) 병렬 검토*
*최종 승인은 사람 리뷰어 필수 (HITL L2)*
```

## HITL
- L2: 사람 최종 승인 (Merge 전 필수)
- L3: 보안 Critical 이슈 발견 시 2인+SRE 승인

## 팀 정리
리뷰 완료 후 `TeamDelete(team_name: pr-review-team)` 실행.
세션당 1팀만 활성 유지.

## 이벤트
```yaml
event_type: aidd_review_event
workflow_id: aidd-review-orchestrator
```
