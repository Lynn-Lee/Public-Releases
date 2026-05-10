#!/usr/bin/env bash
set -Eeuo pipefail

BACKEND_URL="${BACKEND_URL:-http://127.0.0.1:8080}"
STREAMFORGE_TOKEN="${STREAMFORGE_TOKEN:-}"

die() {
  printf '错误：%s\n' "$*" >&2
  exit 1
}

command -v curl >/dev/null 2>&1 || die "未安装 curl"
command -v jq >/dev/null 2>&1 || die "未安装 jq"

auth_args=()
if [[ -n "${STREAMFORGE_TOKEN}" ]]; then
  auth_args=(-H "Authorization: Bearer ${STREAMFORGE_TOKEN}")
fi

response="$(curl -fsS --max-time 10 "${auth_args[@]}" "${BACKEND_URL}/api/license/status")" || die "无法访问 ${BACKEND_URL}/api/license/status；请通过 STREAMFORGE_TOKEN 传入登录后的 Bearer Token"
status="$(printf '%s' "${response}" | jq -r '.status // "unknown"')"
reason="$(printf '%s' "${response}" | jq -r '.reason // ""')"
customer_id="$(printf '%s' "${response}" | jq -r '.customerId // ""')"
expires_at="$(printf '%s' "${response}" | jq -r '.expiresAt // ""')"
features="$(printf '%s' "${response}" | jq -r '(.features // []) | join(",")')"

printf 'License 状态：%s\n' "${status}"
printf '客户标识：%s\n' "${customer_id:-未配置}"
printf '到期时间：%s\n' "${expires_at:-未返回}"
printf '授权功能：%s\n' "${features:-未返回}"

case "${status}" in
  licensed|trial)
    printf 'License 校验通过。\n'
    ;;
  *)
    die "License 未通过：${reason:-未知原因}"
    ;;
esac
