# Public Releases

本仓库是 Lynn Lee 维护产品的商业部署版统一发布入口，用于向客户提供可下载的私有化部署包、部署文档、校验文件和版本归档。

本仓库不包含产品源码、构建私钥、客户 License、激活码、生产连接串、Token 或镜像仓库凭据。共享日志、工单附件或部署配置前，请先移除 `.env`、License 文件和任何客户侧密钥。

## 产品入口

| 产品 | 一句话定位 | 部署入口 | 发布包 |
| --- | --- | --- | --- |
| DataFusionX Enterprise | 轻量级数据同步控制台，把企业已有 CDC / Batch / Flink SQL / StarRocks 链路统一成可配置、可观测、可审计的控制面。 | [products/datafusionx](products/datafusionx/) | [products/datafusionx/releases](products/datafusionx/releases/) |
| SagittaDB Enterprise | 企业级多引擎数据库管控平台，统一数据库实例、SQL 工单、在线查询、权限治理、运行诊断和审计合规。 | [products/sagittadb](products/sagittadb/) | [products/sagittadb/releases](products/sagittadb/releases/) |
| SchemaForge 商业版 | 面向中文研发团队的数据建模与数据库变更治理平台，从中文需求到 ER 模型、数据字典、评审和 DDL 交付。 | [products/schemaforge](products/schemaforge/) | [products/schemaforge/releases](products/schemaforge/releases/) |
| StreamForge 商业版 | 面向 StarRocks 实时数仓的数据集成控制平台，托管 CDC、Batch、Kafka、Flink SQL、SeaTunnel、运行监控和生产治理。 | [products/streamforge](products/streamforge/) | [products/streamforge/releases](products/streamforge/releases/) |

## 产品功能说明

### DataFusionX Enterprise

DataFusionX 是面向企业 IT、DBA 和数据开发人员的轻量级数据同步控制工具。它不托管生产数据面资源，而是接入企业已有的源端数据库、Kafka Topic、Flink SQL Gateway 和 StarRocks 表，负责把同步任务配置、执行计划生成、Flink SQL 提交、运行观测和 DDL 风险控制收敛到一个控制台。

适合场景：

- 企业已经有 Kafka、Flink、StarRocks 等数据面组件，希望增加一个轻量控制台管理同步任务。
- DBA 或数据开发需要把 MySQL、PostgreSQL、Oracle、SQL Server、TiDB 等源端数据同步到 StarRocks。
- 团队希望在不自动创建 Kafka Topic、Debezium Connector、TiCDC Changefeed 或生产 StarRocks 表的前提下，统一任务发布、运行排障和审计。

核心功能：

- 项目隔离与 RBAC：支持本地账号、JWT 登录、项目成员、`admin` / `operator` / `viewer` 角色和项目级权限控制。
- 连接管理：管理源端连接与 StarRocks 连接，支持连接测试、Schema 探测、目标表只读检查和敏感凭据加密存储。
- CDC 同步控制：配置已有 Kafka Topic、Debezium JSON / Canal JSON、消费起点、consumer group、字段映射、Transform SQL、delete 事件语义和 StarRocks 写入策略。
- Batch 同步控制：配置源端表或查询、目标 StarRocks 表、字段映射、Transform SQL 和 Cron 调度，通过 Flink SQL Batch 提交 JDBC 到 StarRocks 作业。
- 执行计划生成：生成 Kafka Source DDL、JDBC Source DDL、StarRocks Sink DDL 和 INSERT SQL，支持发布前校验、计划预览和版本 diff。
- 运行中心：展示任务状态、Flink Job ID、运行日志、读写行数、目标表行数、失败分类、retry 入口和活跃 Flink Job 刷新。
- DDL Guard：保存源端 Schema 基线，检测字段、类型、主键、索引和源表存在状态变化；发现风险后阻断相关 CDC / Batch 任务，人工确认后恢复。
- 审计与告警：记录项目、用户、资源类型、操作类型、运行告警和 DDL Guard 事件，便于生产预测试和上线留痕。
- 商业授权：接入 License-Server-Center，支持临时 License、在线激活、离线激活申请、在线验证、在线刷新、功能开关和额度拦截。

交付形态：

- Docker Compose 私有化部署。
- Kubernetes / Helm 私有化部署。
- 固定版本商业镜像和 signed release manifest。

### SagittaDB Enterprise

SagittaDB 是企业级多引擎数据库管控平台，面向数据库变更、数据查询、权限治理、运行诊断和审计合规场景。它的目标是把企业数据库访问从“分散账号、人工审批、线下执行、事后追责”升级为“统一入口、权限收敛、流程审批、异步执行、全程审计”。

适合场景：

- 企业内部有多种数据库引擎，需要统一实例管理、查询入口和变更流程。
- 研发希望安全查询数据、提交 SQL 上线申请并追踪审批进度。
- DBA 需要审核 SQL、执行变更、诊断数据库运行状态并管理高风险操作。
- 安全审计员需要追踪查询历史、权限变化、工单操作和通知投递记录。

核心功能：

- 多引擎实例管理：支持 MySQL、TiDB、StarRocks、PostgreSQL、MongoDB、Redis、ClickHouse、Oracle、MSSQL、Elasticsearch、OpenSearch、Doris、Cassandra、ScyllaDB 等引擎的连接、元数据和基础观测能力。
- SQL 工单：支持 SQL 提交、语法校验、审批流快照、逐级审批、异步执行、执行日志、取消操作、通知投递和审计记录。
- 在线查询：支持多引擎查询、实例 / 库 / 表级查询授权、最大返回行数治理、查询历史、失败原因解释和结果脱敏。
- 数据字典：基于授权范围查看数据库、Schema、表、字段、约束、索引、DDL 预览和元数据说明。
- 权限治理：采用 v2-lite 权限体系，通过角色权限、用户组资源范围、查询授权三层收敛访问边界。
- 数据安全：支持敏感字段加密、密码强度策略、JWT 黑名单、操作审计、查询结果脱敏和生产安全检查。
- 运行诊断：提供会话管理、SQL 洞察、慢 SQL、执行计划、容量采集、指标采集和诊断建议。
- 数据归档：支持归档申请、审批、分批执行、暂停、继续、取消和批次日志。
- 企业集成：支持 LDAP、钉钉、飞书、企业微信、CAS 登录，以及邮件和应用消息通知。
- 商业授权：提供 30 天试用、在线激活、离线 Challenge-Response、授权项目码校验和 License 管理入口。

交付形态：

- Docker Compose 私有化部署。
- Kubernetes / Helm 私有化部署。
- 固定版本商业镜像、升级脚本、法律提示、截图和授权验证工具。

### SchemaForge 商业版

SchemaForge 云铸是面向中文研发团队的数据建模与数据库变更治理平台。它不是单纯的 ER 图工具，而是希望把中文业务需求、数据库结构、字段规范、数据字典、设计评审和变更流程沉淀为可协作、可评审、可治理、可交付的工程资产。

适合场景：

- 新系统设计数据库结构，希望从中文业务描述快速形成初始模型。
- 现有数据库需要反向建模，生成 ER 图、中文数据字典和结构文档。
- 架构师、DBA、研发之间需要在线评审数据库设计、变更风险和 Migration SQL。
- 数据治理团队需要维护业务术语、字段标准、敏感级别、枚举字典和负责人。
- 企业希望同时支持 SaaS、私有化、客户云和后续本地桌面形态。

核心功能：

- 项目与模型工作台：按组织、项目和模型管理数据库设计资产，支持成员邀请、角色权限和协作入口。
- 可视化 ER 建模：支持 ER 表节点、表关系、字段编辑、逻辑模型、物理模型和多数据库方言入口。
- 中文数据字典：维护表中文名、字段中文名、字段说明、业务术语、枚举字典、敏感级别和负责人。
- DDL 导入导出：支持 MySQL、PostgreSQL、Oracle、TiDB 等方言入口，生成 DDL、解析 DDL、导出 Markdown / Word 数据字典。
- 规范检查：对命名规范、标准字段、索引规范、字段类型、主键约束和设计质量进行基础检查。
- 版本与 Diff：记录模型版本，展示结构差异，生成变更报告和 Migration 脚本。
- 评审审批：支持架构师和 DBA 在线评论、审批、驳回或通过数据库设计变更。
- AI 辅助：支持中文需求到模型的辅助生成、私有模型调用链路和 AI 评审能力预留。
- 审计与归档：支持审计日志筛选导出、商业部署保留策略、归档 dry-run 和归档批次查询。
- 企业登录与授权：支持 OIDC、SAML、账号恢复、离线 License、在线激活、在线验证、在线刷新、部署指纹绑定、功能开关和额度限制。

交付形态：

- SaaS 云版。
- Docker Compose 私有化部署。
- Kubernetes / Helm 部署。
- BYOC 客户云部署。
- 后续可扩展本地桌面版。

### StreamForge 商业版

StreamForge 是面向 StarRocks 实时数仓场景的统一数据集成控制平台。它保持平台自托管的一体化链路，负责托管并编排 Capture、Kafka、Flink SQL、StarRocks 写入、SeaTunnel Batch、运行状态、日志指标、告警和审计。

适合场景：

- 企业希望构建 StarRocks 实时数仓，把多源业务数据库准实时或批量同步到 StarRocks。
- 数据平台团队需要统一管理 MySQL、TiDB、PostgreSQL、Oracle、SQL Server 等源端的 CDC / Batch 链路。
- 团队希望降低 Kafka、Debezium、TiCDC、Flink、SeaTunnel、StarRocks 的配置和运维门槛。
- 生产上线前需要 Integration Lab、版本矩阵、云上 smoke、容量基线和生产就绪报告。

核心功能：

- 项目与权限：支持登录认证、Bearer Token、Refresh Token、会话管理、登录失败锁定、用户生命周期、项目级角色权限和审计。
- 数据源与目标端：管理多源数据库连接和 StarRocks 目标端，支持 JDBC 连接测试、诊断结果展示、Schema 探测和敏感信息脱敏。
- CDC 任务：支持 MySQL、TiDB、PostgreSQL、Oracle、SQL Server 到 Kafka / Flink SQL / StarRocks 的 CDC 工件生成、发布、部署、暂停、恢复、停止和重部署。
- Batch 任务：支持全量、增量、补数、Quartz JDBC 持久化 Cron 调度、失败重试、Flink SQL Batch 和外部 SeaTunnel runtime。
- 执行计划：生成 Source DDL、StarRocks Sink DDL、Transform SQL、Runtime Config，支持执行计划预览、发布、版本历史和环境标记。
- 任务向导：从页面完成连接选择、表选择、字段点选、字段映射 JSON 自动生成、配置校验、计划预览、发布和多表批量建任务。
- StarRocks 表治理：支持目标表存在性检查、DDL 预览、安全建表、表设计建议和统一写入批次策略。
- 运行监控：提供项目概览、任务详情、运行中心、运行时间线、失败根因卡片、运行日志、核心指标、Webhook 告警、失败 retry 和手动重发。
- 生产治理：支持 DDL Guard、数据血缘、数据质量规则、质量趋势、发布质量门禁、风险豁免、多环境发布、回滚和环境级连接映射。
- Integration Lab：提供源库、Redpanda、Debezium Connect、Flink、StarRocks、SeaTunnel 的云上测试环境和生产候选版本矩阵。
- 商业交付：支持 Java 后端 yGuard 字节码混淆、前端禁用 sourcemap、启动完整性校验、manifest 签名、固定版本 GHCR 镜像和商业授权页面。

交付形态：

- Docker Compose 私有化部署。
- Kubernetes / Helm 私有化部署。
- Integration Lab 云上验证环境。
- 固定版本商业镜像和客户部署压缩包。

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
