---
name: deploy-procedure
description: |
  배포 절차. GitHub Actions + Helm/ArgoCD canary 배포 단계별 가이드.
  "/deploy-procedure", "배포 절차", "릴리즈", "canary 배포" 요청 시 트리거.
  agent-deployer가 배포 시 참조. 수동 호출도 가능.
allowed-tools: Bash(gh *) Bash(helm *) Bash(git *)
---

# 🚀 deploy-procedure

## 목적
Merge 후 canary → production 배포를 안전하게 수행하는 절차를 제공한다.

## When to use
- PR merge 후 배포 시 (agent-deployer)
- 핫픽스 긴급 배포 시
- 수동 배포 트리거 시

## 배포 단계

### 1. 사전 확인 (HITL L2)
```bash
# 현재 프로덕션 상태 확인
gh run list --workflow=ci.yml --limit=5
# 최신 main 빌드 통과 여부 확인
```
- [ ] CI 전체 통과 확인
- [ ] 릴리즈 노트 작성 완료
- [ ] 담당자 배포 승인

### 2. 빌드 + 서명 + SBOM
```bash
# GitHub Actions 자동 실행 (merge 시 트리거)
gh workflow run build-deploy.yml --ref main
```
- 컨테이너 이미지 빌드
- Sigstore 서명
- SBOM 생성·첨부

### 3. Canary 배포 (10% 트래픽)
```bash
helm upgrade <release> <chart> \
  --set image.tag=<version> \
  --set canary.weight=10
```
- 10분 모니터링
- 오류율·레이턴시 기준값 초과 시 자동 롤백

### 4. 프로덕션 배포 (HITL L3)
```bash
# ArgoCD 동기화
argocd app sync <app-name>
```
- **2인+SRE 승인 필수**
- 트래픽 100% 전환
- CHANGELOG.md·GitHub Release 생성

### 5. 배포 후 확인
```bash
# 헬스체크
curl https://<service>/health
# 핵심 메트릭 확인 (mcp-observability 또는 수동)
```

## 롤백
```bash
helm rollback <release> <revision>
# 또는 ArgoCD에서 이전 revision으로 동기화
```

## HITL
- L2: 배포 시작 전 담당자 승인
- L3: 프로덕션 트래픽 100% 전환 시 2인+SRE 승인
