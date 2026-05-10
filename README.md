# Public Releases

本仓库用于发布 Lynn Lee 维护产品的商业部署包。

本仓库只包含部署文件、文档、发布包和校验和，不包含产品源码、私钥、客户 License、激活码或镜像仓库凭据。

## DataFusionX Enterprise

DataFusionX Enterprise 通过公开商业部署包交付，并使用固定版本商业容器镜像：

- `ghcr.io/lynn-lee/datafusionx-backend:0.1.0-dev.3.727bc8c`
- `ghcr.io/lynn-lee/datafusionx-frontend:0.1.0-dev.3.727bc8c`

请从 [products/datafusionx/releases/v0.1.0-dev.3.727bc8c](products/datafusionx/releases/v0.1.0-dev.3.727bc8c/) 下载部署包，校验 sha256 后按包内 README 部署。

```bash
cd products/datafusionx/releases/v0.1.0-dev.3.727bc8c
shasum -a 256 -c DataFusionX-Enterprise-v0.1.0-dev.3.727bc8c.tar.gz.sha256
```
