# Public Releases

This repository publishes commercial deployment packages for products maintained by Lynn Lee.

The repository contains deployment files, documentation, release packages, and checksums. It does not contain product source code, private keys, customer licenses, activation codes, or registry credentials.

## Products

| Product | Latest Published Version | Deployment |
| --- | --- | --- |
| SagittaDB Enterprise | 1.0.5-dev.10.5899724 | [products/sagittadb](products/sagittadb/) |

## SagittaDB Enterprise

SagittaDB Enterprise is delivered as a public deployment package with fixed-version commercial container images:

- `ghcr.io/lynn-lee/sagittadb-backend:1.0.5-dev.10.5899724`
- `ghcr.io/lynn-lee/sagittadb-frontend:1.0.5-dev.10.5899724`

Download the package from [products/sagittadb/releases/v1.0.5-dev.10.5899724](products/sagittadb/releases/v1.0.5-dev.10.5899724/), verify the checksum, and follow the included README.

```bash
cd products/sagittadb/releases/v1.0.5-dev.10.5899724
shasum -a 256 -c SagittaDB-Enterprise-v1.0.5-dev.10.5899724.zip.sha256
```

First deployment starts a 30-day full-feature trial. After the trial expires, business APIs are blocked and the license management page remains available.
