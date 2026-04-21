---
id: PT-06-TEST-ADD-v1
purpose: 구현 코드 기반 테스트 코드 생성
subagent: agent-qa
model_hint: Sonnet 4.6
inputs:
  - 구현 코드 (src/<module>/<feature>.py 또는 .ts)
  - Story AC 목록
outputs:
  - tests/<module>/test_<feature>.py 또는 .test.ts
hitl_gate: L1
automation_tier: high
---

# PT-06 — 테스트 코드 생성

## 목적
구현 코드와 Story AC를 기반으로 단위·경계면 테스트를 생성한다.

## 전제 조건
- 구현 코드 존재 (`src/` 하위)
- Story AC 목록 확인

## 입력
```
구현 파일: {src_path}
Story AC: {ac_list}
스택: {stack}  # python | typescript | java
```

## 작업 지시
1. 구현 코드를 읽고 public 인터페이스·함수·클래스를 파악한다
2. Story AC 각 항목에 대응하는 테스트 케이스를 설계한다
3. 경계값·null·빈 입력·오류 케이스를 추가한다
4. 스택에 맞는 테스트 프레임워크를 사용한다:
   - Python: pytest + pytest-cov
   - TypeScript: Vitest
   - Java: JUnit 5 + Mockito
5. 테스트 명칭은 `test_<상황>_<기대결과>` 패턴으로 작성한다
6. Mock은 외부 의존성(DB·API·파일시스템)에만 사용한다

## 출력 형식
```python
# Python 예시
import pytest
from <module>.<feature> import <TargetClass>

class Test<FeatureName>:
    def test_<상황>_<기대결과>(self):
        # Arrange
        ...
        # Act
        ...
        # Assert
        ...
```

## 제약
- AC 미충족 케이스는 반드시 포함
- 내부 구현 detail에 의존하는 테스트 금지 (인터페이스 기반)
- 테스트 커버리지 목표: 핵심 로직 80% 이상

## 이벤트
```yaml
event_type: aidd_test_event
prompt_template_id: PT-06-TEST-ADD-v1
sdlc_stage: test
```
