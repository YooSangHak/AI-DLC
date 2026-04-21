"""AGENTOPS-S002: TTL 생애주기 — AC-6 검증."""
from __future__ import annotations

from datetime import UTC, datetime, timedelta

import pytest

from src.temp_rag.lifecycle import TtlLifecycleManager
from src.temp_rag.models import EmbeddingProfile, RagStatus, TempRagInstance


def make_instance(expires_in: timedelta) -> TempRagInstance:
    now = datetime.now(UTC)
    return TempRagInstance(
        tenant_id="t1",
        session_id="s1",
        schema_name="rag_temp_t1_s1",
        status=RagStatus.READY,
        ttl_hours=24,
        doc_count=1,
        pii_masked=False,
        created_at=now.isoformat(),
        expires_at=(now + expires_in).isoformat(),
        embedding_profile=EmbeddingProfile.ANTHROPIC_API,
    )


@pytest.fixture
def manager() -> TtlLifecycleManager:
    return TtlLifecycleManager()


# AC-6: 만료 2시간 전 → 경고 감지
def test_expiring_soon_within_2h(manager: TtlLifecycleManager) -> None:
    instance = make_instance(timedelta(hours=1, minutes=59))
    assert manager.is_expiring_soon(instance) is True


# AC-6: 2시간 이상 남은 경우 → 경고 없음
def test_not_expiring_soon_outside_2h(manager: TtlLifecycleManager) -> None:
    instance = make_instance(timedelta(hours=3))
    assert manager.is_expiring_soon(instance) is False


# 만료된 인스턴스 감지
def test_is_expired(manager: TtlLifecycleManager) -> None:
    instance = make_instance(timedelta(seconds=-1))
    assert manager.is_expired(instance) is True


# 아직 만료되지 않은 인스턴스
def test_is_not_expired(manager: TtlLifecycleManager) -> None:
    instance = make_instance(timedelta(hours=1))
    assert manager.is_expired(instance) is False


# AC-6: 경고 메시지 내용
def test_expiry_warning_message(manager: TtlLifecycleManager) -> None:
    instance = make_instance(timedelta(hours=1))
    msg = manager.expiry_warning_message(instance)
    assert "2시간" in msg
    assert "만료" in msg
