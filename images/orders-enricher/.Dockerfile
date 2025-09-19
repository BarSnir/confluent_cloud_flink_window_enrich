FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# librdkafka עבור confluent-kafka + תעודות
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl gcc g++ librdkafka-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# תלויות
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# קוד
COPY orders_enricher.py /app/orders_enricher.py

# משתמש לא־root
RUN useradd -u 10001 -m appuser && chown -R appuser:appuser /app
USER appuser

# ברירות מחדל (ניתן לדרוס ב-compose)
ENV ENV_PATH=/app/.env \
    LOG_LEVEL=INFO \
    DELETE_ON_TOMBSTONE=true

CMD ["python", "-u", "/app/orders_enricher.py"]
