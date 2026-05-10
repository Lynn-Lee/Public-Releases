# SchemaForge 商业版 0.1.0-dev.4.1f58a50

这是 SchemaForge 商业版客户部署包，只包含生产部署配置、版本化商业镜像引用、Helm Chart 和发布完整性清单，不包含 SchemaForge 源码。

## 镜像

- API / Worker: `ghcr.io/lynn-lee/schemaforge-api:0.1.0-dev.4.1f58a50`
- Web: `ghcr.io/lynn-lee/schemaforge-web:0.1.0-dev.4.1f58a50`

## Docker Compose 部署

```bash
cp .env.example .env
# 编辑 .env，替换所有 change-me 值，并填写 License / 域名配置。
docker compose pull
docker compose up -d postgres redis
docker compose run --rm api schemaforge-runtime migrate
docker compose up -d
docker compose ps
```

## Kubernetes / Helm 部署

```bash
tar -xzf schemaforge-helm-chart.tgz
helm upgrade --install schemaforge ./schemaforge \
  --set config.jwtSecret='<change-me>' \
  --set config.secretEncryptionKey='<change-me>' \
  --set config.licensePublicKey='<license-public-key>' \
  --set config.releaseManifestPublicKey='<release-manifest-public-key>'
```

## License 授权

首次部署前请准备 License-Server-Center 配置或离线 license 文件。共享日志或配置时，不要打包 license、私钥、激活码或 .env 中的敏感值。
