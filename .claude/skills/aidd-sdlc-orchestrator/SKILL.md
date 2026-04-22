---
name: aidd-sdlc-orchestrator
description: |
  AIDD SDLC 전체를 오케스트레이션. `/aidd-sdlc <입력>` 진입점.
  입력 모드 4종 자동 감지: (1) Jira 티켓 ID (2) 파일 경로 (Story/Requirements/ADR/Spec/Markdown)
  (3) URL (Confluence 등) (4) 자유 설명.
  "SDLC 시작", "기능 개발", "티켓 작업 시작", "이 Story 실행", "파일로 시작" 요청 시 트리거.
  후속 키워드: "이어서", "재실행", "부분 수정", "업데이트", "보완", "한 단계만 다시".
allowed-tools: Read Glob Bash(git *) Bash(mcp *)
---

# 🎯 AIDD SDLC Orchestrator

## 역할
개발자가 `/aidd-sdlc <입력>` 한 줄로 SDLC 전체 또는 부분을 시작할 수 있도록 조율한다.
입력 모드 자동 감지 → Phase 0 컨텍스트 감사 → 필요한 Workflow만 선택 실행 → 결과 수집.

## 진입 명령 (4가지 모드)
| 모드 | 예시 | 처리 |
|---|---|---|
| Jira | `/aidd-sdlc JIRA-123` | mcp-jira로 티켓 조회 |
| 파일 | `/aidd-sdlc docs/stories/AIDD-S020.md` | 파일 읽고 파싱 |
| URL | `/aidd-sdlc https://confluence.../page` | WebFetch 또는 mcp-confluence |
| 자유 | `/aidd-sdlc "로그인 기능 구현해줘"` | 요구 분석부터 시작 |

플래그: `--quick` (감사 생략) · `--full` (전체 재작성)

## Phase 0: 입력 감지 + 컨텍스트 감사
`references/phase0-audit.md` 로드하여 수행.

1. 입력 패턴으로 모드 자동 감지:
   - `[A-Z]+-\d+` 패턴 → Jira 모드
   - 경로 존재 + `.md`/`.txt` → 파일 모드
   - `https?://` → URL 모드
   - 그 외 → 자유 입력 모드
2. 파일 모드 유형별 분기:
   - `docs/stories/*.md` → Story (AC·Steps 추출)
   - `docs/prd/*.md` → Spec 단계부터
   - `docs/adr/*.md` → Implement 단계부터
   - `docs/specs/*.md` → Design 단계부터
   - 기타 `.md` → 일반 입력
3. 산출물 경로 규약 기준 기존 파일 확인:
   - `docs/requirements/` · `docs/prd/` · `docs/adr/` · `docs/design/` · `docs/specs/` · `docs/stories/`
4. 실행 모드 결정 (초기·부분·이어서)
5. **사용자에게 실행 계획 보고 → 승인 요청 (HITL L2)**

## Phase 1: Workflow 선택
`references/phase-selection-matrix.md` 참조하여 누락된 단계에 맞는 Workflow 결정.

## Phase 2: Workflow 실행 (순차 파이프라인, ADR-003)
- 선택된 Workflow를 순차 실행
- 각 Workflow 완료 후 산출물을 `_workspace/<workflow_run_id>/` 에 저장
- HITL L2 지점에서 사용자 승인 대기

## Phase 3: PR 생성 시 Review 오케스트레이터 호출
- PR 생성 감지 → `aidd-review-orchestrator` 자동 호출
- 팀 모드: reviewer-diff · reviewer-deep · qa · security 병렬 실행

## Phase 4: 결과 보고·변경 이력
- 산출물 검증 (checklist)
- CLAUDE.md 변경 이력 테이블 업데이트 (S038)
- `_workspace/` 보존 (감사 추적)
- `aidd_interaction_event` 기록

## HITL
- L2: Phase 0 실행 계획 승인
- L2: 각 Workflow 주요 산출물 (Spec·ADR·PR)
- L3: 파괴적 작업 (DB 마이그레이션·스키마 변경) 2인+SRE
