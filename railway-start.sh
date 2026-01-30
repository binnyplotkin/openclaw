#!/bin/sh
set -e

# Use /tmp for config (always writable)
export OPENCLAW_STATE_DIR=/tmp/.openclaw
export OPENCLAW_WORKSPACE_DIR=/tmp/workspace

mkdir -p /tmp/.openclaw
mkdir -p /tmp/workspace

# Create fresh config with the gateway token from env
cat > /tmp/.openclaw/openclaw.json << EOF
{
  "gateway": {
    "token": "${OPENCLAW_GATEWAY_TOKEN}",
    "port": ${PORT:-8080},
    "bind": "lan",
    "authMode": "token"
  },
  "workspace": "/tmp/workspace"
}
EOF

echo "Config created with token: ${OPENCLAW_GATEWAY_TOKEN}"

# Start the gateway
exec node dist/index.js gateway --port ${PORT:-8080} --bind lan --allow-unconfigured
