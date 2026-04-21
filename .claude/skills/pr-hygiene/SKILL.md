---
name: pr-hygiene
description: |
  PR·커밋 위생 점검. Conventional Commits·브랜치명·PR 제목 표준 검증.
  "/pr-hygiene", "PR 점검", "커밋 메시지 확인", "브랜치명 확인" 요청 시 트리거.
  PR 생성 전 자동 실행 권장 — 일관된 이력이 추후 rework_reason 분석을 가능하게 함.
allowed-tools: Read Bash(git *)
---

# 🧹 pr-hygiene

## 목적
PR·커밋이 팀 표준(Conventional Commits·브랜치명·PR 제목)을 준수하는지 점검한다.

## When to use
- PR 생성 전 self-check (workflow-dev-story step-05)
- 커밋 메시지 작성 시 참고

## Steps
1. 브랜치명 표준 확인
2. 커밋 메시지 Conventional Commits 준수 확인
3. PR 제목·본문 형식 확인
4. 위반 사항 수정 제안

## 브랜치명 표준
```
feature/<ticket>-<slug>   # 기능
fix/<ticket>-<slug>       # 버그 수정
refactor/<ticket>-<slug>  # 리팩터링
hotfix/<ticket>-<slug>    # 핫픽스
```

## Conventional Commits 형식
```
<type>(<scope>): <subject>

<body>  # 선택

<footer>  # Refs: <ticket>
```

**type**: `feat` · `fix` · `refactor` · `test` · `docs` · `chore` · `perf`

**규칙**:
- subject: 50자 이내, 현재형, 마침표 없음
- body: 72자 줄바꿈, WHY 설명
- footer: `Refs: JIRA-123` 또는 `Closes #456`

## PR 제목 형식
```
<type>(<scope>): <기능 요약>
```
예: `feat(auth): add JWT login endpoint`

## Checklist
- [ ] 브랜치명 표준 준수
- [ ] 커밋 메시지 Conventional Commits 형식
- [ ] PR 제목 50자 이내
- [ ] `Refs: <ticket>` footer 포함
- [ ] WIP·Draft PR은 제목에 `[WIP]` 명시

## References
- `references/commit-message-style.md`
