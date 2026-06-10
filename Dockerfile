# ============================================================
# Activity Recognition System — Production Dockerfile
# Multi-stage build for optimized image size
# ============================================================
ARG PYTHON_VERSION=3.11
ARG CUDA_VERSION=11.8.0
ARG UBUNTU_VERSION=22.04

# ---- Stage 1: Base with CUDA ----
FROM nvidia/cuda:${CUDA_VERSION}-cudnn8-runtime-ubuntu${UBUNTU_VERSION} AS base

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PIP_NO_CACHE_DIR=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.11 \
    python3.11-dev \
    python3-pip \
    python3.11-venv \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    libgstreamer1.0-0 \
    gstreamer1.0-plugins-base \
    ffmpeg \
    libpq-dev \
    curl \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set Python 3.11 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1 \
    && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

# Create non-root user
RUN groupadd -r arsuser && useradd -r -g arsuser -d /app -s /bin/bash arsuser

# ---- Stage 2: Builder (install Python deps) ----
FROM base AS builder

WORKDIR /build

# Copy requirements first for layer caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip setuptools wheel \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install torch torchvision --index-url https://download.pytorch.org/whl/cu118

# ---- Stage 3: Development ----
FROM builder AS development

WORKDIR /app

COPY . .

RUN pip install -e ".[dev]"

USER arsuser

EXPOSE 8000 8501 5000

CMD ["uvicorn", "src.api.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]

# ---- Stage 4: Production ----
FROM base AS production

WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /usr/local/lib/python3.11/dist-packages /usr/local/lib/python3.11/dist-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy application code
COPY src/ ./src/
COPY configs/ ./configs/
COPY scripts/ ./scripts/
COPY setup.py .
COPY pyproject.toml .

# Create necessary directories
RUN mkdir -p logs uploads models/weights data/processed \
    && chown -R arsuser:arsuser /app

USER arsuser

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

EXPOSE 8000

ENV APP_ENV=production
ENV LOG_LEVEL=INFO

CMD ["uvicorn", "src.api.main:app", \
    "--host", "0.0.0.0", \
    "--port", "8000", \
    "--workers", "4", \
    "--worker-class", "uvicorn.workers.UvicornWorker", \
    "--access-log", \
    "--log-level", "info"]

# ---- Stage 5: CPU-only (lighter) ----
FROM python:3.11-slim AS cpu-only

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1-mesa-glx \
    libglib2.0-0 \
    ffmpeg \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -r arsuser && useradd -r -g arsuser -d /app -s /bin/bash arsuser

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
    && pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu

COPY src/ ./src/
COPY configs/ ./configs/
COPY setup.py .

RUN mkdir -p logs uploads models/weights \
    && chown -R arsuser:arsuser /app

USER arsuser

HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

EXPOSE 8000

CMD ["uvicorn", "src.api.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "2"]
