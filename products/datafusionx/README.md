# DataFusionX Enterprise v0.1.0-dev.20.b0bd088

这是 DataFusionX Enterprise 商业部署包。部署包只包含生产部署配置、Helm Chart、环境变量模板、校验清单和固定版本商业镜像引用，不包含 DataFusionX 源码。

## 镜像

- 后端 / Worker / Beat：`ghcr.io/lynn-lee/datafusionx-backend:0.1.0-dev.20.b0bd088`
- 前端：`ghcr.io/lynn-lee/datafusionx-frontend:0.1.0-dev.20.b0bd088`
- 公开发布水印：`public-release`
- 交付批次标识：`0.1.0-dev.20.b0bd088`
- 分发模式：`public-release`

生产环境不要使用 `latest`，请保留 `.env.example` 和 Helm values 中的明确版本标签。

## Docker Compose 部署

```bash
cp .env.example .env
# 编辑 .env，替换所有 change-me 值，并填写 License 配置。
docker compose -f deploy/docker-compose.yml --env-file .env pull
docker compose -f deploy/docker-compose.yml --env-file .env up -d
docker compose -f deploy/docker-compose.yml --env-file .env ps
```

默认访问地址为 `http://localhost:8080`。

## Kubernetes / Helm 部署

```bash
helm upgrade --install datafusionx ./helm/datafusionx-commercial \
  --set global.publicUrl=https://datafusionx.example.com \
  --set secrets.postgresPassword='<数据库密码>' \
  --set secrets.jwtSecretKey='<至少 32 位 JWT 密钥>' \
  --set secrets.encryptionSecretKey='<至少 32 位加密密钥>' \
  --set secrets.licensePublicKey='<License 公钥>' \
  --set secrets.licenseDeploymentId='<稳定部署 ID>'
```

## 校验

```bash
shasum -a 256 -c DataFusionX-Enterprise-v0.1.0-dev.20.b0bd088.tar.gz.sha256
python tools/commercial-manifest.py verify-release \
  --package-dir . \
  --public-key '<商业发布验签公钥>'
```

共享日志或配置时，不要打包 License 文件、激活码、Token、私钥或 `.env` 中的敏感值。
