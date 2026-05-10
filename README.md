# Public Releases

本仓库是 Lynn Lee 维护产品的商业部署版统一发布入口，用于向客户提供可下载的私有化部署包、部署文档、校验文件和版本归档。

本仓库不包含产品源码、构建私钥、客户 License、激活码、生产连接串、Token 或镜像仓库凭据。共享日志、工单附件或部署配置前，请先移除 `.env`、License 文件和任何客户侧密钥。

## 产品入口

| 产品 | 功能定位 | 部署入口 | 发布包 |
| --- | --- | --- | --- |
| DataFusionX Enterprise | 面向企业 IT 的轻量级数据同步控制台，提供连接管理、任务配置、Flink SQL 作业提交、状态观测、审计和 DDL Guard。 | [products/datafusionx](products/datafusionx/) | [products/datafusionx/releases](products/datafusionx/releases/) |
| SagittaDB Enterprise | 企业级数据库管理与运维平台，提供数据库资产管理、SQL 工作台、权限治理、备份运维和商业授权能力。 | [products/sagittadb](products/sagittadb/) | [products/sagittadb/releases](products/sagittadb/releases/) |
| SchemaForge 商业版 | 数据库 Schema 设计、变更评审、DDL 发布和结构治理工具，面向团队协作式数据库变更管理。 | [products/schemaforge](products/schemaforge/) | 首个商业发布后自动生成 |
| StreamForge 商业版 | 面向流式数据平台的控制台，提供流任务管理、容量画像、集成验证、部署运维和商业授权能力。 | [products/streamforge](products/streamforge/) | [products/streamforge/releases](products/streamforge/releases/) |

## 部署方式

每个产品目录都是该产品的最新客户部署入口，通常包含：

- `README.md`：当前产品部署说明。
- `.env.example`：环境变量模板。
- Docker Compose 或 Helm 部署文件。
- `releases/`：按版本归档的压缩包和 sha256 校验文件。
- 校验脚本、发布 manifest 或产品专属运维脚本。

首次部署请进入对应产品目录或版本目录，先校验压缩包，再按包内 README 配置 `.env`、拉取固定版本镜像并启动服务。生产环境不要使用 `latest` 镜像标签。

## 下载与校验

示例：

```bash
cd products/datafusionx/releases/vX.Y.Z
shasum -a 256 -c DataFusionX-Enterprise-vX.Y.Z.tar.gz.sha256
tar -xzf DataFusionX-Enterprise-vX.Y.Z.tar.gz
```

不同产品的包名和校验命令可能略有差异，请以对应产品目录 README 和版本目录中的 `.sha256` 文件为准。

## 授权与支持

商业部署版通常需要在产品控制台完成在线激活，或生成离线申请后导入授权中心签发的 License。申请正式授权时，请提供产品授权页展示的客户标识、部署指纹、版本号和合同约定信息。

如需排查部署问题，请提供产品名称、版本目录、部署方式、脱敏后的服务日志和健康检查结果；不要提交私钥、激活码、License 原文或 `.env` 中的敏感值。
