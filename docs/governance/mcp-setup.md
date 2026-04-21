---
artifact_type: setup-guide
story: AIDD-S026, AIDD-S027
produced_by: agent-architect
date: 2026-04-21
---

# MCP 필수 3종 연동 가이드

> PRD FR-6.1·6.2·6.3, 아키텍처 §9 기반.
> 필수(S026): git · github · jira  |  권장(S027): confluence
> mcp-docs(사내): 6월+ 재검토 (S005 결과 이연)

---

## 환경 변수 설정

각 리포의 `.env.local` (git-ignored) 또는 Secret Manager에 주입:

```bash
# GitHub (필수 — S026)
export GITHUB_TOKEN="ghp_xxxxxxxxxxxx"        # Fine-grained PAT

# Jira (필수 — S026)
export JIRA_HOST="https://yourorg.atlassian.net"
export JIRA_EMAIL="you@yourorg.com"
export JIRA_API_TOKEN="xxxxxxxxxxxxxxxx"        # Atlassian API Token

# Confluence (권장 — S027)
export CONFLUENCE_HOST="https://yourorg.atlassian.net"
export CONFLUENCE_TOKEN="xxxxxxxxxxxxxxxx"      # Atlassian API Token (Jira와 동일 계정)
```

**주의:** `.env` 파일을 절대 커밋하지 마십시오 (pre-prompt.sh / pre-tool.sh 자동 차단).

### Secret Manager 주입 방식 (권장)

```bash
# AWS Secrets Manager 예시
aws secretsmanager get-secret-value \
  --secret-id aidd/github-token \
  --query SecretString \
  --output text | jq -r '.GITHUB_TOKEN' | export GITHUB_TOKEN
```

---

## `.mcp.json` 배포 (5개 리포 공통)

프로젝트 루트에 `.mcp.json` 복사 후 커밋:

```bash
cp .mcp.json <repo-root>/.mcp.json
# 리포별 description 수정 후 커밋
git add .mcp.json && git commit -m "chore: add MCP config (AIDD-S026)"
```

---

## 개인 설정 (`~/.claude/mcp_config.json`)

사용자별 글로벌 MCP 설정 (선택):

```json
{
  "mcpServers": {
    "git": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-git", "--repository", "."]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "jira": {
      "command": "npx",
      "args": ["-y", "@atlassian/mcp-jira"],
      "env": {
        "JIRA_HOST": "${JIRA_HOST}",
        "JIRA_EMAIL": "${JIRA_EMAIL}",
        "JIRA_API_TOKEN": "${JIRA_API_TOKEN}"
      }
    }
  }
}
```

---

## 스모크 테스트 (S026 AC-2, S027 AC-1)

각 리포에서 Claude Code 세션 내 실행:

```
# mcp-git (필수)
/mcp git status

# mcp-github (필수)
/mcp github list_issues --repo owner/repo --state open

# mcp-jira (필수)
/mcp jira get_issue --issue AIDD-1

# mcp-confluence (권장)
/mcp confluence get_page --title "아키텍처 개요"
```

성공 시 각 도구의 JSON 응답이 반환됩니다.

---

## mcp-docs (사내) — 이연 결정 (S027 AC-2)

**결정**: 6월+ 재검토 (이연)

**사유**: S005 사내 문서 MCP 검토 결과, 인프라팀 지원 및 사내 SSO 연동이 필요하여 5월 스코프 외. Confluence MCP가 일부 역할 대체 가능.

**재검토 조건**:
- 인프라팀 MCP 서버 셋업 완료
- 사내 SSO OAuth2 연동 가이드 확보
- 6월 스프린트 계획 시 재평가

---

## Agent별 MCP 사용 매핑

| Agent | 사용 MCP | 목적 |
|---|---|---|
| `aidd-sdlc-orchestrator` | jira | Phase 0 — Jira 모드 티켓 조회 |
| `agent-analyst` | jira | 티켓 상세·AC 조회 |
| `agent-pm` | jira, github | 티켓 상태 업데이트, PR 생성 |
| `agent-dev` | git, github | 브랜치 생성, 커밋, PR 생성 |
| `agent-reviewer` | git, github | PR diff 조회, 코드 리뷰 코멘트 |
| `agent-deployer` | git, github | Release 생성, CHANGELOG 커밋 |
| `agent-janitor` | git, github | 오래된 브랜치·이슈 정리 |

---

## 트러블슈팅

| 증상 | 원인 | 해결 |
|---|---|---|
| `GITHUB_TOKEN not found` | env 미설정 | `.env.local`에 export 추가 |
| Jira 401 Unauthorized | API Token 만료 | Atlassian 계정에서 재발급 |
| `npx: command not found` | Node.js 미설치 | `nvm install 20 && nvm use 20` |
| MCP 서버 타임아웃 | 네트워크 이슈 | VPN/프록시 확인 |
