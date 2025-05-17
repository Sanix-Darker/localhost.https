#!/bin/sh
set -e

# entrypoint.sh: HTTPS→HTTP proxy with self-signed cert
# Usage (args):
#   curl -sSL https://raw.githubusercontent.com/Sanix-Darker/localhost.https/refs/heads/master/s.sh | \
#   bash -s -- <app_port> [<domain>]
# Usage (env):
#   APP_PORT=<port> DOMAIN=<domain> ./s.sh

# parse app_port
if [ -n "$1" ]; then
  app_port="$1"
elif [ -n "$APP_PORT" ]; then
  app_port="$APP_PORT"
else
  echo "ERROR: must provide APP_PORT as first arg or via APP_PORT env"
  exit 1
fi
# parse domain
if [ -n "$2" ]; then
  domain="$2"
elif [ -n "$DOMAIN" ]; then
  domain="$DOMAIN"
else
  domain="localhost"
fi
ssl_port=$((app_port + 1))

# cert storage
cert_dir=/certs
mkdir -p "$cert_dir"
cert="$cert_dir/${domain}.pem"
key="$cert_dir/${domain}-key.pem"

# generate cert & key if missing
if [ ! -f "$cert" ] || [ ! -f "$key" ]; then
  echo "⚙️  Generating self-signed cert for $domain…"
  openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout "$key" \
    -out "$cert" \
    -subj "/CN=$domain"
fi

echo "🚀  HTTPS proxy listening on :$ssl_port → HTTP localhost:$app_port"

# start proxy
exec socat \
  openssl-listen:"$ssl_port",cert="$cert",key="$key",verify=0,reuseaddr,fork \
  tcp:127.0.0.1:"$app_port"
