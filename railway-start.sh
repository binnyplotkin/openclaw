#!/bin/sh
set -e

# Fixed token - won't change between restarts
FIXED_TOKEN="openclaw-railway-token-2026"

export HOME=/tmp
export OPENCLAW_STATE_DIR=/tmp/.openclaw
export OPENCLAW_WORKSPACE_DIR=/tmp/workspace

mkdir -p /tmp/.openclaw
mkdir -p /tmp/workspace

echo "=== Creating config with fixed token ==="

# Create config directly instead of using onboard wizard
cat > /tmp/.openclaw/openclaw.json << EOF
{
  "gateway": {
    "mode": "local",
    "port": ${PORT:-8080},
    "bind": "lan",
    "auth": {
      "mode": "token",
      "token": "${FIXED_TOKEN}"
    }
  },
  "auth": {
    "profiles": {
      "anthropic:default": {
        "provider": "anthropic",
        "mode": "api_key"
      }
    }
  },
  "agents": {
    "defaults": {
      "workspace": "/tmp/workspace"
    }
  }
}
EOF

mkdir -p /tmp/.openclaw/agents/main/sessions
mkdir -p /tmp/.openclaw/workspace

echo "=============================================="
echo "FIXED TOKEN: ${FIXED_TOKEN}"
echo "ACCESS URL: https://openclaw-production-cf83.up.railway.app/?token=${FIXED_TOKEN}"
echo "=============================================="

echo "=== Config file contents ==="
cat /tmp/.openclaw/openclaw.json
echo "=== End config ==="

# Start the gateway
exec node dist/index.js gateway --port ${PORT:-8080} --bind lan
