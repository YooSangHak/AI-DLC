# Phase 0: 입력 모드 감지 + 컨텍스트 감사 (v2)

> `aidd-sdlc-orchestrator` 및 모든 Workflow가 진입 시 수행하는 공통 감사 절차.
> ADR-011 · NFR-11 (≤3초) · AC-8·9 (입력 모드 4종 감지) 준수.

---

## Part A. 입력 모드 4종 자동 감지

사용자 `<input>`을 받으면 **아래 순서대로 판별** (순서 중요 — 위에서 매칭되면 즉시 분기):

### 1순위: Jira 모드
```
패턴: ^[A-Z]+-\d+$
예시: JIRA-123, AIDD-42, FEAT-7
```
- `mcp-jira` 호출 → 티켓 상세(제목·AC·assignee·상태) 조회
- 조회 실패 시 → 자유 입력 모드로 fallback

### 2순위: 파일 모드 ⭐
```
조건: Read 도구로 파일 경로 존재 확인 + 확장자 .md / .txt
```
파일 유형별 진입 단계:

| 경로 패턴 | 유형 | 진입 단계 |
|---|---|---|
| `doc/epic-story/stories/AIDD-S*.md` | **Story** | `workflow-dev-story` (Implementation Steps 파싱) |
| `docs/requirements/*.md` | 요구사항 | Spec 단계부터 |
| `docs/adr/*.md` | ADR | Implement 단계부터 |
| `docs/specs/*.md` | Spec | Design 단계부터 |
| 기타 `.md` / `.txt` | 일반 | 자유 입력 모드 처리 |

**Story 파일 파싱 (AC-9)**:
```bash
# Implementation Steps 추출
grep -A 50 "## 5. Implementation Steps" <file> | grep -E "^\s*- \[.\]"
# → 각 step의 완료 여부([x] vs [ ]) 파악 후 재개 지점 결정
```
- YAML/Markdown frontmatter → `ai_consumer_metadata` 추출 (ADR-016)

### 3순위: URL 모드
```
조건: https?:// 로 시작
```
- Confluence URL (`confluence.`) → `mcp-confluence` 호출
- 기타 URL → `WebFetch` 도구로 내용 가져오기
- 가져온 내용을 자유 입력 모드와 동일하게 처리

### 4순위: 자유 입력 모드
```
조건: 위 3가지 모두 해당 없음 (자연어 문자열)
```
- 요구 분석 단계부터 전체 실행
- 입력 텍스트를 초기 요구사항으로 활용

---

## Part B. 컨텍스트 감사 (R1 요구 반영)

> Quick 모드(`--quick`)에서는 Part B 생략 — Part A 감지 후 즉시 Phase 1 진입.

### Step 1. `_workspace/` 존재 확인
```bash
ls _workspace/ 2>/dev/null && echo "EXISTS" || echo "NONE"
```
- 존재 → 이전 실행 기록 확인 (이어서 실행 가능성)
- 없음 → 초기 실행

### Step 2. 산출물 경로 체크 (S015 규약 기준)
```bash
TICKET_ID="<감지된 ID>"

# 요구사항
[ -f "docs/requirements/${TICKET_ID}.md" ] && echo "REQ: OK" || echo "REQ: MISSING"

# ADR
ls docs/adr/*${TICKET_ID}*.md 2>/dev/null && echo "ADR: OK" || echo "ADR: MISSING"

# Design/Spec
ls docs/specs/*${TICKET_ID}*.md 2>/dev/null && echo "SPEC: OK" || echo "SPEC: MISSING"

# 구현 (git log로 관련 커밋 확인)
git log --oneline --all --grep="${TICKET_ID}" 2>/dev/null | head -5

# 테스트
find tests/ -name "*${TICKET_ID}*" -o -name "*$(echo ${TICKET_ID} | tr 'A-Z-' 'a-z_')*" 2>/dev/null | head -5
```

각 체크 결과: `✅ 존재 (날짜)` / `❌ 없음`

### Step 3. 실행 모드 결정 매트릭스

| 상태 | 결정 | 동작 |
|---|---|---|
| 자료 전무 | 초기 실행 | Phase 1부터 전체 실행 |
| 일부 존재 | 부분 재실행 | 누락 단계만 실행 + 기존 자료 입력 활용 |
| 구현 중단 (Story [ ] 항목 존재) | 이어서 실행 | 중단 지점부터 재개 |
| `--full` 플래그 | 전체 재작성 | `_workspace_<YYYYMMDD_HHMMSS>/`로 보관 후 신규 |

### Step 4. 실행 계획 리포트 (사용자 제시)

```
📊 감사 결과 ({TICKET_ID})
══════════════════════════════════════
입력 모드: {jira|file|url|free}
실행 모드: {Standard|Quick|Full}

기존 자료:
  ✅ docs/requirements/{ID}.md  (2일 전, 1.2KB)
  ✅ docs/adr/015-{ID}.md       (1일 전, 2.4KB)
  ⚠️  src/ 구현 부분 완료       (커밋 3건)
  ❌ tests/ 없음                → 생성 예정

예정 단계:
  1. workflow-dev-story Step 3 (test)부터 이어서
  2. workflow-code-review-adversarial
  3. PR 생성 + HITL L2

예상 소요: 표준 대비 약 40% (기존 자료 활용)

실행하시겠습니까? [y / n / quick / full]
══════════════════════════════════════
```

### Step 5. 사용자 응답 처리

| 응답 | 동작 |
|---|---|
| `y` (또는 Enter) | 계획대로 Phase 1 진입 |
| `n` | 중단, 사용자에게 수정 요청 |
| `quick` | Quick 모드로 전환하여 즉시 실행 |
| `full` | Full 모드로 전환 (기존 자료 보관 후 전체 재실행) |

---

## 성능 요구 (NFR-11)

Phase 0 전체 (Part A + Part B) ≤ **3초** 완료.
- 파일 존재 체크: Bash `ls`/`find` — 수십ms
- git log: `--limit=5` 로 제한
- MCP 호출(Jira/Confluence): 비동기 실행, 타임아웃 2초 후 fallback
