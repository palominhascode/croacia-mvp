# 🔍 Croácia MVP

**Web Scraper inteligente em Nim com integração SERPER API**

---

## 📋 Resumo

Aplicação stateless que busca, analisa e estrutura dados da web usando a SERPER API.
Implementada em **Nim**.

**Status**: Em desenvolvimento | **Deploy**: Fly.io | **Build**: 20-30 segundos

---

## 🚀 Início Rápido

### 1. Compilar
```bash
rm -rf nimcache/
nim c -d:release --mm:arc -d:ssl -o:build/croacia_mvp src/core/main.nim
```

### 2. Executar
```bash
./build/croacia_mvp
```

### 3. Testar
```bash
# Health check
curl http://localhost:8080/health

# Análise
curl -X POST http://localhost:8080/analyze \
  -H "Content-Type: application/json" \
  -d '{"query": "sua busca aqui"}'
```

---

## 📦 Deployment

### Docker (Recomendado)
```bash
docker build -f Dockerfile-final -t croacia:latest .
docker run -e SERPER_API_KEY=sua-chave -p 8080:8080 croacia:latest
```

### Fly.io
```bash
flyctl secrets set SERPER_API_KEY=sua-chave --app croacia-mvp
flyctl deploy --app croacia-mvp
```

---

## 🔌 Endpoints da API

### `GET /health`
Verifica o status da aplicação.

**Resposta**:
```json
{
  "status": "ok",
  "timestamp": 1769081659,
  "mode": "stateless",
  "gc_safe": true
}
```

### `POST /analyze`
Analisa a query e retorna resultados da SERPER.

**Requisição**:
```json
{
  "query": "string",
  "max_results": 5
}
```

**Resposta**:
```json
{
  "query": "string",
  "results": [
    {
      "title": "string",
      "url": "string",
      "snippet": "string"
    }
  ],
  "count": 5
}
```

---

## 🛠️ Stack Tecnológico

| Componente | Tecnologia | Versão |
|-----------|-----------|--------|
| Linguagem | Nim | 2.2.6 |
| Framework Web | Jester | Fork otimizado |
| Cliente HTTP | httpclient (Nim) | Integrado |
| Web Scraping | Cloudscraper | Bridge Python |
| API de Dados | SERPER | REST API |
| Garbage Collector | ARC | Automático |
| Containerização | Docker | Multi-stage |

---

## 📊 Especificações

- **Stateless**: Sem cache ou estado persistente
- **Assíncrono**: Operações não-bloqueantes
- **Memory-safe**: GC automático com ARC
- **Thread-safe**: 8 threads por padrão
- **SSL/TLS**: HTTPS habilitado
- **Tamanho do binary**: ~60MB
- **Tempo de startup**: <1s
- **Tempo de build**: 10s

---

## 🔐 Configuração

### Variáveis de Ambiente

```bash
PORT=8080                    # Porta do servidor
BIND_ADDR=0.0.0.0           # Endereço de bind
SERPER_API_KEY=xxx          # Chave SERPER (obrigatória)
LOG_LEVEL=INFO              # Nível de log
```

### Secrets (Fly.io)

```bash
flyctl secrets set SERPER_API_KEY=sua-chave --app croacia-mvp
```

---

## 📁 Estrutura do Projeto

```
croacia-mvp/
├── src/
│   ├── core/
│   │   ├── main.nim          # Ponto de entrada
│   │   ├── scraper.nim       # Lógica de scraping
│   │   └── types.nim         # Definições de tipos
│   └── bridge/
│       └── cloudscraper_bridge.nim  # Bridge Python
├── config/
│   └── .env.example          # Exemplo de configuração
├── build/                    # Diretório de output
├── Dockerfile-final          # Imagem de produção
├── build-safe-final.sh       # Script de build
└── README.md                 # Este arquivo
```

---

## 🔄 Fluxo de Requisição

```
Requisição
  ↓
[Router Jester] → /analyze endpoint
  ↓
[Scraper] → Valida query
  ↓
[SERPER API] → Busca via REST
  ↓
[Response] → Estrutura JSON
  ↓
Cliente
```

---

## ⚙️ Flags de Compilação Explicadas

| Flag | Propósito | Por Quê |
|------|-----------|---------|
| `-d:release` | Otimizações | Performance em produção |
| `--mm:arc` | Gerenciamento de memória | Eficiente durante build |
| `-d:ssl` | Suporte HTTPS | Necessário para SERPER |
| `-o:build/croacia_mvp` | Output | Local do binário |

---

## 🧪 Testes

### Local
```bash
# Inicia servidor
./build/croacia_mvp &

# Testa health
curl http://localhost:8080/health

# Testa análise
curl -X POST http://localhost:8080/analyze \
  -H "Content-Type: application/json" \
  -d '{"query": "teste"}'
```

### Produção (Fly.io)
```bash
# Testa API deployada
curl https://croacia-mvp.fly.dev/health

# Visualiza logs
flyctl logs --app croacia-mvp --follow
```

---

## 📈 Monitoramento

### Dashboard Fly.io
- Métricas em tempo real
- Rastreamento de erros
- Visualizador de logs

### Health Checks
Automáticos a cada 30 segundos no Dockerfile

### Performance
- Startup: <1s
- Requisição: <2s (com SERPER)
- Memória: ~50MB em runtime

---

## 🐛 Troubleshooting

### Build falha
```bash
# Limpa cache e recompila
rm -rf nimcache/
./build-safe-final.sh
```

### Erro SERPER
```bash
# Verifica SERPER_API_KEY
echo $SERPER_API_KEY
```

### Porta já em uso
```bash
# Use porta diferente
PORT=8081 ./build/croacia_mvp
```

---

## 📚 Documentação Completa

Para análise detalhada, consulte:
- `COMANDO_FINAL_CORRETO.md` - Detalhes de build
- `SSL_FIX_FINAL.md` - Configuração SSL
- `DEPLOYMENT_CHECKLIST.md` - Guia de deployment

---

## 📄 Licença

Proprietary - Croácia MVP 2026

---

## 👥 Suporte

Documentação técnica completa incluída.

**Comando rápido**:
```bash
nim c -d:release --mm:arc -d:ssl -o:build/croacia_mvp src/core/main.nim
```

---

**Status**: ✅ Pronto para Produção  
**Build**: ✅ 0 Erros  
**Deploy**: ✅ Pronto  
**Atualizado**: Janeiro 2026
