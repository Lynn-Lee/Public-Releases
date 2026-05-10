#!/usr/bin/env bash
set -Eeuo pipefail

BACKEND_IMAGE="${STREAMFORGE_BACKEND_IMAGE:-ghcr.io/lynn-lee/streamforge/backend-commercial:0.1.0-dev.12.18393e9}"
CONSOLE_IMAGE="${STREAMFORGE_CONSOLE_IMAGE:-ghcr.io/lynn-lee/streamforge/console-commercial:0.1.0-dev.12.18393e9}"
COSIGN_KEY="${STREAMFORGE_COSIGN_PUBLIC_KEY:-}"

die() {
  printf '错误：%s\n' "$*" >&2
  exit 1
}

command -v docker >/dev/null 2>&1 || die "未安装 docker"
LATEST_TAG="latest"

printf '后端镜像：%s\n' "${BACKEND_IMAGE}"
printf '控制台镜像：%s\n' "${CONSOLE_IMAGE}"

case "${BACKEND_IMAGE}" in
  *:${LATEST_TAG}) die "后端镜像禁止使用 latest 标签" ;;
esac
case "${CONSOLE_IMAGE}" in
  *:${LATEST_TAG}) die "控制台镜像禁止使用 latest 标签" ;;
esac

docker manifest inspect "${BACKEND_IMAGE}" >/dev/null || die "后端镜像不可访问，请确认镜像仓库、版本号或网络连通性"
docker manifest inspect "${CONSOLE_IMAGE}" >/dev/null || die "控制台镜像不可访问，请确认镜像仓库、版本号或网络连通性"

if [[ -n "${COSIGN_KEY}" ]]; then
  command -v cosign >/dev/null 2>&1 || die "配置了 STREAMFORGE_COSIGN_PUBLIC_KEY 但未安装 cosign"
  cosign verify --key "${COSIGN_KEY}" "${BACKEND_IMAGE}" >/dev/null || die "后端镜像 cosign 签名校验失败"
  cosign verify --key "${COSIGN_KEY}" "${CONSOLE_IMAGE}" >/dev/null || die "控制台镜像 cosign 签名校验失败"
  printf '镜像签名校验通过。\n'
else
  printf '未配置 STREAMFORGE_COSIGN_PUBLIC_KEY，仅完成镜像可访问性与固定标签校验。\n'
fi
