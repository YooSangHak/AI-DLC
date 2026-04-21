---
artifact_type: governance-policy
story: AIDD-S048
produced_by: agent-architect
consumed_by: [all-agents, all-scripts, agent-janitor, self-healing]
version: 1.0
date: 2026-04-21
---

# 출력 정책 — 조용한 성공 · 시끄러운 실패 (ADR-020)

> OpenAI 기둥2 보조. 노이즈를 줄여 진짜 문제에 집중.

---

## 핵심 원칙

| 상황 | 출력 | 채널 |
|---|---|---|
| **성공** | 1줄 이내 (또는 무출력) | stdout |
| **경고** | stderr, 1~3줄 | stderr |
| **실패** | 원인·위치·수정 제안 3요소 필수 | stderr + 알림 |

---

## 성공 출력 형식

```bash
# 최소 (권장)
✅ {작업명} 완료

# 또는 무출력 (완전 조용)
exit 0
```

**금지:**
- 성공 시 여러 줄 로그
- "처리 중...", "완료!", "모든 작업이 성공적으로..." 등 장황한 메시지

---

## 실패 출력 형식 (3요소 필수)

```
❌ {작업명} 실패

원인: {구체적 오류 원인}
위치: {파일}:{라인} 또는 {단계}/{컴포넌트}
수정 제안:
  1. {가장 가능성 높은 수정 방법}
  2. {대안 수정 방법}
```

**예시:**
```
❌ [FR-8.3] diff 크기 초과

원인: staged diff 342 LOC > 300 LOC 한도
위치: git diff --cached (src/auth/login.py +280, tests/auth/test_login.py +62)
수정 제안:
  1. 구현(src/)과 테스트(tests/)를 별도 커밋으로 분리
  2. 기능을 AC 단위로 나눠 커밋
```

---

## 경고 출력 형식

```
⚠️  {경고 내용} — {이유}
```

경고는 작업을 차단하지 않고 stderr로만 출력.

---

## 적용 대상별 규칙

### Claude Code Hooks (pre-prompt.sh, pre-tool.sh, post-tool.sh)
```bash
# 성공
exit 0  # 또는 echo "✅ 검사 통과"

# 실패
echo "❌ [FR-8.X] {원인}" >&2
echo "   위치: {상세}" >&2
echo "   수정: {제안}" >&2
exit 1
```

### GitHub Actions Steps
```yaml
# 성공: run 블록 마지막 줄만
- run: |
    ... (처리)
    echo "✅ 완료"

# 실패: 원인+위치+수정 제안
- run: |
    if [[ $RESULT != "ok" ]]; then
      echo "❌ 원인: ..." >&2
      echo "   위치: ..." >&2
      exit 1
    fi
```

### agent-janitor 리포트
- 위반 없음: 슬랙 1줄 `✅ [janitor] 주간 감사 완료 — 위반 0건`
- 위반 있음: GitHub Issue 생성 (상세 내용 포함)

### self-healing Skill
- 성공: `✅ self-healing 완료 (N회 시도)` 1줄
- 3회 실패: 원인·위치·수정 제안 전체 출력

---

## 색상·이모지 가이드

| 이모지 | 의미 | 사용 시점 |
|---|---|---|
| ✅ | 성공 | 성공 확인 |
| ❌ | 실패·차단 | 즉시 중단 필요 |
| ⚠️ | 경고 | 주의 필요, 차단 안 함 |
| 🛑 | Kill-switch | 세션/프로세스 강제 종료 |
| ℹ️ | 정보 | 참고 사항 |

---

## CI/스크립트 작성자 준수 사항

모든 Hook·CI 스크립트 작성 시:
1. 성공 경로: `exit 0` 또는 최대 1줄 출력
2. 실패 경로: 원인·위치·수정 제안 3요소 → `exit 1`
3. 경고: `>&2` 리다이렉트
4. 중간 처리 로그: `set +x` 또는 억제 (CI debug 모드 제외)
