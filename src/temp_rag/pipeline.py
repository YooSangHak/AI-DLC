"""AGENTOPS-S002: Temp RAG 파이프라인 — ADR-005 준수."""
from __future__ import annotations

from datetime import UTC, datetime, timedelta

from src.audit.sink import AuditEvent, AuditSink
from src.temp_rag.models import DocumentMetadata, EmbeddingProfile, RagStatus, TempRagInstance

_MAX_TTL_HOURS = 72
_DEFAULT_TTL_HOURS = 24
_MAX_FILE_BYTES = 50 * 1024 * 1024  # 50MB (AC-1)


class TempRagPipeline:
    def __init__(self, audit_sink: AuditSink | None = None) -> None:
        self._audit_sink = audit_sink or AuditSink()

    def create(
        self,
        tenant_id: str,
        session_id: str,
        documents: list[DocumentMetadata],
        *,
        embedding_profile: EmbeddingProfile = EmbeddingProfile.ANTHROPIC_API,
        ttl_hours: int = _DEFAULT_TTL_HOURS,
        data_sovereignty: bool = False,
    ) -> TempRagInstance:
        if ttl_hours > _MAX_TTL_HOURS:
            raise ValueError(f"ttl_hours {ttl_hours} exceeds max {_MAX_TTL_HOURS}")

        for doc in documents:
            if doc.size_bytes > _MAX_FILE_BYTES:
                raise ValueError(f"{doc.filename} exceeds 50MB limit")

        # AC-3: 데이터 주권 활성화 시 온프레 모델 강제
        if data_sovereignty:
            embedding_profile = EmbeddingProfile.BGE_M3_ONPREM

        # AC-4: PII 포함 문서 감지
        pii_masked = any(doc.pii for doc in documents)

        schema_name = f"rag_temp_{tenant_id}_{session_id}"
        now = datetime.now(UTC)
        instance = TempRagInstance(
            tenant_id=tenant_id,
            session_id=session_id,
            schema_name=schema_name,
            status=RagStatus.READY,
            ttl_hours=ttl_hours,
            doc_count=len(documents),
            pii_masked=pii_masked,
            created_at=now.isoformat(),
            expires_at=(now + timedelta(hours=ttl_hours)).isoformat(),
            embedding_profile=embedding_profile,
        )

        # AC-5: ADR-003 Audit Sink 기록
        self._audit_sink.record(
            AuditEvent(
                env="temp_rag",
                action="temp_rag_created",
                tenant_id=tenant_id,
                payload_digest=f"ttl_hours={ttl_hours},doc_count={len(documents)}",
            )
        )
        return instance
