---
artifact_type: governance-policy
story: AIDD-S041
produced_by: agent-architect
consumed_by: [all-agents]
version: 1.0
date: 2026-04-21
---

# Context Enrichment 메타 필드 규약 (ADR-016)

> 재귀 품질 방어 1/3 — 하류 Agent가 상류 모호함을 추측으로 채우지 않도록 강제.

---

## 메타 필드 스키마 (YAML frontmatter)

모든 Agent 산출물 `.md` 파일 최상단에 아래 frontmatter를 포함해야 한다:

```yaml
---
artifact_type: <requirements|adr|spec|implementation|test-report|review>
produced_by: <agent-name>
consumed_by: [<agent-name>, ...]
constraints:
  stack: [Python 3.12, FastAPI]          # 기술 스택 제약
  forbidden_patterns: [raw SQL, global state]
  performance_budget_ms: 200             # 성능 예산 (해당 시)
  test_coverage_min: 80                  # 커버리지 최소값
explicit_ambiguities:                    # 미해소 모호함 — 하류 AI 추측 차단
  - id: AMB-001
    description: "캐시 무효화 전략 미결정"
    owner: agent-architect
    deadline: 2026-05-10
upstream_refs:                           # 상류 산출물 참조
  - path: docs/requirements/JIRA-123.md
    artifact_type: requirements
rework_hints: []                         # 재작업 시 참고 사항
---
```

---

## 필드별 설명

| 필드 | 필수 | 설명 |
|---|---|---|
| `artifact_type` | ✅ | 산출물 유형 |
| `produced_by` | ✅ | 생성 Agent |
| `consumed_by` | ✅ | 다음 Agent 목록 — 핸드오프 대상 명시 |
| `constraints` | ✅ | 하류 Agent가 반드시 따라야 할 제약 |
| `explicit_ambiguities` | ✅ | 미결정 사항 목록 (없으면 `[]`) |
| `upstream_refs` | 권장 | 참조한 상류 산출물 경로 |
| `rework_hints` | 선택 | 재작업 시 주의사항 |

---

## Agent별 필수 산출물 경로 + frontmatter

| Agent | 산출물 경로 | artifact_type |
|---|---|---|
| agent-analyst | `docs/requirements/<ticket>.md` | `requirements` |
| agent-pm | `docs/specs/<feature>.md` | `spec` |
| agent-architect | `docs/adr/<nnn>-<title>.md` | `adr` |
| agent-dev | `_workspace/<run_id>/03_code_diff.md` | `implementation` |
| agent-qa | `_workspace/<run_id>/04_test_report.md` | `test-report` |
| agent-reviewer | PR comment + `_workspace/<run_id>/05_review_findings.md` | `review` |

---

## `explicit_ambiguities` 운영 규칙

1. 상류 산출물에 모호함이 있으면 **추측하지 말고** `explicit_ambiguities`에 기록
2. HITL L2 승인 전 담당자(`owner`)가 해소해야 함
3. 해소 후 해당 항목 제거 + `upstream_refs`에 해소 문서 추가
4. 미해소 상태로 `consumed_by` Agent가 진행 시 → 경고 발행 후 L2 승인 요청

---

## CI 검증 (S041 AC-3)

```bash
# 산출물 frontmatter 검증 스크립트
python3 - <<'EOF'
import yaml, sys, pathlib

REQUIRED = ['artifact_type', 'produced_by', 'consumed_by', 'constraints', 'explicit_ambiguities']
errors = []

for f in pathlib.Path('docs').rglob('*.md'):
    text = f.read_text()
    if not text.startswith('---'):
        continue
    try:
        fm = yaml.safe_load(text.split('---')[1])
        missing = [k for k in REQUIRED if k not in (fm or {})]
        if missing:
            errors.append(f"{f}: 누락 필드 {missing}")
    except Exception as e:
        errors.append(f"{f}: YAML 파싱 오류 {e}")

if errors:
    print('\n'.join(errors))
    sys.exit(1)
print("✅ 메타 필드 검증 통과")
EOF
```
