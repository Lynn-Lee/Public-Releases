# StreamForge 商业版 v0.1.0-dev.13.3ec3256

这是 StreamForge 商业版客户部署包。部署包只包含私有化部署配置、校验文件和运维脚本，应用代码通过固定版本 Docker 镜像交付，不包含源码。

## 镜像

- 后端：`ghcr.io/lynn-lee/streamforge/backend-commercial:0.1.0-dev.13.3ec3256`
- 控制台：`ghcr.io/lynn-lee/streamforge/console-commercial:0.1.0-dev.13.3ec3256`

生产环境不要使用 `latest`，请保留 `.env` 中的明确版本标签。

## 首次部署

```bash
cp .env.example .env
# 编辑 .env，替换数据库密码、License 公钥、客户标识等配置。
docker compose pull
docker compose up -d
docker compose ps
```

控制台默认访问地址：`http://<server>:5174/`。

## Kubernetes / Helm 部署

```bash
helm upgrade --install streamforge ./helm \
  --set image.backend='ghcr.io/lynn-lee/streamforge/backend-commercial:0.1.0-dev.13.3ec3256' \
  --set image.console='ghcr.io/lynn-lee/streamforge/console-commercial:0.1.0-dev.13.3ec3256' \
  --set license.publicKey='<ed25519-public-key>' \
  --set postgres.password='<password>'
```

## 升级

```bash
./upgrade.sh 0.1.0-dev.13.3ec3256
```

升级脚本会更新镜像标签、拉取镜像、重建服务并检查前后端健康状态。

## License 授权

登录后进入“商业授权”页面，可在线激活，也可生成离线 Challenge 后导入 License-Server-Center 返回的签名 License。

共享日志或配置时，不要打包 License 文件、私钥、激活码或 `.env` 中的敏感值。

商业镜像需要客户授权后才能拉取。若 `docker compose pull` 返回未授权或不存在，请确认 GHCR 登录状态、镜像版本和合同授权范围。
