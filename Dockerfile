FROM python:3.12-slim AS runtime

# Create non-root user
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# Install latest pip first
RUN pip install --no-cache-dir --upgrade pip

# Copy requirements and install deps
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app
COPY . /app
RUN chown -R appuser:appgroup /app

ENV FLASK_APP=run.py \
    FLASK_RUN_HOST=0.0.0.0 \
    FLASK_RUN_PORT=5000 \
    PYTHONUNBUFFERED=1

WORKDIR /app

USER appuser

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:${FLASK_RUN_PORT} || exit 1

EXPOSE ${FLASK_RUN_PORT}

CMD flask run --host=$FLASK_RUN_HOST --port=$FLASK_RUN_PORT

