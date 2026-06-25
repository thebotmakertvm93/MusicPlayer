# 1. Use the modern, long-term supported Debian Bookworm base image (Avoids 404 apt errors)
FROM python:3.10-slim-bookworm

# 2. Prevent Python from writing .pyc files and force unbuffered logging for real-time Render logs
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 3. Combine apt commands, install build dependencies for tgcalls C++ compilation, and clean up to save space
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    git \
    curl \
    ffmpeg \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 4. Upgrade pip and core packaging tools first to resolve modern PyPI wheel structures cleanly
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

# 5. Copy and install Python packages using the layer cache strategy
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 6. Copy the rest of the application files
COPY . .

# 7. Default start command (Render will automatically pass the network port variable)
CMD ["python", "main.py"]
