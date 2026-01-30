#!/bin/sh
set -e

# Create dirs if they don't exist (first run)
mkdir -p /data/.openclaw 2>/dev/null || true
mkdir -p /data/workspace 2>/dev/null || true

# Remove only the config file (not the directory)
rm -f /data/.openclaw/openclaw.json 2>/dev/null || true
rm -f /data/.openclaw/gateway-token 2>/dev/null || true

# Create fresh config with the gateway token from env
cat > /data/.openclaw/openclaw.json << EOF
{
  "gateway": {
    "token": "${OPENCLAW_GATEWAY_TOKEN}",
    "port": ${PORT:-8080},
    "bind": "lan",
    "authMode": "token"
  },
  "workspace": "/data/workspace"
}
EOF

echo "Config created with token: ${OPENCLAW_GATEWAY_TOKEN}"

# Start the gateway
exec node dist/index.js gateway --port ${PORT:-8080} --bind lan --allow-unconfigured
