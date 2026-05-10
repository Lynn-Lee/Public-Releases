# DataFusionX 商业私有化部署方案

本文用于 DataFusionX Enterprise 客户私有化交付。商业交付包只包含固定版本商业镜像引用、部署编排文件、Helm Chart、环境变量模板和校验清单，不向客户交付后端源码、前端源码、构建脚本私钥或 `License-Server-Center` 源码。离线客户仍可由发布方额外提供镜像 tar 包。

## 交付形态

- 后端使用 `backend/Dockerfile.commercial` 构建商业镜像，`backend/app/core`、`backend/app/models`、`backend/app/services` 和 `backend/app/worker` 会在构建阶段通过 Nuitka 编译为平台相关扩展模块，并删除这些目录内的业务源码文件。FastAPI 路由声明和 Pydantic schema 保留源码，以保证框架反射和 OpenAPI 生成稳定。
- 前端使用 Vite 生产构建产物，禁用 sourcemap，只交付 Nginx 静态资源镜像。
- 客户部署可以使用 `deploy/docker-compose.commercial.yml` 或 `deploy/helm/datafusionx-commercial`，二者只引用已构建镜像，不包含源码 build context。
- `scripts/build-commercial-release.sh` 可生成两种交付形态：默认本地离线包会包含镜像 tar；CI 公开商业包会推送固定版本 GHCR 镜像，并只打包 Docker Compose、Helm Chart、`checksums.txt`、`release-manifest.json` 和 `release-manifest.sig`。
- 商业后端镜像构建阶段会生成核心文件完整性 manifest，并用公司 Ed25519 发布私钥签名；Web、Celery Worker 和 Celery Beat 启动时会使用 `COMMERCIAL_INTEGRITY_PUBLIC_KEY` 校验 manifest 签名和关键文件 hash。

## 构建商业交付包

在研发或发布环境执行：

```bash
python scripts/commercial-manifest.py generate-keypair
export COMMERCIAL_MANIFEST_PRIVATE_KEY=<公司发布签名私钥>
scripts/build-commercial-release.sh 1.0.0
```

`COMMERCIAL_MANIFEST_PRIVATE_KEY` 必须保存在发布机或 CI/CD secret 中，不得写入仓库、镜像、`.env` 或客户交付包。商业 Dockerfile 通过 BuildKit secret 读取私钥，避免私钥进入镜像层历史。
`COMMERCIAL_MANIFEST_PUBLIC_KEY` 已固定为 `7sE7Bn3CJGIAd-CCDpeX-05wjTFsaS4kbM3vKU0tWNM`，脚本会自动写入客户包 `.env.example` 和 Helm values 的 `COMMERCIAL_INTEGRITY_PUBLIC_KEY` / `commercialIntegrityPublicKey`。

生成目录：

```text
dist-commercial/datafusionx-enterprise-1.0.0/
  images/
    datafusionx-backend-commercial-1.0.0.tar
    datafusionx-frontend-commercial-1.0.0.tar
  deploy/
    docker-compose.yml
  helm/
    datafusionx-commercial/
  tools/
    commercial-manifest.py
  .env.example
  COMMERCIAL_DEPLOYMENT.md
  checksums.txt
  release-manifest.json
  release-manifest.sig
```

交付验签：

```bash
python tools/commercial-manifest.py verify-release \
  --package-dir dist-commercial/datafusionx-enterprise-1.0.0 \
  --public-key <公司发布验签公钥>
```

正式发布时还应在交付单中记录镜像 digest。签名私钥不得进入本仓库、镜像和客户部署包。

如需生成公开下载包并推送镜像：

```bash
DATAFUSIONX_VERSION=1.0.0 \
DATAFUSIONX_IMAGE_REPOSITORY=ghcr.io/<org>/datafusionx \
DATAFUSIONX_PUSH_IMAGES=true \
DATAFUSIONX_SAVE_IMAGES=false \
COMMERCIAL_MANIFEST_PRIVATE_KEY=<公司发布签名私钥> \
scripts/build-commercial-release.sh
```

该模式生成 `dist-commercial/DataFusionX-Enterprise-v1.0.0.tar.gz` 和 `.sha256`，包内 `.env.example` 固定引用：

```text
ghcr.io/<org>/datafusionx-backend:1.0.0
ghcr.io/<org>/datafusionx-frontend:1.0.0
```

## 自动公开商业发布

DataFusionX 参照 SagittaDB 的公开商业交付方式，使用 `.github/workflows/commercial-release.yml` 自动生成客户可直接下载的商业部署包。

触发方式：

- 推送到 `main` 或 `release/**`：生成快照版本，例如 `0.1.0-dev.123.abcdef0`。
- 推送正式 tag `vX.Y.Z`：生成正式版本 `X.Y.Z`。
- 手动 `workflow_dispatch`：填写 `version` 时生成指定正式版本；留空时生成快照版本。

工作流会自动执行：

1. 构建商业后端镜像和商业前端镜像。
2. 推送固定版本镜像到 `ghcr.io/lynn-lee/datafusionx-backend:<version>` 和 `ghcr.io/lynn-lee/datafusionx-frontend:<version>`。
3. 渲染客户部署包，包内 Compose 和 Helm 只引用固定版本镜像。
4. 生成 signed `release-manifest`、`.tar.gz` 和 `.sha256`。
5. 校验部署包不包含源码、私钥、浮动镜像标签或源码构建配置。
6. 同步最新部署入口和版本压缩包到 `Lynn-Lee/Public-Releases/products/datafusionx/`。

为避免 GitHub Actions artifact storage quota 被大包耗尽，商业部署包默认不上传为 Actions artifact；如确需临时留存，可配置仓库变量 `ENABLE_COMMERCIAL_RELEASE_ARTIFACT=true`。

客户部署时可从公开发布仓库下载：

```bash
wget https://github.com/Lynn-Lee/Public-Releases/raw/main/products/datafusionx/releases/v1.0.0/DataFusionX-Enterprise-v1.0.0.tar.gz
wget https://github.com/Lynn-Lee/Public-Releases/raw/main/products/datafusionx/releases/v1.0.0/DataFusionX-Enterprise-v1.0.0.tar.gz.sha256
shasum -a 256 -c DataFusionX-Enterprise-v1.0.0.tar.gz.sha256
tar -xzf DataFusionX-Enterprise-v1.0.0.tar.gz
cd DataFusionX-Enterprise-v1.0.0
cp .env.example .env
docker compose -f deploy/docker-compose.yml --env-file .env pull
docker compose -f deploy/docker-compose.yml --env-file .env up -d
```

GitHub Secrets 必须配置：

```text
COMMERCIAL_MANIFEST_PRIVATE_KEY
PUBLIC_RELEASES_TOKEN
```

`COMMERCIAL_MANIFEST_PRIVATE_KEY` 只用于商业镜像完整性 manifest 和客户发布包 manifest 签名，不得放入仓库和客户部署包。发布验签公钥已内置为 `7sE7Bn3CJGIAd-CCDpeX-05wjTFsaS4kbM3vKU0tWNM`，不需要配置为 GitHub Secret。`PUBLIC_RELEASES_TOKEN` 必须能写入 `Lynn-Lee/Public-Releases`，建议只授予该公开仓库的 contents read/write 权限。

## 客户部署流程

如果客户环境无法访问 GHCR，可使用离线交付包中的镜像 tar。客户现场导入镜像：

```bash
docker load -i images/datafusionx-backend-commercial-1.0.0.tar
docker load -i images/datafusionx-frontend-commercial-1.0.0.tar
```

复制环境变量模板：

```bash
cp .env.example .env
```

必须配置：

```text
POSTGRES_PASSWORD
JWT_SECRET_KEY
ENCRYPTION_SECRET_KEY
LICENSE_PUBLIC_KEY
LICENSE_DEPLOYMENT_ID
COMMERCIAL_INTEGRITY_PUBLIC_KEY
```

`LICENSE_DEPLOYMENT_ID` 是客户部署的稳定设备种子，生成后不要随意变更；变更会导致部署指纹变化，需要重新签发或迁移 License。
`COMMERCIAL_INTEGRITY_PUBLIC_KEY` 是商业发布验签公钥，客户包默认已配置为 `7sE7Bn3CJGIAd-CCDpeX-05wjTFsaS4kbM3vKU0tWNM`；它不是 License 公钥，二者可以分离管理。

启动：

```bash
docker compose -f deploy/docker-compose.yml --env-file .env up -d
```

默认访问：

```text
前端：http://localhost:8080
后端：http://localhost:18000
```

## Helm 部署流程

客户 Kubernetes 环境可使用随包交付的 Helm Chart：

```bash
helm upgrade --install datafusionx ./helm/datafusionx-commercial \
  --set global.version=1.0.0 \
  --set image.backend=datafusionx-backend-commercial:1.0.0 \
  --set image.frontend=datafusionx-frontend-commercial:1.0.0 \
  --set global.publicUrl=https://datafusionx.example.com \
  --set secrets.postgresPassword=<数据库密码> \
  --set secrets.jwtSecretKey=<至少 32 位 JWT 密钥> \
  --set secrets.encryptionSecretKey=<至少 32 位加密密钥> \
  --set secrets.licensePublicKey=<License 公钥> \
  --set secrets.licenseDeploymentId=<稳定部署 ID>
```

Helm Chart 默认包含 PostgreSQL、Redis、Backend、Frontend、Celery Worker、Celery Beat 和授权文件 PVC；生产客户如已有托管 PostgreSQL/Redis，可基于该 Chart 调整外部依赖接入。

## 在线激活

系统管理员登录后进入系统健康页，填写客户 ID 和在线激活码，DataFusionX 会请求 `License-Server-Center`：

```text
POST /api/v1/licenses/activate
```

请求会携带：

- `project=datafusionx`
- `product=datafusionx`
- `customer_id`
- `deployment_fingerprint`
- 当前用量快照
- 运行时版本和环境信息

授权中心返回 signed License 后，DataFusionX 使用内置 Ed25519 public key 验签，保存到 `license_records` 和 `/app/licenses/datafusionx-license.json`。

## 离线激活

客户无法访问授权中心时：

1. 系统管理员进入系统健康页。
2. 填写客户 ID。
3. 点击“生成离线申请”。
4. 将生成的 JSON 发回授权运营侧。
5. `License-Server-Center` 根据申请中的 `deployment_fingerprint` 签发离线 License。
6. 客户把 signed License JSON 粘贴到“离线 License JSON”并导入。

离线申请不包含私钥或敏感连接凭据，只包含客户 ID、部署指纹、版本、环境和用量快照。

离线 License 响应仍必须是授权中心使用 Ed25519 私钥签发的 signed License。DataFusionX 导入时会校验项目码、客户 ID、部署指纹、有效期、版本范围、功能和额度；如果 `allowed_versions`、`min_version` 或 `max_version` 不允许当前 `APP_VERSION`，导入会失败。

## 授权与源码保护边界

DataFusionX 客户侧只内置 Ed25519 public key，`License-Server-Center` 私钥只保存在授权中心。客户无法通过修改本地 License JSON 伪造签名。

DataFusionX 后端会按 License 中的 `features` 和 `limits` 做商业版能力拦截。功能键覆盖项目、用户、连接、CDC、Batch、Batch 调度、DDL Guard 和告警通知；额度键覆盖用户数、项目数、任务数、源端连接数、StarRocks 连接数和总连接数。客户修改前端或直接调用 API 时，后端仍会返回 `LICENSE_FEATURE_DISABLED` 或 `LICENSE_LIMIT_EXCEEDED`。

私有化部署无法绝对阻止拥有主机 root 权限的客户逆向或修改运行环境。本方案通过以下方式提高篡改成本：

- 不交付源码仓库。
- 后端商业镜像删除核心业务目录 `.py` 源码，仅保留编译扩展模块、API 壳层、schema 和必要包初始化文件。
- 前端禁用 sourcemap，只交付压缩后的静态产物。
- 生产环境默认 `LICENSE_REQUIRED=true`。
- 授权绑定客户 ID、部署指纹、版本、到期时间、功能和额度。
- 交付包生成 `checksums.txt` 和 signed `release-manifest`，客户可用公司发布公钥验签。
- 商业镜像启动时校验 signed integrity manifest，关键文件被替换或删除时拒绝启动。

## 法务兜底条款

商业合同、报价单、交付单或 EULA 应明确禁止以下行为：

- 对 DataFusionX 商业镜像、前端产物、License 文件或发布包进行逆向、反编译、反汇编、规避授权校验或绕过完整性校验。
- 修改、删除、替换商业版完整性 manifest、签名、公钥、授权校验逻辑或额度控制逻辑。
- 未经书面许可复制、出租、转让、托管、二次销售、二次分发 DataFusionX 商业部署包。
- 将商业部署包用于授权客户、授权部署 ID、授权环境或授权期限之外的场景。
- 泄露、共享、转售激活码、离线 License、部署指纹或交付镜像。

技术保护不能替代合同约束；法务条款用于补齐客户拥有主机管理员权限时的追责边界。

## 运维注意事项

- 不要把 `.env`、真实数据库连接串、Token、私钥或云服务凭据提交到仓库。
- 不要在客户侧部署 `License-Server-Center` 私钥。
- 在线授权会由 Celery Beat 每天自动刷新；离线授权只做本地验签和到期检查。
- 授权过期、吊销、冻结或本地验签失败时，业务 API 返回 `LICENSE_REQUIRED`。
