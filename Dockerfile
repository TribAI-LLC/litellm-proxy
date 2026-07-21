FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY docker-entrypoint.sh /app/docker-entrypoint.sh
COPY migrate.sh /app/migrate.sh

RUN chmod +x /app/docker-entrypoint.sh /app/migrate.sh

RUN python -c "import os,site; \
paths=site.getsitepackages(); \
schema=[os.path.join(p,'litellm_proxy_extras','schema.prisma') for p in paths]; \
schema=[p for p in schema if os.path.exists(p)]; \
print(schema[0] if schema else ''); \
assert schema, 'schema.prisma not found'" > /tmp/schema_path && \
python -m prisma generate --schema "$(cat /tmp/schema_path)"

EXPOSE 4000

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD []