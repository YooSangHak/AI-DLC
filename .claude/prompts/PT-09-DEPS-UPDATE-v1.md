---
id: PT-09-DEPS-UPDATE-v1
purpose: 의존성 업데이트 분석 및 안전한 업그레이드 제안
subagent: 공통
model_hint: Sonnet 4.6
inputs:
  - 의존성 파일 (pyproject.toml | package.json | build.gradle)
  - lockfile (uv.lock | pnpm-lock.yaml)
outputs:
  - 업데이트 제안 리포트 (docs/decisions/deps-update-<date>.md)
hitl_gate: L2
automation_tier: medium
---

# PT-09 — 의존성 업데이트 분석

## 목적
의존성 lockfile을 분석하여 보안 취약점·outdated 패키지를 식별하고
안전한 업그레이드 순서를 제안한다.

## 전제 조건
- 의존성 파일·lockfile 존재
- 스택 확인 (Python | TypeScript | Java)

## 입력
```
스택: {stack}
의존성 파일: {deps_path}
lockfile: {lockfile_path}
```

## 작업 지시
1. 의존성 파일을 읽고 직접·간접 의존성 목록을 파악한다
2. 각 패키지의 최신 버전을 확인한다
3. 보안 취약점(CVE) 여부를 확인한다 (Snyk 또는 공개 DB 기준)
4. Breaking change 위험도를 평가한다 (major·minor·patch)
5. 업데이트 우선순위를 결정한다:
   - P0: 보안 취약점 (CVE)
   - P1: minor 업데이트 (하위 호환)
   - P2: major 업데이트 (Breaking change 검토 필요)
6. 업데이트 명령어를 스택별로 제안한다
7. 공급망 체크 결과를 포함한다 (AI Usage Rule 2)

## 출력 형식
```markdown
# 의존성 업데이트 리포트 — {date}

## 요약
- 총 의존성: N개 / 업데이트 필요: N개 / 보안 취약점: N개

## P0 — 보안 취약점 (즉시 업데이트)
| 패키지 | 현재 | 최신 | CVE | 업데이트 명령 |
|---|---|---|---|---|

## P1 — Minor 업데이트 (권장)
| 패키지 | 현재 | 최신 | 변경사항 |
|---|---|---|---|

## P2 — Major 업데이트 (검토 필요)
| 패키지 | 현재 | 최신 | Breaking Change |
|---|---|---|---|

## 업데이트 순서
1. <!-- P0 먼저, 테스트 통과 확인 후 P1 -->
```

## 제약
- Major 업데이트는 HITL L2 승인 필수
- 업데이트 후 전체 테스트 스위트 실행 필수
- 신규 의존성 추가 시 공급망 체크 (AI Usage Rule 2)

## 이벤트
```yaml
event_type: aidd_interaction_event
prompt_template_id: PT-09-DEPS-UPDATE-v1
sdlc_stage: maintenance
```
