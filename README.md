# AI-DLC — AIDD 개발 환경 하네스

Claude Code 기반 AI-Driven Development 환경. 8종 에이전트·워크플로·거버넌스 정책을 포함한 신규 프로젝트 시작 템플릿.

---

## 시작하기

```bash
npx degit YooSangHak/AI-DLC my-project
cd my-project
```

> Node.js만 있으면 별도 설치 없이 사용 가능합니다.

---

## 설치 후 초기 설정

### 1. CLAUDE.md 수정
`CLAUDE.md.template`을 참고해 현재 프로젝트에 맞게 `CLAUDE.md`를 수정합니다.

```yaml
# 수정할 항목
- Project 이름
- Stack (Language / Runtime / Build)
- Architecture 요약
```

### 2. pre-commit 훅 활성화
```bash
pip install pre-commit
pre-commit install
```

### 3. GitHub Actions Secrets 등록
| Secret | 용도 |
|---|---|
| `ANTHROPIC_API_KEY` | Claude Code PR 리뷰 |
| `SNYK_TOKEN` | 의존성 보안 스캔 |

### 4. Claude Code에서 실행
```bash
claude
/aidd-sdlc-orchestrator "기능 설명"
```

---

## 슬래시 명령

| 명령 | 설명 |
|---|---|
| `/aidd-sdlc-orchestrator <입력>` | SDLC 메인 진입점 — 파일·자유 입력 |
| `/workflow-create-prd` | PRD 작성 |
| `/workflow-create-architecture` | ADR·설계 문서 작성 |
| `/workflow-create-story` | Epic·Story 분해 |
| `/workflow-dev-story` | Story 구현 (test-first) |
| `/workflow-code-review-adversarial` | 적대적 코드 리뷰 |
| `/agent-analyst` `/agent-pm` `/agent-architect` | 에이전트 직접 호출 |
| `/agent-dev` `/agent-qa` `/agent-reviewer` | 〃 |
| `/agent-deployer` `/agent-janitor` | 〃 |
| `/security-review` | OWASP LLM Top 10 스캔 |
| `/commit-guardrail` | 커밋 전 300 LOC·비밀·PII 점검 |
| `/retrospective` | 분기 회고 |

---

## 디렉토리 구조

```
.
├── CLAUDE.md                  # AI 규칙 (수정 필요)
├── CLAUDE.md.template         # 수정 참고용 템플릿
├── .claude/
│   ├── agents/                # 8종 에이전트 정의
│   ├── skills/                # 워크플로·스킬 (슬래시 명령)
│   ├── prompts/               # 프롬프트 템플릿 (PT-01~11)
│   ├── hooks/                 # 보안·비용 Hooks
│   └── settings.json          # Hook 이벤트 바인딩
├── .github/workflows/
│   ├── ci.yml                 # 품질 게이트
│   ├── pr-review.yml          # PR 자동 리뷰
│   ├── janitor-weekly.yml     # 주간 감사
│   └── cost-monitor.yml       # API 비용 모니터
├── docs/
│   ├── AI-DLC-아키텍처.md     # 아키텍처 문서
│   ├── governance/            # HITL·핸드오프·이벤트 정책
│   ├── prompts/               # PT 인덱스·템플릿
│   ├── requirements/          # 요구사항 정의서 (analyst 산출물)
│   ├── prd/                   # PRD (pm 산출물)
│   ├── adr/                   # ADR (architect 산출물)
│   ├── design/                # 설계 문서 (architect 산출물)
│   ├── specs/                 # Spec (architect 산출물)
│   ├── stories/               # Story·AC (pm 산출물)
│   ├── test/                  # 테스트 케이스 (qa 산출물)
│   ├── retrospective/         # 분기 회고
│   └── janitor-reports/       # 주간 감사 리포트
├── templates/
│   ├── CLAUDE.md.template
│   ├── AGENTS.md.template     # Copilot·AGENTS 지원 도구용
│   └── .cursorrules.template  # Cursor용
├── .mcp.json                  # MCP 서버 설정
└── .pre-commit-config.yaml    # pre-commit 훅
```

---

## HITL 정책

| 등급 | 적용 | 승인자 |
|---|---|---|
| **L1** (자동) | 린트·단위 테스트·PR diff 요약 | — |
| **L2** (인간) | Spec·ADR·PR 최종 승인 | 담당 개발자 |
| **L3** (2인+) | 프로덕션 배포·파괴적 작업 | 보안 담당 + SRE |

상세: [docs/governance/hitl-matrix.md](docs/governance/hitl-matrix.md)

---

## 참고 문서

- [아키텍처](docs/AI-DLC-아키텍처.md)
- [MCP 설정 가이드](docs/governance/mcp-setup.md)
- [핸드오프 체크리스트](docs/governance/handoff-hitl-checklist.md)
