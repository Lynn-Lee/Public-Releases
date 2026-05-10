#!/usr/bin/env bash
set -Eeuo pipefail

TARGET_VERSION="${1:-0.1.0-dev.4.6319794}"
BACKEND_HEALTH_URL="${BACKEND_HEALTH_URL:-http://127.0.0.1:8080/api/auth/health}"
CONSOLE_HEALTH_URL="${CONSOLE_HEALTH_URL:-http://127.0.0.1:5174/}"

log() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

die() {
  log "错误：$*"
  exit 1
}

wait_for_url() {
  local name="$1"
  local url="$2"
  local attempts="${3:-40}"
  local sleep_seconds="${4:-3}"

  log "等待 ${name} 健康检查：${url}"
  for ((i = 1; i <= attempts; i++)); do
    if curl -fsS --max-time 5 "${url}" >/dev/null; then
      log "${name} 健康检查通过"
      return 0
    fi
    sleep "${sleep_seconds}"
  done
  return 1
}

[[ -f docker-compose.yml ]] || die "未找到 docker-compose.yml，请在客户部署包目录执行本脚本。"
[[ -f .env ]] || die "未找到 .env，请先复制 .env.example 为 .env 并完成配置。"

log "将 StreamForge 镜像标签更新为 ${TARGET_VERSION}"
tmp_file="$(mktemp)"
sed -E "s#(STREAMFORGE_(BACKEND|CONSOLE)_IMAGE=.*/(backend|console)-commercial:)[^[:space:]]+#\1${TARGET_VERSION}#g" .env > "${tmp_file}"
mv "${tmp_file}" .env

log "拉取 StreamForge 商业版镜像"
docker compose pull backend console

log "重建服务"
docker compose up -d

wait_for_url "backend" "${BACKEND_HEALTH_URL}" 40 3
wait_for_url "console" "${CONSOLE_HEALTH_URL}" 30 3

log "升级完成"
docker compose ps
