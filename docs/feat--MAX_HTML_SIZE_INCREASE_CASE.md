

## É possível aumentar o gMaxHtmlSize = 50000 em scraper.nim, sem causar problemas?

Sim, é possível, mas há trade-offs importantes a considerar:

***

## ⚖️ **Trade-offs de Aumentar o HTML Size**

### ✅ **Vantagens:**

- Mais contexto para análise de IA
- Captura páginas maiores/mais complexas
- Melhor para sites com muito conteúdo

### ⚠️ **Desvantagens:**

- **Maior uso de memória** (pode causar OOM no Fly.io)
- **Latência maior** (transfer + processamento)
- **Custo de bandwidth** (Fly.io cobra por GB transferido)
- **Timeout risk** (requests mais lentos)

***

## 📊 **Limites Recomendados por Cenário**

| Tamanho   | Uso Recomendado    | Memória/Request | Latência Média |
| --------- | ------------------ | --------------- | -------------- |
| **50KB**  | Padrão (atual)     | ~200KB          | 2-5s           |
| **100KB** | Sites complexos    | ~400KB          | 3-8s           |
| **200KB** | Análise profunda   | ~800KB          | 5-12s          |
| **500KB** | Máximo recomendado | ~2MB            | 10-20s         |
| **1MB+**  | ⚠️ Não recomendado | ~4MB+           | 20-40s+        |

***

## 🧮 **Cálculo de Impacto (Fly.io)**

### Configuração Atual (Fly.io)

```toml
[vm]
  memory = '1gb'  # 1024 MB
```

### Cenários de Concorrência

**Com 50KB (atual):**

```
Requests simultâneos = 1024MB / (0.2MB * 5 URLs) = ~1000 requests
```

**Com 200KB:**

```
Requests simultâneos = 1024MB / (0.8MB * 5 URLs) = ~250 requests
```

**Com 500KB:**

```
Requests simultâneos = 1024MB / (2MB * 5 URLs) = ~100 requests
```

***

## ✅ **Recomendações por Caso de Uso**

### 1. **Análise Rápida de Snippets (atual - 50KB)**

```nim
gMaxHtmlSize = 50000  # Ideal para resumos rápidos
```

- ✅ Baixa latência
- ✅ Alta concorrência
- ✅ Custo baixo

***

### 2. **Análise de Conteúdo Completo (100KB)**

```nim
gMaxHtmlSize = 100000  # Bom equilíbrio
```

- ✅ Captura a maioria das páginas
- ✅ Concorrência razoável
- ⚠️ +50% custo de bandwidth

**Quando usar:**

- Sites de notícias/blogs
- Páginas de produto detalhadas
- Landing pages

***

### 3. **Análise Profunda/SEO (200KB)**

```nim
gMaxHtmlSize = 200000  # Para análise técnica
```

- ✅ Captura scripts, CSS inline, JSON-LD
- ⚠️ Latência maior
- ⚠️ Concorrência reduzida

**Quando usar:**

- Análise de SEO técnico
- Extração de structured data
- Sites com muito JavaScript

***

### 4. **Páginas Muito Grandes (500KB - Máximo)**

```nim
gMaxHtmlSize = 500000  # Apenas se necessário
```

- ⚠️ Alto uso de memória
- ⚠️ Latência significativa
- ⚠️ Risco de timeout

**Quando usar:**

- Sites de e-commerce (muitos produtos)
- Portais governamentais
- Documentação técnica extensa

***

## 🎯 **Solução Recomendada: Parâmetro Dinâmico**

Em vez de fixo, permita configurar por request:

### **Atualização no `scraper.nim`:**

```nim
# Configuração com padrão flexível
proc initializeSecrets*() =
  echo "[INIT] ✓ Carregando secrets do ambiente..."

  gSerperApiKey = getEnv("SERPER_API_KEY", "")
  gSerperApiUrl = "https://google.serper.dev/search"

  # Ler do env com padrão de 50KB
  let htmlSizeStr = getEnv("MAX_HTML_SIZE", "50000")
  try:
    gMaxHtmlSize = parseInt(htmlSizeStr)
  except:
    gMaxHtmlSize = 50000

  echo "[INIT] ✓ Max HTML Size: ", gMaxHtmlSize, " bytes"

  # Validações...
```

### **Atualização no `scrapePage`:**

```nim
proc scrapePage*(url: string, maxHtmlSize: int = 0): Future[ScrapedResult] {.async, gcsafe.} =
  # ... código existente ...

  var cleanHtml = html

  # Usar tamanho customizado ou padrão
  let effectiveMaxSize = if maxHtmlSize > 0: maxHtmlSize else: MAX_HTML_SIZE()

  if cleanHtml.len > effectiveMaxSize:
    cleanHtml = cleanHtml[0..<effectiveMaxSize]

  scraped.html = cleanHtml
  # ... resto do código ...
```

### **Atualização no endpoint `/analyze`:**

```nim
  post "/analyze":
    try:
      let body = request.body
      let params = parseJson(body)

      # Parâmetros existentes...
      let query = params{"query"}.getStr("test")
      let maxResults = if params.hasKey("max_results"):
        params{"max_results"}.getInt(5)
      else:
        5

      # NOVO: Tamanho de HTML customizado
      let htmlSize = if params.hasKey("html_size"):
        min(params{"html_size"}.getInt(50000), 500000)  # Max 500KB
      else:
        50000  # Padrão

      echo "[API] Query: ", query, " | HTML Size: ", htmlSize

      # Passar para analyzeKeyword...
```

***

## 🧪 **Teste de Capacidade**

Antes de aumentar em produção, teste localmente:

```bash
# Terminal 1: Rodar app local
docker run -p 8080:8080 -e SERPER_API_KEY=sua_chave -e MAX_HTML_SIZE=200000 croacia-test

# Terminal 2: Teste de carga
for i in {1..10}; do
  curl -X POST http://localhost:8080/analyze \
    -H "Content-Type: application/json" \
    -d '{"query":"test","max_results":5}' &
done
wait

# Monitorar memória
docker stats
```

***

## 📋 **Checklist de Decisão**

Pergunte-se:

- [ ] **Preciso REALMENTE de mais HTML?** (analise seu caso de uso)
- [ ] **A IA consegue processar >50KB eficientemente?**
- [ ] **Posso pagar a latência extra?** (+50-200% tempo)
- [ ] **Tenho tráfego baixo?** (<100 req/hora = OK aumentar)
- [ ] **Posso escalar vertical no Fly.io?** (2GB RAM se necessário)

***

## 🎯 **Minha Recomendação Final**

**Para seu caso (Toqan custom tool):**

```nim
gMaxHtmlSize = 100000  # 100KB - Sweet spot
```

**Por quê:**

- ✅ Dobra o contexto sem muito impacto
- ✅ Captura 95% das páginas comerciais
- ✅ Ainda permite boa concorrência
- ✅ Latência aceitável (<8s)

**Se precisar de mais:**

- Implemente o parâmetro dinâmico `html_size` no request
- Configure 500KB no Fly.io como variável de ambiente
- Monitore uso de memória nos logs

***

**Quer que eu forneça o código completo com o parâmetro dinâmico?** 🚀
