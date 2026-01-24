# ============================================================================
# CROACIA MVP - Multi-Stage Dockerfile with Compile-Time Secrets
# ============================================================================
# Stage 1: Build with SERPER_API_KEY injected at compile-time
# Stage 2: Minimal runtime with Python for Cloudscraper fallback
# ============================================================================

# ============================================================================
# STAGE 1: Build
# ============================================================================
FROM nimlang/nim:2.2.6-alpine-regular AS builder

# Install build dependencies (SSL, Python, Pip)
RUN apk add --no-cache \
    openssl-dev \
    openssl-libs-static \
    ca-certificates \
    python3 \
    py3-pip

WORKDIR /app

# Accept build-time secret from Fly.io
ARG SERPER_API_KEY
ENV SERPER_API_KEY=${SERPER_API_KEY}

# Copy Nim dependencies first for Docker layer caching
COPY *.nimble ./
RUN nimble install -y --depsOnly

# Copy application source code
COPY . .

# Create build directory
RUN mkdir -p /app/build

# Compile binary with compile-time secrets embedded
# The staticExec("echo $SERPER_API_KEY") in scraper.nim will read this
RUN nim c \
    -d:release \
    --opt:speed \
    -d:ssl \
    --passL:"-L/usr/lib -lssl -lcrypto" \
    -o:build/croacia_mvp \
    src/core/croacia_mvp.nim

# ============================================================================
# STAGE 2: Runtime
# ============================================================================
FROM alpine:latest

# Install runtime dependencies only (SSL libs, Python, CA certs)
RUN apk add --no-cache \
    libssl3 \
    ca-certificates \
    python3 \
    py3-pip

WORKDIR /app

# Install Cloudscraper for Cloudflare bypass fallback
RUN pip install cloudscraper --break-system-packages

# Copy compiled binary from builder stage
COPY --from=builder /app/build/croacia_mvp /app/croacia_mvp

# Expose Jester port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

# Run application
CMD ["./croacia_mvp"]
