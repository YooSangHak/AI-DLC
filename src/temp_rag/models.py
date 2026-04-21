from __future__ import annotations

from dataclasses import dataclass
from enum import StrEnum


class RagStatus(StrEnum):
    INITIALIZING = "initializing"
    READY = "ready"
    EXPIRED = "expired"


class EmbeddingProfile(StrEnum):
    """AgentSpec.embedding_profile 값. 코드 내 모델명 하드코딩 금지 (ADR-005)."""

    ANTHROPIC_API = "anthropic_api"
    BGE_M3_ONPREM = "bge_m3_onprem"


@dataclass
class DocumentMetadata:
    filename: str
    size_bytes: int
    pii: bool = False


@dataclass
class TempRagInstance:
    tenant_id: str
    session_id: str
    schema_name: str
    status: RagStatus
    ttl_hours: int
    doc_count: int
    pii_masked: bool
    created_at: str
    expires_at: str
    embedding_profile: EmbeddingProfile
