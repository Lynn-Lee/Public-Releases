# Public Releases

本仓库用于发布 Lynn Lee 维护产品的商业部署包。

本仓库只包含部署文件、文档、发布包和校验和，不包含产品源码、私钥、客户 License、激活码或镜像仓库凭据。

## Products

| 产品 | 最新发布版本 | 部署入口 |
| --- | --- | --- |
| SagittaDB Enterprise | 2.0.0 | [products/sagittadb](products/sagittadb/) |

## SagittaDB Enterprise

SagittaDB Enterprise 通过公开商业部署包交付，并使用固定版本商业容器镜像：

- `ghcr.io/lynn-lee/sagittadb-backend:2.0.0`
- `ghcr.io/lynn-lee/sagittadb-frontend:2.0.0`

请从 [products/sagittadb/releases/v2.0.0](products/sagittadb/releases/v2.0.0/) 下载部署包，校验 sha256 后按包内 README 部署。

```bash
cd products/sagittadb/releases/v2.0.0
shasum -a 256 -c SagittaDB-Enterprise-v2.0.0.zip.sha256
```

首次部署自动进入 30 天全功能试用期。试用到期后业务 API 会被阻断，授权管理页仍可访问。
