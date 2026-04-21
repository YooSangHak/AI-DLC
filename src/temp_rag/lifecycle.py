"""AGENTOPS-S002: TTL 기반 생애주기 관리 — AC-6."""
from __future__ import annotations

from datetime import UTC, datetime, timedelta

from src.temp_rag.models import TempRagInstance

_WARNING_THRESHOLD_HOURS = 2


class TtlLifecycleManager:
    def is_expiring_soon(self, instance: TempRagInstance) -> bool:
        expires_at = datetime.fromisoformat(instance.expires_at)
        return expires_at <= datetime.now(UTC) + timedelta(hours=_WARNING_THRESHOLD_HOURS)

    def is_expired(self, instance: TempRagInstance) -> bool:
        expires_at = datetime.fromisoformat(instance.expires_at)
        return expires_at <= datetime.now(UTC)

    def expiry_warning_message(self, instance: TempRagInstance) -> str:
        return "지식 환경이 2시간 후 만료됩니다"
