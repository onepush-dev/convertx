#!/usr/bin/env bash
# Creates the ConvertX owner account on a private port before the public port
# (PORT, default 8080) opens. ConvertX lets the first visitor register even
# with ACCOUNT_REGISTRATION=false, so this closes that window on Railway.
set -euo pipefail
# Railway injects PORT (8080 by default); the template domain targets 8080.
PUBLIC_PORT="${PORT:-8080}"
BOOT_PORT="${CONVERTX_BOOTSTRAP_PORT:-3999}"
MARKER=/app/data/.railway-owner-created
mkdir -p /app/data

if [ ! -f "$MARKER" ] && [ -n "${CONVERTX_ADMIN_PASSWORD:-}" ]; then
  echo "[railway] creating owner account on private port ${BOOT_PORT}"
  PORT="$BOOT_PORT" /entrypoint.sh /app/convertx &
  pid=$!
  for _ in $(seq 1 120); do
    curl -fs -m 2 -o /dev/null "http://127.0.0.1:${BOOT_PORT}/healthcheck" && break
    sleep 1
  done
  code="$(curl -s -m 20 -o /dev/null -w '%{http_code}' -X POST \
    --data-urlencode "email=${CONVERTX_ADMIN_EMAIL:-admin@example.com}" \
    --data-urlencode "password=${CONVERTX_ADMIN_PASSWORD}" \
    "http://127.0.0.1:${BOOT_PORT}/register" || true)"
  echo "[railway] owner registration returned HTTP ${code}"
  kill "$pid" 2>/dev/null || true
  wait "$pid" 2>/dev/null || true
  case "$code" in 2*|3*) touch "$MARKER" ;; *) echo "[railway] WARNING: owner account was not created" >&2 ;; esac
fi

export PORT="$PUBLIC_PORT"
exec /entrypoint.sh /app/convertx
