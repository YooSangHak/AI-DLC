# OWASP LLM Top 10 (2025) — 점검 가이드

## LLM01: Prompt Injection
**위험**: 악의적 입력으로 AI 지시 무력화
**점검**: 사용자 입력을 프롬프트에 직접 삽입하는 코드 확인
**대응**: 입력 검증·샌드박싱·권한 최소화

## LLM02: Insecure Output Handling
**위험**: AI 출력을 검증 없이 실행 (XSS·SQLi·RCE)
**점검**: `eval()`, `exec()`, DB 쿼리에 AI 출력 직접 사용 여부
**대응**: 출력 이스케이프·파라미터화 쿼리

## LLM03: Training Data Poisoning
**위험**: 학습 데이터 오염으로 모델 편향
**점검**: 외부 데이터 소스 신뢰성 검증 로직
**대응**: 데이터 출처 검증·이상 탐지

## LLM04: Model Denial of Service
**위험**: 과도한 리소스 소비로 서비스 중단
**점검**: 무제한 토큰·재귀 호출 가능성
**대응**: 토큰 상한·Rate Limiting·비용 Kill-switch (FR-8.7)

## LLM05: Supply Chain Vulnerabilities
**위험**: 서드파티 모델·플러그인 취약점
**점검**: 외부 모델·API 의존성 목록
**대응**: 공급망 체크 (AI Usage Rule 2)

## LLM06: Sensitive Information Disclosure
**위험**: 학습 데이터·시스템 프롬프트 노출
**점검**: 비밀·PII를 프롬프트에 포함하는 코드
**대응**: 비밀 마스킹·최소 권한 (AI Usage Rule 3)

## LLM07: Insecure Plugin Design
**위험**: 플러그인·도구 과도한 권한
**점검**: MCP 도구 `allowed-tools` 설정
**대응**: 도구 경계 최소화 (FR-9)

## LLM08: Excessive Agency
**위험**: AI가 과도한 행동 자율 실행
**점검**: HITL 없는 파괴적 작업 자동화
**대응**: HITL L2·L3 게이트 (AI Usage Rule 4)

## LLM09: Overreliance
**위험**: AI 출력 맹신으로 검증 생략
**점검**: AI 산출물 사람 검토 프로세스 존재 여부
**대응**: HITL 매트릭스 준수

## LLM10: Model Theft
**위험**: 시스템 프롬프트·파인튜닝 데이터 추출
**점검**: 시스템 프롬프트 외부 노출 가능성
**대응**: 프롬프트 기밀 분류·접근 제어
