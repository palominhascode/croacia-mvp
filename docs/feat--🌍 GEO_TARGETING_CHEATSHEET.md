## 📄 **`docs/GEO_TARGETING_CHEATSHEET.md`**

```markdown
# 🌍 Geo-Targeting API - Cheat Sheet

> **Croacia MVP - Competitive Intelligence API**  
> Referência rápida para usar geolocalização por país e idioma

---

## 🚀 Quick Start

### Request Básico (Brasil - padrão)
```bash
curl -X POST https://croacia-mvp.fly.dev/analyze \
  -H "Content-Type: application/json" \
  -d '{"query":"cafeterias","max_results":5}'
```

### Request com País Específico

```bash
curl -X POST https://croacia-mvp.fly.dev/analyze \
  -H "Content-Type: application/json" \
  -d '{"query":"coffee shops","max_results":5,"country":"us"}'
```

### Request com País + Idioma Customizado

```bash
curl -X POST https://croacia-mvp.fly.dev/analyze \
  -H "Content-Type: application/json" \
  -d '{"query":"cafés","max_results":5,"country":"pt","language":"pt-PT"}'
```

---

## 📊 Parâmetros da API

| Parâmetro     | Tipo     | Obrigatório | Padrão | Descrição                     |
| ------------- | -------- | ----------- | ------ | ----------------------------- |
| `query`       | `string` | ✅ Sim       | -      | Palavra-chave a buscar        |
| `max_results` | `int`    | ❌ Não       | `5`    | Número de resultados (1-10)   |
| `country`     | `string` | ❌ Não       | `"br"` | Código ISO do país (2 letras) |
| `language`    | `string` | ❌ Não       | Auto   | Idioma (formato BCP 47)       |

---

## 🌎 Países Suportados

### América Latina

| País           | Code | Idioma Auto | Exemplo Query                           |
| -------------- | ---- | ----------- | --------------------------------------- |
| 🇧🇷 Brasil    | `br` | `pt-BR`     | `{"query":"cafeterias","country":"br"}` |
| 🇲🇽 México    | `mx` | `es-MX`     | `{"query":"cafeterías","country":"mx"}` |
| 🇦🇷 Argentina | `ar` | `es-AR`     | `{"query":"cafeterías","country":"ar"}` |
| 🇨🇱 Chile     | `cl` | `es`        | `{"query":"cafeterías","country":"cl"}` |
| 🇨🇴 Colômbia  | `co` | `es`        | `{"query":"cafeterías","country":"co"}` |

### América do Norte

| País        | Code | Idioma Auto | Exemplo Query                             |
| ----------- | ---- | ----------- | ----------------------------------------- |
| 🇺🇸 EUA    | `us` | `en`        | `{"query":"coffee shops","country":"us"}` |
| 🇨🇦 Canadá | `ca` | `en`        | `{"query":"coffee shops","country":"ca"}` |

### Europa

| País             | Code | Idioma Auto | Exemplo Query                             |
| ---------------- | ---- | ----------- | ----------------------------------------- |
| 🇵🇹 Portugal    | `pt` | `pt-PT`     | `{"query":"cafés","country":"pt"}`        |
| 🇪🇸 Espanha     | `es` | `es`        | `{"query":"cafeterías","country":"es"}`   |
| 🇬🇧 Reino Unido | `gb` | `en`        | `{"query":"coffee shops","country":"gb"}` |
| 🇫🇷 França      | `fr` | `fr`        | `{"query":"cafés","country":"fr"}`        |
| 🇩🇪 Alemanha    | `de` | `de`        | `{"query":"Kaffeehäuser","country":"de"}` |
| 🇮🇹 Itália      | `it` | `it`        | `{"query":"caffè","country":"it"}`        |

### Ásia-Pacífico

| País           | Code | Idioma Auto | Exemplo Query                             |
| -------------- | ---- | ----------- | ----------------------------------------- |
| 🇯🇵 Japão     | `jp` | `ja`        | `{"query":"コーヒーショップ","country":"jp"}`     |
| 🇨🇳 China     | `cn` | `zh-CN`     | `{"query":"咖啡店","country":"cn"}`          |
| 🇦🇺 Austrália | `au` | `en`        | `{"query":"coffee shops","country":"au"}` |

---

## 🎯 Response Format

```json
{
  "status": "success",
  "query": "cafeterias",
  "country": "br",
  "language": "pt-BR",
  "total": 5,
  "results": [
    {
      "url": "https://example.com.br",
      "title": "Título da Página",
      "snippet": "Resumo do conteúdo extraído...",
      "html": "<!DOCTYPE html>...",
      "status": "success",
      "html_size": 50000,
      "timestamp": 1737849600
    }
  ]
}
```

---

## 💡 Use Cases

### 1. Análise de Competidores Locais (Brasil)

```bash
curl -X POST https://croacia-mvp.fly.dev/analyze \
  -H "Content-Type: application/json" \
  -d '{
    "query": "software de vendas",
    "max_results": 10,
    "country": "br"
  }'
```

### 2. Pesquisa Multi-Mercado (EUA + Brasil)

```bash
# Mercado EUA
curl -X POST https://croacia-mvp.fly.dev/analyze \
  -H "Content-Type: application/json" \
  -d '{"query":"CRM software","country":"us"}' > usa_results.json

# Mercado Brasil
curl -X POST https://croacia-mvp.fly.dev/analyze \
  -H "Content-Type: application/json" \
  -d '{"query":"software CRM","country":"br"}' > br_results.json
```

### 3. SEO Internacional (Portugal vs Brasil)

```bash
# Portugal (pt-PT)
curl -X POST https://croacia-mvp.fly.dev/analyze \
  -H "Content-Type: application/json" \
  -d '{
    "query": "agências de marketing",
    "country": "pt",
    "language": "pt-PT"
  }'

# Brasil (pt-BR)
curl -X POST https://croacia-mvp.fly.dev/analyze \
  -H "Content-Type: application/json" \
  -d '{
    "query": "agências de marketing",
    "country": "br",
    "language": "pt-BR"
  }'
```

### 4. Idioma Customizado (Canadá - Francês)

```bash
curl -X POST https://croacia-mvp.fly.dev/analyze \
  -H "Content-Type: application/json" \
  -d '{
    "query": "café",
    "country": "ca",
    "language": "fr-CA"
  }'
```

---

## 🐍 Python Examples

### Básico

```python
import requests

response = requests.post(
    "https://croacia-mvp.fly.dev/analyze",
    json={
        "query": "cafeterias",
        "max_results": 5,
        "country": "br"
    }
)

data = response.json()
print(f"Total: {data['total']} resultados")
for result in data['results']:
    print(f"- {result['title']}: {result['url']}")
```

### Multi-País

```python
import requests

countries = ["br", "us", "gb", "pt", "es"]
query = "coffee shops"

results = {}
for country in countries:
    response = requests.post(
        "https://croacia-mvp.fly.dev/analyze",
        json={"query": query, "country": country, "max_results": 3}
    )
    results[country] = response.json()

# Comparar resultados
for country, data in results.items():
    print(f"\n{country.upper()}: {data['total']} resultados")
    for r in data['results']:
        print(f"  - {r['url']}")
```

---

## 🔧 JavaScript/Node.js Examples

### Fetch API

```javascript
const response = await fetch('https://croacia-mvp.fly.dev/analyze', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    query: 'cafeterias',
    max_results: 5,
    country: 'br'
  })
});

const data = await response.json();
console.log(`Total: ${data.total} resultados`);
data.results.forEach(r => {
  console.log(`- ${r.title}: ${r.url}`);
});
```

### Axios

```javascript
const axios = require('axios');

const { data } = await axios.post('https://croacia-mvp.fly.dev/analyze', {
  query: 'software CRM',
  max_results: 10,
  country: 'br',
  language: 'pt-BR'
});

console.log(`País: ${data.country}`);
console.log(`Idioma: ${data.language}`);
console.log(`Total: ${data.total} resultados`);
```

---

## 🧪 Testing Script

Salve como `test_geo_quick.sh`:

```bash
#!/bin/bash
API="https://croacia-mvp.fly.dev/analyze"

# Teste Brasil
echo "🇧🇷 Brasil:"
curl -sX POST $API -H "Content-Type: application/json" \
  -d '{"query":"cafeterias","max_results":2,"country":"br"}' | jq -r '.results[].url'

# Teste EUA
echo -e "\n🇺🇸 EUA:"
curl -sX POST $API -H "Content-Type: application/json" \
  -d '{"query":"coffee shops","max_results":2,"country":"us"}' | jq -r '.results[].url'

# Teste Espanha
echo -e "\n🇪🇸 Espanha:"
curl -sX POST $API -H "Content-Type: application/json" \
  -d '{"query":"cafeterías","max_results":2,"country":"es"}' | jq -r '.results[].url'
```

Executar:

```bash
chmod +x test_geo_quick.sh && ./test_geo_quick.sh
```

---

## 🎨 Formatação de Idiomas (BCP 47)

| Formato | Descrição             | Exemplo             |
| ------- | --------------------- | ------------------- |
| `pt-BR` | Português do Brasil   | Cafeteria, cardápio |
| `pt-PT` | Português de Portugal | Café, ementa        |
| `en`    | Inglês genérico       | Coffee shop         |
| `en-US` | Inglês dos EUA        | Elevator, color     |
| `en-GB` | Inglês britânico      | Lift, colour        |
| `es`    | Espanhol genérico     | Cafetería           |
| `es-MX` | Espanhol mexicano     | Coche               |
| `es-AR` | Espanhol argentino    | Auto                |
| `fr`    | Francês               | Café                |
| `de`    | Alemão                | Kaffeehaus          |

---

## ⚠️ Limitações

- **Max results:** 1-10 por request
- **HTML size:** 50KB por página (limite do scraper)
- **Timeout:** 30s por request
- **Rate limit:** Controlado pelo plano Serper API
- **Cloudflare:** Fallback automático ativado

---

## 🔗 Links Úteis

- **API Endpoint:** `https://croacia-mvp.fly.dev/analyze`
- **Health Check:** `https://croacia-mvp.fly.dev/health`
- **ISO Country Codes:** [Wikipedia](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes)
- **BCP 47 Language Tags:** [IANA Registry](https://www.iana.org/assignments/language-subtag-registry)
- **Serper API Docs:** [serper.dev](https://serper.dev/)

---

## 📝 Notas Técnicas

### Auto-detecção de Idioma

Se `language` não for especificado, a API detecta automaticamente baseado no `country`:

```nim
# Lógica interna (croacia_mvp.nim)
case countryCode
of "br": "pt-BR"
of "pt": "pt-PT"
of "us", "gb", "au", "ca": "en"
of "es": "es"
of "mx": "es-MX"
of "ar": "es-AR"
# ... outros
else: "en"  # fallback
```

### Override Manual

```json
{
  "query": "café",
  "country": "ca",
  "language": "fr-CA"  // Override: Canadá em francês
}
```

---

## 🐛 Troubleshooting

### Erro: "Nenhuma URL encontrada"

**Causa:** Query muito específica ou país sem resultados relevantes  
**Solução:** Tente query mais genérica ou outro país

```bash
# ❌ Muito específico
{"query":"cafeteria rua augusta 123","country":"br"}

# ✅ Melhor
{"query":"cafeteria augusta","country":"br"}
```

### Resultados em idioma errado

**Causa:** Auto-detecção não funciona para caso específico  
**Solução:** Especifique `language` manualmente

```bash
# Force idioma específico
curl -X POST https://croacia-mvp.fly.dev/analyze \
  -d '{"query":"café","country":"ca","language":"fr-CA"}'
```

---

## 📊 Comparação de Mercados (Script Avançado)

Salve como `market_comparison.py`:

```python
import requests
import json

def analyze_market(query, countries):
    """Compara mesma query em múltiplos países"""
    results = {}

    for country in countries:
        response = requests.post(
            "https://croacia-mvp.fly.dev/analyze",
            json={"query": query, "country": country, "max_results": 5}
        )

        if response.status_code == 200:
            data = response.json()
            results[country] = {
                "total": data["total"],
                "language": data["language"],
                "urls": [r["url"] for r in data["results"]]
            }

    return results

# Exemplo: Comparar mercados de CRM
markets = ["br", "us", "gb", "pt", "es"]
comparison = analyze_market("CRM software", markets)

print(json.dumps(comparison, indent=2))
```

Executar:

```bash
python market_comparison.py
```

---

**Versão:** 1.0.0  
**Atualizado:** 2026-01-25  
**Autor:** Croacia MVP Team

```
***

## 💾 **Salvar o Cheat Sheet**

```bash
mkdir -p docs
cat > docs/GEO_TARGETING_CHEATSHEET.md << 'EOF'
[cole o conteúdo acima]
EOF

git add docs/GEO_TARGETING_CHEATSHEET.md
git commit -m "docs: add geo-targeting cheat sheet"
git push
```
