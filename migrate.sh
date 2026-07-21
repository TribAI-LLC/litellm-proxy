#!/usr/bin/env bash
set -euo pipefail

SCHEMA_PATH=$(python - <<'PY'
import os
import site

for p in site.getsitepackages():
    candidate = os.path.join(p, "litellm_proxy_extras", "schema.prisma")
    if os.path.exists(candidate):
        print(candidate)
        raise SystemExit(0)

raise SystemExit("schema.prisma not found")
PY
)

echo "Using Prisma schema: $SCHEMA_PATH"
echo "Running prisma migrate deploy..."
python -m prisma migrate deploy --schema "$SCHEMA_PATH"

echo "Migration completed successfully."