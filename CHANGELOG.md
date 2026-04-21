# Changelog

## [Unreleased]

### Added
- Temp RAG 파이프라인 도메인 모델 (`src/temp_rag/`) — ADR-005 준수 (Refs: AGENTOPS-S002)
  - `TempRagPipeline.create()`: 문서 업로드 → pgvector 격리 스키마 자동 구성, TTL 24h 기본
  - `TtlLifecycleManager`: TTL 만료 감지 및 2시간 전 Forward UX 알림
  - 데이터 주권 옵션: `data_sovereignty=True` 시 bge-m3 온프레 임베딩 강제
  - PII 문서 마스킹 플래그 자동 감지
  - ADR-003 Audit Sink 연동: `action=temp_rag_created` 이벤트 기록
