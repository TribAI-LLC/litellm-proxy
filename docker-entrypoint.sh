#!/usr/bin/env bash
set -euo pipefail

echo "Starting LiteLLM..."
exec litellm --host 0.0.0.0 --port 4000