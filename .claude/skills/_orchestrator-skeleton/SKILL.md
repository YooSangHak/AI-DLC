---
name: <orchestrator-name>
# 예: aidd-sdlc-orchestrator
description: |
  <!-- 언제 이 오케스트레이터가 활성화되는지 구체적으로 기술 -->
  <!-- 예: "/aidd-sdlc <입력>" 명령 또는 "SDLC 전체 실행", "스토리 구현" 요청 시 트리거 -->
tools:
  - Read
  - Glob
  - Bash(git *)
allowed-tools: Read Glob Bash(git *)
---

# 🎯 <오케스트레이터 이름>

## 역할
<!-- 이 오케스트레이터가 조율하는 전체 흐름을 한 문단으로 설명 -->
<!-- 예: SDLC 전체 또는 부분 작업을 오케스트레이션. 입력 모드 자동 감지 → 컨텍스트 감사 → Workflow·Agent 호출 → 결과 수집 -->

## Phase 0: 컨텍스트 감사 (필수)
<!-- 모든 L1 Orchestrator는 진입 시 Phase 0 수행 (ADR-011) -->

1. `_workspace/` 존재 여부 확인
2. 산출물 경로 규약(S015)에 따라 기존 파일 존재 확인:
   - `docs/requirements/<ID>.md`
   - `docs/adr/*<ID>*.md`
   - `docs/design/<ID>.md`
   - `src/` 변경 (`git log` 확인)
3. 실행 모드 결정:
   - **초기**: 자료 없음 → Phase 1부터 전체 실행
   - **부분 재실행**: 일부 있음 → 누락 단계만
   - **이어서**: 중단됨 → 해당 지점부터 재개
4. 사용자에게 실행 계획 보고 → 승인 요청 (HITL L2)

## 실행 모드
<!-- 필요 시 Quick/Standard/Full 3모드 지원 (ADR-011) -->
| 모드 | 트리거 | 동작 |
|---|---|---|
| Standard (기본) | 명령만 입력 | Phase 0 감사 → 계획 승인 → 실행 |
| Quick | `--quick` | 감사 생략, 기본값으로 전 단계 |
| Full | `--full` | 기존 자료 무시, 전체 재작성 |

## Phase 1: Workflow 결정
<!-- 누락된 단계에 맞는 Workflow 선택 로직 -->
<!-- 예: 요구·설계 완료 + 구현 누락 → workflow-dev-story만 호출 -->

## Phase 2: Workflow 실행
<!-- 각 Workflow 순차 실행 (파이프라인 패턴, ADR-003) -->
<!-- 중간 산출물은 _workspace/ 에 저장 -->

## Phase 3: 결과 보고
<!-- 산출물 검증 체크리스트 실행 -->
<!-- CLAUDE.md 변경 이력 테이블 업데이트 -->
<!-- _workspace/ 보존 (감사 추적) -->

## Input
<!-- 지원하는 입력 형식 목록 -->
- `<JIRA-ID>` — Jira 티켓 모드
- `<파일경로>` — 파일 모드 (Story·Requirements·ADR·Markdown)
- `<URL>` — URL 모드
- `"<자유 설명>"` — 자유 입력 모드

## Output
<!-- 생성·수정되는 파일 목록 -->
- `_workspace/<workflow_run_id>/` — 중간 산출물
- `docs/` 하위 산출물 (단계별)

## HITL
- L2: 실행 계획 승인 (Phase 0 완료 후)
- L2: 각 Workflow 완료 후 산출물 확인
- L3: 파괴적 작업 (DB 마이그레이션 등) 2인+SRE

## 이벤트
```yaml
event_type: aidd_<stage>_event
workflow_run_id: <uuid>
```
