#!/usr/bin/env python3
"""FR-8.7: 세션 누적 비용(USD) 추정.

Claude Code 훅 페이로드에는 비용 필드가 없고 transcript(JSONL)에 토큰 사용량만
기록된다. 이 스크립트가 transcript를 읽어 모델별 단가로 USD를 추정한다.

사용법:  session-cost.py <transcript_path>
출력:    추정 비용 (소수점 6자리). 계산 불가 시 0.

주의: 단가는 2026-07 기준 Anthropic 1st-party API 요금이다. 요금 개정 시
      PRICING 테이블을 갱신해야 한다. 가드용이므로 과소평가보다 과대평가가
      안전하며, Sonnet 5 도입 할인가($2/$10, ~2026-08-31)는 반영하지 않는다.
"""

import json
import sys

# (input $/MTok, output $/MTok) — 접두사 매칭, 긴 것 우선
PRICING = [
    ("claude-fable-5", (10.00, 50.00)),
    ("claude-mythos-5", (10.00, 50.00)),
    ("claude-opus-5", (5.00, 25.00)),
    ("claude-opus-4", (5.00, 25.00)),
    ("claude-sonnet-5", (3.00, 15.00)),
    ("claude-sonnet-4", (3.00, 15.00)),
    ("claude-haiku-4", (1.00, 5.00)),
]
FALLBACK = (5.00, 25.00)  # 미상 모델은 Opus 단가로 보수적 추정

CACHE_READ_MULT = 0.10   # 캐시 읽기 = 입력 단가의 0.1배
CACHE_WRITE_5M = 1.25    # 5분 TTL 캐시 쓰기 = 1.25배
CACHE_WRITE_1H = 2.00    # 1시간 TTL 캐시 쓰기 = 2.0배


def rates(model: str) -> tuple[float, float]:
    for prefix, price in PRICING:
        if model.startswith(prefix):
            return price
    return FALLBACK


def main() -> int:
    if len(sys.argv) < 2:
        print("0")
        return 0

    # message.id 중복 제거 — 같은 응답이 여러 줄에 기록되므로
    # id별로 output_tokens가 가장 큰(=가장 완성된) 항목만 채택한다.
    best: dict[str, tuple[int, str, dict]] = {}

    try:
        with open(sys.argv[1], encoding="utf-8") as f:
            for line in f:
                try:
                    rec = json.loads(line)
                except (ValueError, TypeError):
                    continue
                msg = rec.get("message")
                if not isinstance(msg, dict):
                    continue
                usage = msg.get("usage")
                if not isinstance(usage, dict):
                    continue
                msg_id = msg.get("id") or rec.get("uuid")
                if not msg_id:
                    continue
                out = usage.get("output_tokens") or 0
                prev = best.get(msg_id)
                if prev is None or out > prev[0]:
                    best[msg_id] = (out, msg.get("model") or "", usage)
    except OSError:
        print("0")
        return 0

    total = 0.0
    for _, model, usage in best.values():
        in_rate, out_rate = rates(model)
        cache = usage.get("cache_creation")
        if isinstance(cache, dict):
            write_5m = cache.get("ephemeral_5m_input_tokens") or 0
            write_1h = cache.get("ephemeral_1h_input_tokens") or 0
        else:
            # cache_creation 세부 필드가 없으면 전량 5분 TTL로 간주
            write_5m = usage.get("cache_creation_input_tokens") or 0
            write_1h = 0

        total += (
            (usage.get("input_tokens") or 0) * in_rate
            + (usage.get("output_tokens") or 0) * out_rate
            + (usage.get("cache_read_input_tokens") or 0) * in_rate * CACHE_READ_MULT
            + write_5m * in_rate * CACHE_WRITE_5M
            + write_1h * in_rate * CACHE_WRITE_1H
        ) / 1_000_000

    print(f"{total:.6f}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
