FROM nimlang/nim:latest

WORKDIR /app

COPY . .

RUN nimble install -y

EXPOSE 8080

CMD ["nim", "c", "-r", "src/main.nim"]
# =============================================================================
# Dockerfile - Otimizado para Fly.io
# =============================================================================
# ✅ Multi-stage build para reduzir tamanho
# ✅ Python 3.11 slim + Nim compilado
# ✅ Cloudscraper pré-instalado
# ✅ Health checks integrados
# ✅ Otimizado para warm-starts em Fly.io
# =============================================================================

# ---- ESTÁGIO 1: Builder ----
FROM nimlang/nim:latest as builder

WORKDIR /build

# Copiar apenas os arquivos necessários de build
COPY croacia.nimble .
COPY src/ src/

# Instalar dependências Nim
RUN nimble install -y

# Compilar para release (otimizado)
RUN nim c \
  -d:release \
  -d:ssl \
  -d:useGcc \
  --passL:"-static" \
  --gc:arc \
  -o:croacia_app \
  src/core/main.nim

# ---- ESTÁGIO 2: Runtime ----
FROM python:3.11-slim

WORKDIR /app

# Instalar dependências do sistema (mínimo necessário)
RUN apt-get update && apt-get install -y \
  ca-certificates \
  curl \
  && rm -rf /var/lib/apt/lists/*

# Instalar Cloudscraper
RUN pip install --no-cache-dir cloudscraper

# Copiar binário compilado do builder
COPY --from=builder /build/croacia_app /app/

# Copiar arquivos de config
COPY config/.env.example /app/.env

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# Exposição de porta
EXPOSE 8080

# Variáveis de ambiente padrão
ENV PORT=8080 \
    BIND_ADDR=0.0.0.0 \
    LOG_LEVEL=INFO

# Executar aplicação
CMD ["/app/croacia_app"]