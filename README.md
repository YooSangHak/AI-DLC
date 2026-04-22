# AIDD 통합 환경 — 템플릿 리포

> **조직**: AX솔루션기획팀  
> **목적**: 5개 코어 리포에 배포하는 **통합 AIDD 개발 환경** 표준 자산  
> **기준일**: 2026-04-21  
> **아키텍처**: [AIDD_2026_05월_아키텍처.md](docs/AIDD_2026_05월_아키텍처.md) (v3.7)

---

## 개요

이 리포는 **aidd-repo-template** — 5개 코어 리포에 복사·배포하는 AIDD 표준 자산의 원본입니다.

```
개발자가 /aidd-sdlc <티켓> 한 줄로 SDLC 전체를 시작한다.
Claude Code가 Phase 0 감사 → Workflow 선택 → Agent 호출 → PR 생성까지 조율한다.
```

### 5계층 자산 구조

```
L1 Orchestrator  →  L2 Workflow  →  L3 Agent  →  L4 Skill  →  L5 Prompt
   (조율)              (단계)          (역할)        (규칙)        (템플릿)
```

---

## 빠른 시작

```bash
# 1. 프로젝트 생성 (git 히스토리 없이 클린하게 시작)
npx degit YooSangHak/AI-DLC my-project
cd my-project

# 2. CLAUDE.md 리포별 변수 치환
# {project_name}, {stack}, {runtime}, {branch_strategy}, {l3_approvers}

# 3. MCP 서버 설정 (.mcp.json에 API key 등록)

# 4. pre-commit 훅 활성화
pre-commit install

# 5. Claude Code에서 실행
/aidd-sdlc JIRA-123
```

> `npx degit`은 Node.js만 있으면 별도 설치 없이 사용 가능합니다.

---

## 디렉터리 구조

```
.
├── CLAUDE.md                          # 전역 AI 규칙 (≤60줄, Claude Code용)
├── CLAUDE.md.template                 # 리포별 커스터마이즈 템플릿
├── templates/
│   ├── AGENTS.md.template             # Copilot·AGENTS 지원 도구용
│   └── .cursorrules.template          # Cursor 네이티브 포맷
│
├── .claude/
│   ├── agents/                        # L3 Agent 빌트인 매핑 (8종)
│   │   ├── analyst.md   pm.md   architect.md   dev.md
│   │   ├── qa.md        reviewer.md   deployer.md   janitor.md
│   │
│   ├── skills/                        # L1~L4 전체 Skill (슬래시 명령)
│   │   ├── [L1] aidd-sdlc-orchestrator/    # /aidd-sdlc 진입점
│   │   ├── [L1] aidd-review-orchestrator/  # PR 팀 리뷰
│   │   ├── [L2] workflow-dev-story/        # Story 구현 5단계
│   │   ├── [L2] workflow-create-prd/
│   │   ├── [L2] workflow-create-architecture/
│   │   ├── [L2] workflow-create-story/
│   │   ├── [L2] workflow-code-review-adversarial/
│   │   ├── [L3] agent-analyst/  agent-pm/  agent-architect/  agent-dev/
│   │   ├── [L3] agent-qa/  agent-reviewer/  agent-deployer/  agent-janitor/
│   │   ├── [L4] convention-py/  convention-ts/  commit-guardrail/
│   │   ├── [L4] review-checklist/  security-review/  deploy-procedure/
│   │   ├── [L4] code-review-adversarial/  create-architecture-checklist/
│   │   ├── [L4] retrospective/  brainstorming/  pr-hygiene/
│   │   ├── [L4] pre-handoff-adversarial/  self-healing/
│   │   └── [스켈레톤] _orchestrator-skeleton/  _workflow-skeleton/
│   │              agent-_skeleton/  _skill-skeleton/  _shared/
│   │
│   ├── prompts/                       # L5 Prompt Templates (7종)
│   │   ├── PT-01-IMPLEMENT-v1.md      # agent-dev
│   │   ├── PT-03-REVIEWER-v1.md       # agent-reviewer
│   │   ├── PT-05-LEGACY-UNDERSTAND-v1.md  # Gemini 2.5 Pro 2M
│   │   ├── PT-06-TEST-ADD-v1.md       # agent-qa
│   │   ├── PT-07-DOCS-v1.md           # 공통
│   │   ├── PT-09-DEPS-UPDATE-v1.md    # 공통
│   │   └── PT-11-DESIGN-v1.md         # agent-architect
│   │
│   ├── hooks/                         # Claude Code Hooks (보안·비용)
│   │   ├── pre-prompt.sh              # 비밀·PII 차단 + 인젝션 방어
│   │   ├── pre-tool.sh                # 블랙리스트 명령 2인 확인
│   │   └── post-tool.sh               # Kill-switch + 비용 모니터
│   │
│   └── settings.json                  # Hook 이벤트 바인딩
│
├── .github/workflows/
│   ├── ci.yml                         # 3중 스택 품질 게이트 (Py·TS·Java)
│   ├── pr-review.yml                  # Claude + Copilot + CodeRabbit 병렬
│   ├── build-deploy.yml               # Sigstore 서명 + SBOM + canary
│   ├── cost-monitor.yml               # 월간 API 비용 Kill-switch
│   ├── janitor-weekly.yml             # 주간 agent-janitor 자동 감사
│   └── claude-md-lint.yml             # CLAUDE.md 60줄 강제
│
├── .mcp.json                          # MCP 서버 설정 (git·github·jira·confluence)
├── .pre-commit-config.yaml            # pre-commit 훅 (LOC·Secret·deps)
│
└── docs/
    ├── governance/                    # 운영 정책 (HITL·핸드오프·이벤트 스키마 등)
    ├── prompts/                       # PT 인덱스 및 작성 템플릿
    ├── requirements/                  # analyst 산출물 — 요구사항 정의서
    ├── prd/                           # pm 산출물 — PRD
    ├── adr/                           # architect 산출물 — ADR
    ├── design/                        # architect 산출물 — 설계 상세
    ├── specs/                         # architect 산출물 — Spec
    ├── stories/                       # pm 산출물 — Epic·Story·AC
    ├── test/                          # qa 산출물 — 테스트 케이스
    ├── retrospective/                 # 분기 회고
    └── janitor-reports/               # 주간 감사 리포트
```

---

## 슬래시 명령 목록

| 명령 | 계층 | 설명 |
|---|---|---|
| `/aidd-sdlc <입력>` | L1 | SDLC 메인 진입점 (Jira·파일·URL·자유 입력) |
| `/aidd-review` | L1 | PR 팀 모드 리뷰 (GHA 자동 트리거) |
| `/workflow-dev-story` | L2 | Story 구현 5단계 |
| `/workflow-create-prd` | L2 | PRD 작성 3단계 |
| `/workflow-create-architecture` | L2 | 아키텍처 작성 5단계 |
| `/workflow-create-story` | L2 | Epic/Story 분해 3단계 |
| `/workflow-code-review-adversarial` | L2 | 적대적 코드 리뷰 3단계 |
| `/agent-analyst` `/agent-pm` `/agent-architect` | L3 | 역할별 Agent 직접 호출 |
| `/agent-dev` `/agent-qa` `/agent-reviewer` | L3 | 〃 |
| `/agent-deployer` `/agent-janitor` | L3 | 〃 |
| `/convention-py` `/convention-ts` | L4 | 코딩 컨벤션 (자동 로드) |
| `/commit-guardrail` | L4 | 300 LOC·비밀·PII 가드 |
| `/security-review` | L4 | OWASP LLM Top 10 스캔 |
| `/code-review-adversarial` | L4 | Blind Hunter + Edge Case |
| `/pre-handoff-adversarial` | L4 | 핸드오프 전 adversarial |
| `/self-healing` | L4 | 린트·타입 실패 자동 교정 |
| `/review-checklist` `/deploy-procedure` | L4 | 리뷰·배포 절차 |
| `/create-architecture-checklist` | L4 | ADR 완성도 점검 |
| `/retrospective` `/brainstorming` `/pr-hygiene` | L4 | 운영·기획·위생 |

---

## 실행 모드

| 모드 | 명령 | 동작 |
|---|---|---|
| **Standard** (기본) | `/aidd-sdlc <ID>` | Phase 0 감사 → 계획 승인 → 필요한 것만 실행 |
| **Quick** | `/aidd-sdlc <ID> --quick` | 감사 생략, 기본값으로 전 단계 실행 |
| **Full** | `/aidd-sdlc <ID> --full` | 기존 자료 무시, 전체 재작성 |

---

## HITL (Human-in-the-Loop) 정책

| 등급 | 적용 | 승인자 |
|---|---|---|
| **L1** (자동) | 린트·단위 테스트·PR diff 요약 | — |
| **L2** (인간 리뷰) | Spec·ADR·PR 최종 승인 | 담당 개발자 |
| **L3** (2인+SRE) | 프로덕션 배포·파괴적 작업·보안 이슈 | 보안 담당 + SRE |

상세: [docs/governance/hitl-matrix.md](docs/governance/hitl-matrix.md)

---

## 보안 (Hooks 3중 방어)

```
사용자 입력 → pre-prompt.sh (비밀·PII·인젝션 차단)
도구 실행  → pre-tool.sh   (블랙리스트 2인 확인)
도구 완료  → post-tool.sh  (비용 Kill-switch)
git commit → pre-commit    (300 LOC·Secret 스캔·의존성 체크)
PR/push    → GitHub Actions (재검증 + 서명·SBOM·canary)
```

---

## 코어 리포 배포 체크리스트

- [ ] `CLAUDE.md` — 변수 치환 (`{project_name}`, `{stack}`, `{l3_approvers}`)
- [ ] `templates/AGENTS.md.template` → `AGENTS.md` 생성 후 변수 치환
- [ ] `templates/.cursorrules.template` → `.cursorrules` 생성 후 변수 치환
- [ ] `.mcp.json` — API key 등록 (Secret Manager 연동)
- [ ] `pre-commit install` 실행
- [ ] GitHub Actions Secret 등록 (`ANTHROPIC_API_KEY`, `SNYK_TOKEN` 등)
- [ ] Claude Code에서 `/aidd-sdlc <테스트 티켓>` 스모크 테스트

---

## 관련 문서

| 문서 | 위치 |
|---|---|
| 아키텍처 설계서 | `Workspace_AX_Enabling_Tech_AIDD/doc/AIDD_2026_05월_아키텍처.md` |
| PRD | `Workspace_AX_Enabling_Tech_AIDD/doc/AIDD_2026_05월_PRD.md` |
| Epic & Stories | `Workspace_AX_Enabling_Tech_AIDD/doc/epic-story/` |
| 구현 현황 결과서 | [etc/AIDD-구현현황-결과서.md](etc/AIDD-구현현황-결과서.md) |
| 구현 현황 상세 | [etc/AIDD-IMPLEMENTATION-STATUS.md](etc/AIDD-IMPLEMENTATION-STATUS.md) |

---

## Changelog

- **2026-04-21 (v1.0)**: 최초 작성. 구현 완료 기준 (AI 직접 구현 29/32건 완료).
