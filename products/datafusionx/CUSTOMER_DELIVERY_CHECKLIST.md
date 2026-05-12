# DataFusionX Enterprise 商业交付检查清单

## 交付标识

- 版本：`0.1.0-dev.19.6c17950`
- 公开发布水印：`public-release`
- 交付批次：`0.1.0-dev.19.6c17950`
- 分发模式：`public-release`
- 后端镜像：`ghcr.io/lynn-lee/datafusionx-backend:0.1.0-dev.19.6c17950`
- 前端镜像：`ghcr.io/lynn-lee/datafusionx-frontend:0.1.0-dev.19.6c17950`

## 发布方交付前检查

- 已记录后端镜像 digest、前端镜像 digest、压缩包 sha256、release manifest 签名和公开发布批次。
- Public-Releases 是商业版公开下载和推广主通道；客户授权、激活码、部署指纹和 License 授权号由授权中心单独签发和管理，不进入公开包。
- Public-Releases 只保留公开商业部署入口和版本压缩包，不包含真实 License、客户 License、镜像 tar、私钥、Token、真实 `.env`、源码或 sourcemap。
- 后端商业镜像已确认存在 `/app/commercial/commercial-build.json`，且受保护目录未保留业务 `.py` 源码。
- 前端商业镜像只包含生产静态资源，不包含 sourcemap、源码目录或源码构建上下文。

## 客户现场部署前检查

- 已使用 `.sha256` 校验压缩包。
- 已使用 `tools/commercial-manifest.py verify-release` 校验 signed release manifest。
- 已确认 `.env` 中所有 `change-me` 值已替换，且 `LICENSE_DEPLOYMENT_ID` 会在升级和重启后保持稳定。
- 已确认 `LICENSE_PUBLIC_KEY`、`COMMERCIAL_INTEGRITY_PUBLIC_KEY` 和镜像标签与交付单一致。
- 已确认不会把 `.env`、License 文件、激活码、Token、私钥或部署指纹发送到公开工单、公开仓库或聊天群。
