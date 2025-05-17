#!/bin/sh
set -e

# required: APP_PORT (where your HTTP app is listening)
# optional: DOMAIN  (defaults to "localhost")
app_port=${APP_PORT:?ERROR: must set APP_PORT}
domain=${DOMAIN:-localhost}
ssl_port=$((app_port + 1))

# cert storage in container
cert_dir=/certs
mkdir -p "$cert_dir"
cert="$cert_dir/${domain}.pem"
key="$cert_dir/${domain}-key.pem"

# generate cert & key if missing
if [ ! -f "$cert" ] || [ ! -f "$key" ]; then
  echo "⚙️  Generating self-signed cert for ${domain}…"
  openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout "$key" \
    -out "$cert" \
    -subj "/CN=${domain}"
fi

echo "🚀  HTTPS proxy listening on :${ssl_port} → HTTP localhost:${app_port}"
# exec so socat becomes PID 1
exec socat \
  openssl-listen:"${ssl_port}",cert="${cert}",key="${key}",verify=0,reuseaddr,fork \
  tcp:127.0.0.1:"${app_port}"
