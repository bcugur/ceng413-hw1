# HW-1 Dockerfile (Python / Flask)
# Pinned, small base image: same result every time, smaller image.
FROM python:3.12-slim

WORKDIR /app

# Dependencies first: this layer is cached until requirements.txt changes.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Application code last: it changes most often.
COPY . .

# Unprivileged user + a data folder it may write to (for /visit).
RUN useradd --create-home --uid 10001 appuser \
    && mkdir -p /data \
    && chown appuser:appuser /data
USER appuser

# Configuration comes from environment variables (can be overridden with -e).
ENV DATA_DIR=/data \
    APP_GREETING=Hello

EXPOSE 8000

# Bonus: Docker checks /health every 30 seconds.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

CMD ["gunicorn", "-b", "0.0.0.0:8000", "app:app"]
