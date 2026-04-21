# [공통] Phase 0: 입력 모드 감지 + 컨텍스트 감사

> 모든 Workflow의 step-01에서 본 섹션을 먼저 수행한다.
> Quick 모드(`--quick`)에서는 **A단계만** 수행하고 B·C를 생략한다.
> 상세 로직: `aidd-sdlc-orchestrator/references/phase0-audit.md`

---

## A. 입력 모드 감지 (항상 수행, ≤1초)

```
입력값을 받아 아래 순서로 판별:

1. 정규식 ^[A-Z]+-\d+$  → Jira 모드  (mcp-jira 조회)
2. 파일 경로 + .md/.txt  → 파일 모드  (Read 후 유형 분류)
3. https?://             → URL 모드   (Confluence/WebFetch)
4. 나머지                → 자유 입력 모드
```

판별 결과를 `TICKET_ID`(또는 요약 키) 변수로 저장 후 B단계 진입.

---

## B. 컨텍스트 감사 (Standard/Full, ≤2초)

```bash
# 산출물 존재 체크
[ -f "docs/requirements/${TICKET_ID}.md" ] && echo "REQ ✅" || echo "REQ ❌"
ls docs/adr/*${TICKET_ID}*.md 2>/dev/null && echo "ADR ✅" || echo "ADR ❌"
ls docs/specs/*${TICKET_ID}*.md 2>/dev/null && echo "SPEC ✅" || echo "SPEC ❌"
git log --oneline --all --grep="${TICKET_ID}" --max-count=5 2>/dev/null
find tests/ -name "*${TICKET_ID}*" 2>/dev/null | head -3
```

---

## C. 실행 계획 리포트 + 사용자 승인 (Standard)

감사 결과를 아래 형식으로 제시하고 `[y/n/quick/full]` 응답을 받는다:

```
📊 Phase 0 감사 — {TICKET_ID}
──────────────────────────────
입력 모드 : {jira|file|url|free}
실행 모드 : {Standard|Quick|Full}

기존 자료 :
  {✅|❌} docs/requirements/{ID}.md
  {✅|❌} docs/adr/*{ID}*.md
  {✅|❌} src/ 구현
  {✅|❌} tests/ 테스트

→ {초기 실행|부분 재실행|이어서 실행} — {설명}

실행하시겠습니까? [y / n / quick / full]
──────────────────────────────
```

승인(`y`) 후 Step 1 본 작업으로 진입.
