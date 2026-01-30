#!/bin/sh
set -e

# Create config directory
mkdir -p /data/.openclaw

# Create config with the gateway token from env
cat > /data/.openclaw/openclaw.json << EOF
{
  "gateway": {
    "token": "${OPENCLAW_GATEWAY_TOKEN}",
    "port": ${PORT:-8080},
    "bind": "lan"
  }
}
EOF

# Start the gateway
exec node dist/index.js gateway --port ${PORT:-8080} --bind lan --allow-unconfigured
