# ESTÁGIO 1: Compilação (Build)
FROM nimlang/nim:2.2.6-alpine-regular AS builder

# Instalar dependências de build do Nim (SSL estático), Python e Pip
RUN apk add --no-cache openssl-dev openssl-libs-static ca-certificates python3 py3-pip

WORKDIR /app

# Instalar a lib Python necessaria com a flag de sobrescrita
RUN pip install cloudscraper --break-system-packages

# Copiar arquivos de dependência do Nim primeiro para cache
COPY *.nimble ./
RUN nimble install -y --depsOnly

# Copiar o resto do código e o config.nims
COPY . .

# Compilar o binário em modo release (o config.nims adiciona -d:ssl)
RUN nimble build -d:release --opt:speed -y

# ESTÁGIO 2: Execução (Runtime) - Imagem mínima
FROM alpine:latest

# Instalar apenas o necessário para rodar (Runtime libs, Certificados e Python)
RUN apk add --no-cache libssl3 ca-certificates python3 py3-pip

WORKDIR /app

# Instalar a biblioteca Python necessária novamente no runtime final com a flag de sobrescrita
RUN pip install cloudscraper --break-system-packages

# Copiar apenas o binário gerado no estágio anterior
COPY --from=builder /app/build/croacia_mvp /app/croacia_mvp

# Expor a porta que o Jester utiliza
EXPOSE 8080

# Executar a aplicação
CMD ["./croacia_mvp"]
