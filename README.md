# 公开发布

本仓库用于发布 Lynn Lee 维护产品的商业部署包。

本仓库只包含部署文件、文档、发布包和校验和，不包含产品源码、私钥、客户 License、激活码或镜像仓库凭据。

## 产品

| 产品 | 最新发布版本 | 部署入口 |
| --- | --- | --- |
| StreamForge 商业版 | 0.1.0-dev.2.2e9bb2e | [products/streamforge](products/streamforge/) |

## StreamForge 商业版

StreamForge 商业版通过公开商业部署包交付，并使用固定版本商业容器镜像：

- `ghcr.io/lynn-lee/streamforge/backend-commercial:0.1.0-dev.2.2e9bb2e`
- `ghcr.io/lynn-lee/streamforge/console-commercial:0.1.0-dev.2.2e9bb2e`

请从 [products/streamforge/releases/v0.1.0-dev.2.2e9bb2e](products/streamforge/releases/v0.1.0-dev.2.2e9bb2e/) 下载部署包，校验 sha256 后按包内 README 部署。

```bash
cd products/streamforge/releases/v0.1.0-dev.2.2e9bb2e
shasum -a 256 -c StreamForge-Commercial-v0.1.0-dev.2.2e9bb2e.zip.sha256
```

首次部署可进入试用期；正式生产请在控制台商业授权页完成在线激活或离线 Challenge-Response 激活。
