---
artifact_type: governance-policy
story: AIDD-S024
produced_by: agent-architect
consumed_by: [all-agents, all-developers]
version: 1.0
date: 2026-04-21
---

# HITL (Human-in-the-Loop) 매트릭스

> PRD FR-7.1·7.2, 아키텍처 §4.1 기반.
> 핸드오프별 구체 체크리스트는 [S042 handoff-hitl-checklist.md](../decisions/handoff-hitl-checklist.md) 참조.

---

## 공통 원칙

| 레벨 | 자동/수동 | 정의 | 비용/지연 |
|---|---|---|---|
| **L1** | 자동 (AI 자율) | 이벤트 로깅만, 사람 개입 없음 | 없음 |
| **L2** | 인간 1인 승인 | 담당자 1인이 검토·승인 후 진행 | ~10분 |
| **L3** | 2인 이상 + 보안/SRE | 최소 2인 + SRE/보안 담당 승인 | ~30분 |

---

## L1 — 자동 (AI 자율)

AI가 결과를 이벤트로 기록하고 자동으로 다음 단계로 진행.

**적용 대상:**
- 린트 실행 (ruff, biome, tsc)
- 단위 테스트 실행 및 결과 기록
- PR diff 요약 생성
- 문서 자동 생성 (PT-07-DOCS)
- commit-guardrail 자동 체크 (300 LOC, 비밀 스캔)
- 코드 포맷 자동 수정 (`--write` 플래그)
- 의존성 취약점 스캔 (Snyk, Safety — 결과 리포트만)
- `_workspace/` 기록 및 요약

**이벤트 기록:** `.aidd/events/*.jsonl`

---

## L2 — 인간 1인 승인

담당자(아키텍트 또는 팀장) 1인이 결과물을 확인하고 명시적으로 승인해야 진행.

**적용 대상:**
- Spec(요구사항 정의서) 최초 작성 완료 → 승인 후 ADR 진행
- ADR 작성 완료 → 승인 후 구현 진행
- PR 최종 Approve (사람 리뷰어)
- 의존성 업데이트 (Major 버전 업)
- 외부 API 연동 설계 변경
- `explicit_ambiguities` 해소 확인 (ADR-016)
- Full 모드(`--full`) 기존 자료 보관 후 재실행
- Phase 0 실행 계획 승인

**승인 방법:**
- GitHub PR Approve
- 또는 HITL 승인 메시지: `AIDD-APPROVE: <사유>` 채팅 입력
- Jira 상태: `In Review` → `Approved` 전환

**리포별 L2 승인자:**

| 리포 | L2 승인자 | 대리 |
|---|---|---|
| {repo-1} | {architect-name} | {team-lead} |
| {repo-2} | {architect-name} | {team-lead} |
| {repo-3} | {architect-name} | {team-lead} |
| {repo-4} | {architect-name} | {team-lead} |
| {repo-5} | {architect-name} | {team-lead} |

> 실명은 리포별 CLAUDE.md에 기입.

---

## L3 — 2인 이상 + 보안/SRE 승인

최소 2인 + 보안 담당 또는 SRE가 각각 승인해야 진행. 전원 승인 전까지 실행 차단.

**적용 대상:**
- 프로덕션 배포 (canary → 100% 전환)
- DB 마이그레이션·스키마 변경
- 인증·권한 로직 변경
- 블랙리스트 명령 실행 (`rm -rf`, `DROP TABLE`, `git push --force`, `kubectl delete`)
- 프로덕션 인프라 설정 변경 (Helm values, ArgoCD 앱 설정)
- 보안 정책 변경 (IAM, RBAC, 방화벽 규칙)
- Kill-switch 해제
- Secrets Manager 접근 키 교체

**승인 방법:**
- GitHub Environment Protection Rules (production 환경)
- 또는 Slack 승인 스레드: `AIDD-L3-APPROVE: <사유>` + 2인 이상 리액션
- `AIDD_SECOND_APPROVER` 환경변수 설정 (pre-tool.sh 연동)

**리포별 L3 승인자:**

| 리포 | 승인자 1 | 승인자 2 | SRE/보안 |
|---|---|---|---|
| {repo-1} | {name-1} | {name-2} | {sre-name} |
| {repo-2} | {name-1} | {name-2} | {sre-name} |
| {repo-3} | {name-1} | {name-2} | {sre-name} |
| {repo-4} | {name-1} | {name-2} | {sre-name} |
| {repo-5} | {name-1} | {name-2} | {sre-name} |

> 실명은 리포별 CLAUDE.md의 `## HITL Matrix` 섹션에 기입.

---

## Agent별 HITL 적용 매트릭스

| Agent | L1 (자동) | L2 (1인 승인) | L3 (2인+SRE) |
|---|---|---|---|
| `agent-analyst` | 분석 초안 생성 | 요구사항 승인 | — |
| `agent-pm` | Story 초안·PR diff 요약 | Spec·Story 승인 | — |
| `agent-architect` | 다이어그램 생성 | ADR 승인 | 보안 아키텍처 변경 |
| `agent-dev` | 린트·단위 테스트·자동 커밋 | PR Approve | — |
| `agent-qa` | 테스트 실행·커버리지 기록 | Flaky 재현 시 | — |
| `agent-reviewer` | PR diff 요약·자동 코멘트 | 최종 PR Approve | 보안 이슈 발견 시 |
| `agent-deployer` | SBOM·릴리즈 노트 생성 | Canary 시작 승인 | 프로덕션 100% 전환 |
| `agent-janitor` | 감사 리포트 생성 | 삭제 대상 확인 | — |

---

## HITL 위반 시 대응

| 위반 유형 | 자동 대응 | 보고 |
|---|---|---|
| L2 승인 없이 ADR 기반 구현 시작 | AI가 경고 후 중단 | `.aidd/events/` 기록 |
| L3 승인 없이 프로덕션 배포 | GitHub Actions 차단 (environment protection) | Slack 알림 |
| 블랙리스트 명령 단독 실행 시도 | `pre-tool.sh` 즉시 차단 | 로그 기록 |
| Kill-switch 트리거 | `post-tool.sh` 세션 종료 | 월간 리포트 포함 |

---

## CLAUDE.md 삽입 스니펫

각 리포의 `CLAUDE.md`에 아래를 붙여넣고 `{…}` 플레이스홀더를 실명으로 교체:

```markdown
## HITL Matrix
- **L1 (자동)**: 린트·단위 테스트·PR diff 요약 — AI 자율 진행
- **L2 (인간 리뷰)**: Spec·ADR 작성 완료 / PR 최종 승인 — {l2_approver} 확인 필수
- **L3 (2인+SRE)**: 프로덕션 배포·DB 마이그레이션·블랙리스트 명령
  - 승인자: {name-1}, {name-2}
  - SRE/보안: {sre-name}
```

상세 정책: `docs/governance/hitl-matrix.md`
