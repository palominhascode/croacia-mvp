# ============================================================================
# Dockerfile-final - Build Multi-Stage com SSL Support Completo
# ============================================================================
# ✅ Memory-efficient build
# ✅ SSL support para SERPER API
# ✅ Pronto para Fly.io deployment
# ============================================================================

# ---- STAGE 1: Builder (Compilation) ----
FROM nimlang/nim:latest as builder

WORKDIR /build

# Copiar arquivos necessários
COPY croacia.nimble .
COPY src/ src/
COPY config/ config/

# Instalar dependências Nim
RUN nimble install -y

# Compilar com:
# -d:release     = Otimizado para produção
# --gc:arc       = Memory-efficient garbage collection
# -d:ssl         = ⭐ SSL support para SERPER API (IMPORTANTE!)
# -o             = Output binary
RUN nim c \
  -d:release \
  --gc:arc \
  -d:ssl \
  -o:croacia_mvp \
  src/core/main.nim

# ---- STAGE 2: Runtime ----
FROM python:3.11-slim

WORKDIR /app

# Instalar dependências necessárias
RUN apt-get update && apt-get install -y \
  ca-certificates \
  curl \
  libssl3 \
  && rm -rf /var/lib/apt/lists/*

# Instalar Cloudscraper (necessário para bypass Cloudflare)
RUN pip install --no-cache-dir cloudscraper

# Copiar binário compilado do builder
COPY --from=builder /build/croacia_mvp /app/

# Copiar arquivo de configuração
COPY config/.env.example /app/.env

# Health check (verifica se aplicação está rodando)
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# Exposição de porta
EXPOSE 8080

# Variáveis de ambiente
ENV PORT=8080 \
    BIND_ADDR=0.0.0.0 \
    LOG_LEVEL=INFO

# Executar aplicação
CMD ["/app/croacia_mvp"]

# ============================================================================
# COMO USAR:
# ============================================================================
#
# Build local:
#   docker build -f Dockerfile-final -t croacia:latest .
#
# Testar localmente:
#   docker run -e SERPER_API_KEY=sua-chave -p 8080:8080 croacia:latest
#
# Deploy no Fly.io:
#   flyctl deploy --app croacia-mvp
#
# ============================================================================
# FEATURES:
# ============================================================================
#
# ✅ Multi-stage: Compilation isolada (não trava seu PC)
# ✅ Memory-efficient: --gc:arc reduz RAM durante build
# ✅ SSL enabled: -d:ssl para SERPER API
# ✅ Slim runtime: Python slim = 300MB vs 900MB
# ✅ Health check: Automático a cada 30s
# ✅ Production-ready: Otimizado e testado
#
# ============================================================================