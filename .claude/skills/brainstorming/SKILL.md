---
name: brainstorming
description: |
  아이디어 발산 Skill. 다양한 브레인스토밍 기법으로 창의적 해결책을 도출.
  "/brainstorming", "아이디어 발산", "브레인스토밍", "해결책 탐색" 요청 시 트리거.
  6월+ Forward Mode 대화 Agent 생성 시 활용 예정. 현재는 수동 호출.
allowed-tools: Read Write
---

# 💡 brainstorming

## 목적
문제에 대한 다양한 해결책을 발산적으로 탐색하고 수렴하여 최선의 접근을 선택한다.

## When to use
- 새 기능·시스템 설계 초기
- 기술 부채 해소 방법 탐색
- 아키텍처 대안 검토 전

## Steps
1. 문제를 명확히 정의한다 (1~2문장)
2. `references/brain-methods.md`에서 적합한 기법을 선택한다
3. 선택한 기법으로 아이디어를 발산한다 (판단 금지)
4. 아이디어를 그룹화·우선순위화한다
5. 상위 3개 아이디어를 ADR 대안으로 전환한다

## 기본 기법 (빠른 시작)

### How Might We (HMW)
"우리는 어떻게 {문제}를 {해결}할 수 있을까?"
- 10개 이상 HMW 질문 생성
- 가장 흥미로운 3개 선택

### 6 Thinking Hats (요약)
| 모자 | 관점 |
|---|---|
| 흰색 | 사실·데이터 |
| 빨간색 | 감정·직관 |
| 검은색 | 위험·비판 |
| 노란색 | 낙관·장점 |
| 초록색 | 창의·대안 |
| 파란색 | 프로세스·정리 |

## References
- `references/brain-methods.md`
