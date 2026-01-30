#!/bin/sh
set -e

# Clear old config completely
rm -rf /data/.openclaw
mkdir -p /data/.openclaw
mkdir -p /data/workspace

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
