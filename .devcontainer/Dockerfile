# Custom Dockerfile to install system dependencies (e.g., for psycopg2).
FROM mcr.microsoft.com/devcontainers/python:3.11

# Install system dependencies for PostgreSQL client and other build tools
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Set up working directory
WORKDIR /workspace
