"""AGENTOPS-S002: Temp RAG 파이프라인 — AC-1~5 검증."""
from __future__ import annotations

from unittest.mock import MagicMock

import pytest

from src.audit.sink import AuditEvent, AuditSink
from src.temp_rag.models import DocumentMetadata, EmbeddingProfile, RagStatus
from src.temp_rag.pipeline import TempRagPipeline


@pytest.fixture
def audit_sink() -> MagicMock:
    return MagicMock(spec=AuditSink)


@pytest.fixture
def pipeline(audit_sink: MagicMock) -> TempRagPipeline:
    return TempRagPipeline(audit_sink=audit_sink)


@pytest.fixture
def doc() -> DocumentMetadata:
    return DocumentMetadata(filename="report.pdf", size_bytes=1024 * 1024)


# AC-1: 업로드 완료 → READY 상태
def test_create_returns_ready_status(pipeline: TempRagPipeline, doc: DocumentMetadata) -> None:
    instance = pipeline.create("t1", "s1", [doc])
    assert instance.status == RagStatus.READY


# AC-1: doc_count 기록
def test_doc_count_recorded(pipeline: TempRagPipeline) -> None:
    docs = [
        DocumentMetadata(filename="a.pdf", size_bytes=100),
        DocumentMetadata(filename="b.txt", size_bytes=200),
    ]
    instance = pipeline.create("t1", "s1", docs)
    assert instance.doc_count == 2


# AC-2: 스키마 격리 이름
def test_schema_name_format(pipeline: TempRagPipeline, doc: DocumentMetadata) -> None:
    instance = pipeline.create("tenant_abc", "sess_xyz", [doc])
    assert instance.schema_name == "rag_temp_tenant_abc_sess_xyz"


# AC-2: TTL 기본 24시간
def test_default_ttl_is_24h(pipeline: TempRagPipeline, doc: DocumentMetadata) -> None:
    instance = pipeline.create("t1", "s1", [doc])
    assert instance.ttl_hours == 24


# AC-2: TTL 최대 72시간 초과 시 예외
def test_ttl_exceeds_max_raises(pipeline: TempRagPipeline, doc: DocumentMetadata) -> None:
    with pytest.raises(ValueError, match="ttl_hours"):
        pipeline.create("t1", "s1", [doc], ttl_hours=73)


# AC-3: 데이터 주권 → bge-m3 온프레
def test_data_sovereignty_forces_bge_m3(pipeline: TempRagPipeline, doc: DocumentMetadata) -> None:
    instance = pipeline.create("t1", "s1", [doc], data_sovereignty=True)
    assert instance.embedding_profile == EmbeddingProfile.BGE_M3_ONPREM


# AC-3: 주권 미설정 → 기본 Anthropic API
def test_default_embedding_profile_is_anthropic(
    pipeline: TempRagPipeline, doc: DocumentMetadata
) -> None:
    instance = pipeline.create("t1", "s1", [doc])
    assert instance.embedding_profile == EmbeddingProfile.ANTHROPIC_API


# AC-4: PII 문서 → pii_masked=True
def test_pii_document_is_masked(pipeline: TempRagPipeline) -> None:
    pii_doc = DocumentMetadata(filename="hr.xlsx", size_bytes=500, pii=True)
    instance = pipeline.create("t1", "s1", [pii_doc])
    assert instance.pii_masked is True


# AC-4: PII 없는 문서 → pii_masked=False
def test_non_pii_document_not_masked(pipeline: TempRagPipeline, doc: DocumentMetadata) -> None:
    instance = pipeline.create("t1", "s1", [doc])
    assert instance.pii_masked is False


# AC-5: Audit 이벤트 기록
def test_audit_event_recorded_on_create(
    pipeline: TempRagPipeline, audit_sink: MagicMock, doc: DocumentMetadata
) -> None:
    pipeline.create("t1", "s1", [doc])
    audit_sink.record.assert_called_once()
    event: AuditEvent = audit_sink.record.call_args[0][0]
    assert event.action == "temp_rag_created"
    assert "ttl_hours=24" in (event.payload_digest or "")
    assert "doc_count=1" in (event.payload_digest or "")


# 파일 크기 50MB 초과 시 예외
def test_file_exceeds_50mb_raises(pipeline: TempRagPipeline) -> None:
    big_doc = DocumentMetadata(filename="huge.pdf", size_bytes=51 * 1024 * 1024)
    with pytest.raises(ValueError, match="50MB"):
        pipeline.create("t1", "s1", [big_doc])


# prod_* 스키마 직접 write 금지 (ADR-005)
def test_schema_name_never_starts_with_prod(
    pipeline: TempRagPipeline, doc: DocumentMetadata
) -> None:
    instance = pipeline.create("t1", "s1", [doc])
    assert not instance.schema_name.startswith("prod_")


# 경계값: TTL 최댓값 72시간 정확히 허용
def test_ttl_exactly_72h_allowed(pipeline: TempRagPipeline, doc: DocumentMetadata) -> None:
    instance = pipeline.create("t1", "s1", [doc], ttl_hours=72)
    assert instance.ttl_hours == 72


# 경계값: TTL 최솟값 1시간
def test_ttl_minimum_1h(pipeline: TempRagPipeline, doc: DocumentMetadata) -> None:
    instance = pipeline.create("t1", "s1", [doc], ttl_hours=1)
    assert instance.ttl_hours == 1


# 경계값: 파일 크기 정확히 50MB 허용
def test_file_exactly_50mb_allowed(pipeline: TempRagPipeline) -> None:
    doc = DocumentMetadata(filename="limit.pdf", size_bytes=50 * 1024 * 1024)
    instance = pipeline.create("t1", "s1", [doc])
    assert instance.status == RagStatus.READY


# 빈 문서 목록 → doc_count=0
def test_empty_document_list(pipeline: TempRagPipeline) -> None:
    instance = pipeline.create("t1", "s1", [])
    assert instance.doc_count == 0
    assert instance.pii_masked is False


# 혼합 문서: PII 포함 1개 + 일반 2개 → pii_masked=True
def test_mixed_docs_any_pii_triggers_mask(pipeline: TempRagPipeline) -> None:
    docs = [
        DocumentMetadata(filename="safe.txt", size_bytes=100),
        DocumentMetadata(filename="personal.docx", size_bytes=200, pii=True),
        DocumentMetadata(filename="report.pdf", size_bytes=300),
    ]
    instance = pipeline.create("t1", "s1", docs)
    assert instance.pii_masked is True


# audit 이벤트에 tenant_id 포함
def test_audit_event_contains_tenant_id(
    pipeline: TempRagPipeline, audit_sink: MagicMock, doc: DocumentMetadata
) -> None:
    pipeline.create("tenant_xyz", "s1", [doc])
    event: AuditEvent = audit_sink.record.call_args[0][0]
    assert event.tenant_id == "tenant_xyz"
