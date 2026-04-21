---
# AI Consumer Metadata
artifact_type: requirements
produced_by: agent-analyst
consumed_by: [agent-pm, agent-architect]
constraints:
  stack: [Python 3.13, TypeScript 5.6]
  hitl_gate: L2
explicit_ambiguities:
  - topic: "인증 방식 (자체 ID/PW vs SSO vs OAuth)"
    reason: "상위 ADR 부재, 티켓에 명시 없음"
  - topic: "사용자 식별자 (email vs username vs phone)"
    reason: "대상 사용자군 미정"
  - topic: "세션 관리 방식 (JWT vs 서버 세션)"
    reason: "Stateless/Stateful 정책 미정"
  - topic: "MFA 필요 여부"
    reason: "보안 등급 기준 미정"
  - topic: "비밀번호 정책 세부 기준"
    reason: "조직 보안 표준 문서 확인 필요"
upstream_refs:
  - type: conversation
    id: "2026-04-21 사용자 구두 요청"
    summary: "로그인 기능 요구사항 정리 요청"
---

# 요구사항: 로그인 기능 (AUTH-LOGIN-001)

> **결론 (Minto)**: 사용자가 식별자·비밀번호로 시스템에 인증하여 보호된 리소스에 접근할 수 있어야 한다. 다만 **인증 방식·세션 정책·MFA 범위**는 L2 결정 필요 사항으로 ADR 선행이 요구된다.

## 1. 배경
- AIDD 5계층 자산 구조 Agent 단위 검증 워크스페이스에 보호된 기능이 추가될 경우 사용자 식별·권한 분리가 필요함.
- 현 시점 `docs/requirements/`·`docs/adr/` 모두 비어 있어 인증 관련 상위 결정이 존재하지 않음.
- 본 문서는 **분석 단계 산출물**이며, 구체 기술 선택은 `agent-architect`의 ADR에 위임함.

## 2. 목적
- 사용자의 **신원 확인(Authentication)** 수단 제공
- 인가되지 않은 접근 차단으로 **기밀성·무결성** 확보
- 후속 **Authorization / 감사 로그**의 기준점 제공

## 3. 대상 사용자 (Stakeholder)
| 그룹 | 관심사 | 우선순위 |
|---|---|---|
| 일반 사용자 | 빠르고 실패 없는 로그인 UX | P0 |
| 운영자 | 계정 잠금·초기화·로그 조회 | P1 |
| 개발자 | 명확한 인증 API·에러 코드 | P0 |
| 보안 담당 | 자격증명 저장·전송 보호, 감사 추적 | P0 |

## 4. Functional Requirements

| ID | 요구 | 우선순위 | 수용 기준 (초안) |
|---|---|---|---|
| FR-1 | 사용자는 식별자·비밀번호로 로그인할 수 있다 | P0 | 정상 자격 시 200 응답 + 세션/토큰 발급 |
| FR-2 | 잘못된 자격 증명은 일반화된 에러 메시지로 거부한다 | P0 | "ID 또는 비밀번호가 올바르지 않습니다" — 사유 특정 금지 |
| FR-3 | 사용자는 로그아웃할 수 있다 | P0 | 세션/토큰 무효화, 재사용 불가 |
| FR-4 | 로그인 실패 N회 시 계정을 잠금/지연한다 | P0 | 무차별 대입 방어 (N·지연값은 미결) |
| FR-5 | 사용자는 비밀번호를 재설정할 수 있다 | P1 | 별도 플로우 — 본 요구사항 범위 경계 확인 필요 |
| FR-6 | 사용자는 "로그인 유지" 옵션을 선택할 수 있다 | P2 | 장기 토큰/refresh 정책 미결 |
| FR-7 | 시스템은 로그인 성공·실패 이벤트를 감사 로그로 남긴다 | P0 | 시각·사용자ID·IP·결과 필수 |
| FR-8 | 세션은 일정 시간 비활성 시 자동 만료된다 | P0 | Idle timeout 값 미결 |

## 5. Non-Functional Requirements

| ID | 범주 | 요구 |
|---|---|---|
| NFR-1 | 보안 | 비밀번호는 평문 저장 금지, 해시 알고리즘은 조직 보안 표준 준수 |
| NFR-2 | 보안 | 모든 인증 통신은 TLS 1.2 이상 |
| NFR-3 | 보안 | CSRF·세션 고정 공격 방어 (세션 재발급) |
| NFR-4 | 성능 | 로그인 API p95 응답시간 < 500ms (정상 경로) |
| NFR-5 | 가용성 | 인증 서비스 가용률 ≥ 99.9% |
| NFR-6 | 관측성 | 감사 로그는 1년 이상 보존 (보존 기간 최종값 미결) |
| NFR-7 | 접근성 | WCAG 2.1 AA 기준 키보드·스크린리더 대응 |
| NFR-8 | 국제화 | 에러 메시지 ko/en 최소 2개 언어 지원 |

## 6. 제약 · 가정

### 제약
- CLAUDE.md AI Usage Rules 준수 (300 LOC·PII 금지·블랙리스트 명령 2인 확인)
- Stack: Python 3.13 / TypeScript 5.6 한정
- HITL Gate: L2 — 본 문서는 사람 승인 후 하위 Agent(agent-pm, agent-architect)로 인계

### 가정
- 본 기능은 **웹 클라이언트** 대상을 1차 범위로 한다 (모바일 네이티브는 범위 외로 가정, 확인 필요)
- 외부 IdP 연동 여부는 ADR에서 결정 (현재는 가정하지 않음)
- 계정 생성(회원가입)은 본 요구사항 **범위 외**이며 별도 요구사항으로 분리

## 7. 미결 쟁점 (L2 결정 필요)

| # | 쟁점 | 결정 주체 | 영향 |
|---|---|---|---|
| O-1 | 인증 방식: 자체 ID/PW · SSO · OAuth · 혼합? | 아키텍트 + 보안 | 전체 설계 분기 |
| O-2 | 사용자 식별자: email / username / phone 중 무엇? | PM + 보안 | FR-1 수용 기준 확정 |
| O-3 | 세션 관리: JWT(Stateless) vs Server Session(Stateful)? | 아키텍트 | NFR-3·FR-8 구현 방식 |
| O-4 | MFA 적용 범위 (전체/관리자/조건부)? | 보안 | FR 추가 가능성 |
| O-5 | 계정 잠금 임계값 N·잠금 시간·잠금 해제 방식 | 보안 + 운영 | FR-4 수치 |
| O-6 | 비밀번호 정책 (길이·복잡도·만료·이력) | 보안 | NFR-1 상세 |
| O-7 | Idle timeout·절대 timeout 값 | 보안 + UX | FR-8·NFR 수치 |
| O-8 | 감사 로그 보존 기간·저장소 | 보안 + 법무 | NFR-6 |
| O-9 | 모바일 네이티브 클라이언트 포함 여부 | PM | 범위 경계 |
| O-10 | 비밀번호 재설정 플로우 본 문서 포함 여부 | PM | FR-5 분리 판단 |

## 8. 후속 작업 (Agent 인계)

| 순서 | Agent | 산출물 |
|---|---|---|
| 1 | **L2 승인** (사람) | 본 요구사항 검토·미결 쟁점 결정 |
| 2 | `agent-pm` | PRD·Epic·Story 분해, 우선순위 확정 |
| 3 | `agent-architect` | 인증 방식·세션 전략 ADR, API 설계 |
| 4 | `agent-dev` | test-first 구현 |
| 5 | `agent-qa` | 경계 조건 테스트 (실패 N회·timeout·동시 로그인 등) |

## 9. 변경 이력
| 날짜 | 변경 | 작성 | 사유 |
|---|---|---|---|
| 2026-04-21 | 초기 작성 | agent-analyst | 사용자 구두 요청 기반 초안 |
