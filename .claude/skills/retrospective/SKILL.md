---
name: retrospective
description: |
  분기 회고 Skill. KPI 분석·잘된 것·실패·개선 액션 5섹션 템플릿.
  "/retrospective", "분기 회고", "회고 진행", "retrospective" 요청 시 트리거.
  분기 종료 시 또는 마일스톤 완료 후 실행 권장.
allowed-tools: Read Write Glob Bash(git *)
---

# 🔄 retrospective

## 목적
분기·마일스톤 단위로 AIDD 시스템 운영을 회고하고 개선 액션을 도출한다.

## When to use
- 분기 종료 시 (3개월 주기)
- 주요 마일스톤 완료 후
- 하네스 진화 트리거 (ADR-015)

## Steps
1. `template.md`를 로드하여 회고 파일을 생성한다
2. git log로 기간 내 커밋·PR 이력을 수집한다
3. 각 섹션을 작성한다
4. 개선 액션을 다음 Sprint Story로 등록한다
5. 하네스 진화 필요 사항을 CLAUDE.md에 반영한다

## 출력
- `docs/retrospective/YYYY-QN-retrospective.md`

## References
- `template.md`
- `references/feedback-categorization.md`
