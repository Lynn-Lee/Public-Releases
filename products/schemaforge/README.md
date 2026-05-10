# SchemaForge 商业版

SchemaForge 商业版用于数据库 Schema 设计、变更评审、DDL 发布和结构治理，面向需要协作管理数据库结构变更的研发、DBA 和平台团队。

当前目录是 SchemaForge 商业部署包的预留发布入口。首个商业版本发布后，自动发布流程会同步最新部署文件到本目录，并将版本压缩包和 sha256 校验文件写入 `releases/v<version>/`。

## 部署入口

首个商业发布完成后，请按本目录中的 `README.md`、`.env.example`、Docker Compose 或 Helm 文件完成部署。发布包只包含部署配置、校验文件和固定版本商业镜像引用，不包含 SchemaForge 源码、私钥、客户 License、激活码或镜像仓库凭据。

## 安全说明

共享日志或配置前，请移除 `.env`、License 文件、激活码、Token、私钥和生产连接串。
