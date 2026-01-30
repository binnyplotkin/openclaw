#!/bin/sh
set -e

# Use /tmp for config (always writable)
export OPENCLAW_STATE_DIR=/tmp/.openclaw
export OPENCLAW_WORKSPACE_DIR=/tmp/workspace
export OPENCLAW_CONFIG_PATH=/tmp/.openclaw/openclaw.json
export HOME=/tmp

mkdir -p /tmp/.openclaw
mkdir -p /tmp/workspace

# Create fresh config with the gateway token from env
cat > /tmp/.openclaw/openclaw.json << EOF
{
  "gateway": {
    "port": ${PORT:-8080},
    "bind": "lan",
    "auth": {
      "token": "${OPENCLAW_GATEWAY_TOKEN}"
    }
  }
}
EOF

echo "=== Config file contents ==="
cat /tmp/.openclaw/openclaw.json
echo "=== End config ==="
echo "OPENCLAW_STATE_DIR=${OPENCLAW_STATE_DIR}"
echo "OPENCLAW_CONFIG_PATH=${OPENCLAW_CONFIG_PATH}"

# Start the gateway
exec node dist/index.js gateway --port ${PORT:-8080} --bind lan
