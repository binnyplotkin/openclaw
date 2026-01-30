#!/bin/sh
set -e

# Use /tmp for config (always writable)
export OPENCLAW_STATE_DIR=/tmp/.openclaw
export OPENCLAW_WORKSPACE_DIR=/tmp/workspace
export HOME=/tmp

mkdir -p /tmp/.openclaw
mkdir -p /tmp/workspace

echo "=== Running onboard wizard ==="

# Run onboard in non-interactive mode
node dist/index.js onboard \
  --non-interactive \
  --accept-risk \
  --mode local \
  --auth-choice apiKey \
  --gateway-port ${PORT:-8080} \
  --gateway-bind lan \
  --skip-skills \
  --skip-health || true

echo "=== Onboard complete, updating token ==="

# Update the token in config if it exists
if [ -f /tmp/.openclaw/openclaw.json ]; then
  # Use node to update the token since we don't have jq
  node -e "
    const fs = require('fs');
    const config = JSON.parse(fs.readFileSync('/tmp/.openclaw/openclaw.json', 'utf8'));
    config.gateway = config.gateway || {};
    config.gateway.auth = config.gateway.auth || {};
    config.gateway.auth.token = process.env.OPENCLAW_GATEWAY_TOKEN;
    fs.writeFileSync('/tmp/.openclaw/openclaw.json', JSON.stringify(config, null, 2));
    console.log('Token updated in config');
  "
fi

echo "=== Config file contents ==="
cat /tmp/.openclaw/openclaw.json 2>/dev/null || echo "No config file found"
echo "=== End config ==="

# Start the gateway
exec node dist/index.js gateway --port ${PORT:-8080} --bind lan
