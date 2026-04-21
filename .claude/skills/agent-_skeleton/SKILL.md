---
name: agent-<role>
# 예: agent-dev, agent-architect, agent-pm
description: |
  <!-- 역할 한 줄 설명. Claude가 언제 이 Agent를 활성화할지 판단에 사용 -->
  <!-- "pushy"하게: 구체 상황·키워드·후속 트리거 포함 -->
  <!-- 예: 💻 개발자 에이전트. "구현", "코드 작성", "버그 수정", "/agent-dev" 요청 시 트리거 -->
model: claude-sonnet-4-6
# agent-architect: opus-4-7 / agent-reviewer(diff): haiku-4-5
allowed-tools: Read Write Edit Grep Glob Bash(git *)
---

# <이모지> <한국어 역할명> (<English Role> Agent)

## 역할
<!-- 이 Agent의 핵심 책임을 1~2문장으로 -->

## 원칙
1. <!-- 가장 중요한 원칙 (예: Test-first) -->
2. <!-- 300 LOC 초과 diff 금지 -->
3. <!-- CLAUDE.md Stack·Conventions 먼저 읽기 -->
4. <!-- 불확실하면 추측 금지, 다른 Agent 또는 사용자에게 확인 -->
5. <!-- 역할 특화 원칙 -->

## 메뉴
| 코드 | 설명 | 실행 |
|---|---|---|
| <!-- 예: IM --> | <!-- 기능 구현 --> | <!-- workflow 또는 PT --> |
| | | |

## Input
- <!-- 필요한 파일/데이터 형식 -->

## Task
1. <!-- 구체적인 작업 순서 (동사 시작) -->
2.
3.

## Output Format
```
<!-- 생성 파일 경로 패턴 -->
```

## Constraints
- **300 LOC 초과 diff 금지** (commit-guardrail)
- 비밀·PII 커밋 금지
- HITL: L1 자동 / L2 사람 승인 / L3 파괴적 작업 2인
- <!-- 역할 특화 제약 -->

## 팀 통신 프로토콜 (팀 모드 시)
- <!-- SendMessage 대상과 내용 -->

## Context 로드 순서
1. CLAUDE.md (Stack·Conventions·AI Usage Rules)
2. <!-- 역할에 맞는 추가 컨텍스트 -->
3. <!-- 예: 관련 Story, ADR, 기존 코드 -->
