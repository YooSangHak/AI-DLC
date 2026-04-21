---
name: convention-ts
description: |
  TypeScript 코딩 컨벤션. biome·eslint·tsc·Snyk 규칙·실행 명령.
  TypeScript 리포에서 agent-dev·agent-qa가 자동 참조.
  "/convention-ts", "TS 컨벤션", "lint 실행" 요청 시 트리거.
allowed-tools: Bash(pnpm *) Bash(npx *)
---

# 🟦 convention-ts

## 목적
TypeScript 코드가 부서 품질 기준(biome·tsc·Snyk)을 충족하도록 강제한다.

## When to use
- TypeScript 리포에서 코드 작성·수정 시 (자동 참조)
- 커밋 전 lint 실행 시

## 도구 및 실행 명령

### biome (린트·포맷 통합)
```bash
pnpm biome check src/           # 린트 + 포맷 확인
pnpm biome check src/ --write   # 자동 수정
```
설정: `biome.json`

### tsc (타입 체크)
```bash
pnpm tsc --noEmit
```
설정: `tsconfig.json` — `strict: true` 필수

### Vitest (테스트)
```bash
pnpm vitest run          # 전체 실행
pnpm vitest run --coverage  # 커버리지 포함
```

### Snyk (의존성 취약점)
```bash
snyk test
```
신규 의존성 추가 시 반드시 실행 (AI Usage Rule 2)

## 코딩 스타일 규칙
- `strict: true` — 모든 strict 옵션 활성화
- `any` 타입 사용 금지 (`unknown` 또는 제네릭 사용)
- `null` 대신 `undefined` 선호 (명시적 null 체크 필요 시 제외)
- 함수 반환 타입 명시 (추론 가능해도 public API는 명시)
- `interface` 선호 (`type`은 유니온·교차 타입에만)

## 자동 실행 순서
1. `biome check --write` → 자동 수정
2. `tsc --noEmit` → 타입 오류 수동 수정
3. `vitest run` → 테스트 통과 확인
