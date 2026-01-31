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

# Update the token in the config file (onboard writes to $HOME/.openclaw/)
CONFIG_FILE="$HOME/.openclaw/openclaw.json"
if [ -f "$CONFIG_FILE" ]; then
  node -e "
    const fs = require('fs');
    const configPath = process.env.HOME + '/.openclaw/openclaw.json';
    const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
    config.gateway = config.gateway || {};
    config.gateway.auth = config.gateway.auth || {};
    config.gateway.auth.token = process.env.OPENCLAW_GATEWAY_TOKEN;
    fs.writeFileSync(configPath, JSON.stringify(config, null, 2));
    console.log('Token updated in config at: ' + configPath);
  "
fi

echo "=== Config file contents ==="
cat "$HOME/.openclaw/openclaw.json" 2>/dev/null || echo "No config file found"
echo "=== End config ==="

# Start the gateway
exec node dist/index.js gateway --port ${PORT:-8080} --bind lan
