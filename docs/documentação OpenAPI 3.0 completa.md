Perfeito! Vou criar a documentação OpenAPI 3.0 completa para a Croacia MVP API! 🚀

***

## 📄 **`docs/openapi.yaml` - Documentação Oficial OpenAPI 3.0**

```yaml
openapi: 3.0.3
info:
  title: Croacia MVP API
  description: |
    **RESTful API de Competitive Intelligence com Web Scraping e Geo-targeting**

    A Croacia MVP API permite analisar palavras-chave e extrair conteúdo estruturado de páginas web,
    incluindo HTML completo, títulos, snippets e metadados. Suporta geolocalização por país e
    possui fallback automático para sites protegidos por Cloudflare.

    ## Características

    - 🌍 **Geo-targeting:** Resultados específicos por país (ISO 3166-1)
    - 🔒 **Cloudflare Bypass:** Fallback automático com Cloudscraper
    - 📄 **HTML Completo:** Até 50KB de conteúdo por página
    - ⚡ **Stateless:** Escalável horizontalmente
    - 🚀 **Performance:** Resposta em 2-15 segundos

    ## Casos de Uso

    - Análise de competidores
    - SEO e pesquisa de mercado
    - Extração de conteúdo para IA
    - Monitoramento de páginas web

    ## Limitações

    - Timeout: 60 segundos por request
    - HTML máximo: 50KB por página (configurável até 500KB)
    - Rate limit: Controlado pelo plano Serper API
    - Máximo de 10 resultados por query

  version: 1.0.0
  contact:
    name: Croacia MVP Team
    email: support@croacia-mvp.example.com
  license:
    name: MIT
    url: https://opensource.org/licenses/MIT

servers:
  - url: https://croacia-mvp.fly.dev
    description: Production server (Fly.io - GRU region)
  - url: http://localhost:8080
    description: Local development server

tags:
  - name: Health
    description: Health check e status da API
  - name: Analysis
    description: Análise de palavras-chave e web scraping

paths:
  /:
    get:
      summary: API Info
      description: Retorna informações básicas sobre a API
      tags:
        - Health
      responses:
        '200':
          description: Informações da API
          content:
            text/plain:
              schema:
                type: string
                example: "🚀 Croacia MVP - Competitive Intelligence API (Stateless + Geo-targeted)"

  /health:
    get:
      summary: Health Check
      description: Verifica o status e disponibilidade da API
      tags:
        - Health
      responses:
        '200':
          description: API está operacional
          content:
            application/json:
              schema:
                type: object
                properties:
                  status:
                    type: string
                    enum: [ok, error]
                    description: Status geral da API
                    example: ok
                  timestamp:
                    type: integer
                    format: int64
                    description: Unix timestamp da resposta
                    example: 1737849600
                  mode:
                    type: string
                    description: Modo de operação
                    example: stateless
                  geo_targeting:
                    type: boolean
                    description: Se geo-targeting está habilitado
                    example: true
                  gc_safe:
                    type: boolean
                    description: Se a API é GC-safe (garbage collection)
                    example: true
              examples:
                success:
                  summary: API saudável
                  value:
                    status: ok
                    timestamp: 1737849600
                    mode: stateless
                    geo_targeting: true
                    gc_safe: true

  /analyze:
    post:
      summary: Analyze Keyword
      description: |
        Analisa uma palavra-chave e retorna resultados estruturados com HTML completo.

        A API busca URLs relevantes usando a Serper API (Google Search) e extrai
        conteúdo de cada página, incluindo título, snippet e HTML completo.

        **Processo:**
        1. Busca URLs via Serper API (baseado em país/idioma)
        2. Scraping de cada URL (HTTP → Cloudscraper fallback)
        3. Extração de título, snippet e HTML
        4. Retorno em formato JSON estruturado

        **Timeout:** 60 segundos máximo
      tags:
        - Analysis
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required:
                - query
              properties:
                query:
                  type: string
                  description: Palavra-chave ou termo de busca
                  minLength: 1
                  maxLength: 500
                  example: "software CRM"
                max_results:
                  type: integer
                  description: Número máximo de resultados a retornar
                  minimum: 1
                  maximum: 10
                  default: 5
                  example: 5
                country:
                  type: string
                  description: Código ISO 3166-1 do país (2 letras)
                  minLength: 2
                  maxLength: 2
                  pattern: "^[a-z]{2}$"
                  default: "br"
                  example: "br"
                language:
                  type: string
                  description: |
                    Código de idioma BCP 47 (opcional).
                    Se não especificado, será detectado automaticamente baseado no país.
                  pattern: "^[a-z]{2}(-[A-Z]{2})?$"
                  example: "pt-BR"
                html_size:
                  type: integer
                  description: Tamanho máximo do HTML em bytes (opcional)
                  minimum: 1000
                  maximum: 500000
                  default: 50000
                  example: 100000
            examples:
              basic:
                summary: Busca básica (Brasil)
                value:
                  query: "cafeterias"
                  max_results: 5

              custom_country:
                summary: País específico (EUA)
                value:
                  query: "coffee shops"
                  country: "us"
                  max_results: 3

              full_options:
                summary: Todas as opções
                value:
                  query: "software CRM"
                  country: "br"
                  language: "pt-BR"
                  max_results: 10
                  html_size: 200000

      responses:
        '200':
          description: Análise concluída com sucesso
          content:
            application/json:
              schema:
                type: object
                properties:
                  status:
                    type: string
                    enum: [success, error]
                    description: Status da operação
                  query:
                    type: string
                    description: Query enviada
                  country:
                    type: string
                    description: Código do país usado
                  language:
                    type: string
                    description: Idioma detectado/usado
                  total:
                    type: integer
                    description: Número total de resultados retornados
                  results:
                    type: array
                    description: Lista de resultados extraídos
                    items:
                      type: object
                      properties:
                        url:
                          type: string
                          format: uri
                          description: URL da página analisada
                          maxLength: 2000
                        title:
                          type: string
                          description: Título extraído da página
                          maxLength: 500
                        snippet:
                          type: string
                          description: Snippet de texto extraído (primeiros 300 caracteres)
                          maxLength: 1000
                        html:
                          type: string
                          description: Conteúdo HTML completo da página
                          maxLength: 500000
                        status:
                          type: string
                          enum: [success, error, empty_response]
                          description: Status do scraping desta URL
                        error:
                          type: string
                          description: Mensagem de erro (se status != success)
                        html_size:
                          type: integer
                          description: Tamanho do HTML em bytes
                        timestamp:
                          type: integer
                          format: int64
                          description: Unix timestamp da extração
              examples:
                success:
                  summary: Resposta de sucesso
                  value:
                    status: success
                    query: "software CRM"
                    country: "br"
                    language: "pt-BR"
                    total: 3
                    results:
                      - url: "https://www.exemplo.com.br/crm"
                        title: "Melhor Software CRM do Brasil"
                        snippet: "Descubra o melhor CRM para sua empresa. Gestão de vendas, automação de marketing..."
                        html: "<!DOCTYPE html><html><head><title>Melhor Software CRM</title>...</html>"
                        status: "success"
                        html_size: 45230
                        timestamp: 1737849600
                      - url: "https://www.crm-brasil.com"
                        title: "CRM Brasil - Soluções em Nuvem"
                        snippet: "Sistema de CRM completo para pequenas e médias empresas..."
                        html: "<!DOCTYPE html><html>..."
                        status: "success"
                        html_size: 38910
                        timestamp: 1737849601
                      - url: "https://www.vendas-crm.com.br"
                        title: "Vendas CRM - Automatize sua equipe"
                        snippet: "Aumente suas vendas com nosso CRM inteligente..."
                        html: "<!DOCTYPE html>..."
                        status: "success"
                        html_size: 50000
                        timestamp: 1737849602

                no_results:
                  summary: Nenhum resultado encontrado
                  value:
                    status: success
                    query: "palavra-chave-inexistente-xyz"
                    country: "br"
                    language: "pt-BR"
                    total: 0
                    results: []

        '400':
          description: Request inválido
          content:
            application/json:
              schema:
                type: object
                properties:
                  status:
                    type: string
                    enum: [error]
                  error:
                    type: string
                    description: Mensagem de erro
              examples:
                missing_query:
                  summary: Query ausente
                  value:
                    status: error
                    error: "Query parameter is required"

                invalid_country:
                  summary: Código de país inválido
                  value:
                    status: error
                    error: "Invalid country code. Must be 2-letter ISO 3166-1 code"

        '500':
          description: Erro interno do servidor
          content:
            application/json:
              schema:
                type: object
                properties:
                  status:
                    type: string
                    enum: [error]
                  error:
                    type: string
              examples:
                internal_error:
                  summary: Erro interno
                  value:
                    status: error
                    error: "Internal server error: timeout fetching URLs"

components:
  schemas:
    HealthResponse:
      type: object
      properties:
        status:
          type: string
        timestamp:
          type: integer
          format: int64
        mode:
          type: string
        geo_targeting:
          type: boolean
        gc_safe:
          type: boolean

    AnalyzeRequest:
      type: object
      required:
        - query
      properties:
        query:
          type: string
        max_results:
          type: integer
        country:
          type: string
        language:
          type: string
        html_size:
          type: integer

    AnalyzeResponse:
      type: object
      properties:
        status:
          type: string
        query:
          type: string
        country:
          type: string
        language:
          type: string
        total:
          type: integer
        results:
          type: array
          items:
            $ref: '#/components/schemas/ScrapedResult'

    ScrapedResult:
      type: object
      properties:
        url:
          type: string
          format: uri
        title:
          type: string
        snippet:
          type: string
        html:
          type: string
        status:
          type: string
        error:
          type: string
        html_size:
          type: integer
        timestamp:
          type: integer
          format: int64

    ErrorResponse:
      type: object
      properties:
        status:
          type: string
          enum: [error]
        error:
          type: string

  examples:
    BrasilCafeterias:
      summary: Cafeterias no Brasil
      value:
        query: "cafeterias"
        country: "br"
        max_results: 5

    USACoffeeShops:
      summary: Coffee shops nos EUA
      value:
        query: "coffee shops"
        country: "us"
        max_results: 3

    MultiplePaises:
      summary: Software CRM - Comparação de mercados
      description: Exemplo de como buscar em múltiplos países
      value:
        - query: "software CRM"
          country: "br"
        - query: "CRM software"
          country: "us"
        - query: "software CRM"
          country: "pt"

externalDocs:
  description: Documentação completa e guias
  url: https://github.com/croacia-mvp/docs
```

***

## 📄 **`docs/openapi.json` - Versão JSON**

Para ferramentas que preferem JSON:

```bash
# Converter YAML para JSON
npm install -g yaml-cli
yaml2json docs/openapi.yaml > docs/openapi.json
```

Ou crie manualmente:

```json
{
  "openapi": "3.0.3",
  "info": {
    "title": "Croacia MVP API",
    "description": "RESTful API de Competitive Intelligence com Web Scraping e Geo-targeting",
    "version": "1.0.0",
    "contact": {
      "name": "Croacia MVP Team"
    },
    "license": {
      "name": "MIT"
    }
  },
  "servers": [
    {
      "url": "https://croacia-mvp.fly.dev",
      "description": "Production server"
    }
  ],
  "paths": {
    "/health": {
      "get": {
        "summary": "Health Check",
        "responses": {
          "200": {
            "description": "API is healthy",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "status": { "type": "string" },
                    "timestamp": { "type": "integer" }
                  }
                }
              }
            }
          }
        }
      }
    },
    "/analyze": {
      "post": {
        "summary": "Analyze Keyword",
        "requestBody": {
          "required": true,
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "required": ["query"],
                "properties": {
                  "query": { "type": "string" },
                  "max_results": { "type": "integer", "default": 5 },
                  "country": { "type": "string", "default": "br" }
                }
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "Analysis successful",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "status": { "type": "string" },
                    "total": { "type": "integer" },
                    "results": { "type": "array" }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
```

***

## 🌐 **Visualizadores Swagger/OpenAPI**

### **1. Swagger UI Online**

```
https://editor.swagger.io/
```

Cole o conteúdo do `openapi.yaml` lá.

### **2. Redoc (mais bonito)**

```
https://redocly.github.io/redoc/
```

### **3. Self-hosted (Docker)**

```bash
docker run -p 8081:8080 -e SWAGGER_JSON=/openapi.yaml \
  -v $(pwd)/docs/openapi.yaml:/openapi.yaml \
  swaggerapi/swagger-ui
```

Acesse: `http://localhost:8081`

***

## 📦 **Salvar no Projeto**

```bash
# Criar diretório
mkdir -p docs

# Salvar OpenAPI
cat > docs/openapi.yaml << 'EOF'
[cole o conteúdo YAML acima]
EOF

# Commit
git add docs/openapi.yaml
git commit -m "docs: add OpenAPI 3.0 specification"
git push
```

***

## 🚀 **Usar no README**

Atualize o README.md:

```markdown
## 📚 API Documentation

- **OpenAPI Spec:** [docs/openapi.yaml](./docs/openapi.yaml)
- **Swagger UI:** [View in Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/seu-usuario/croacia-mvp/main/docs/openapi.yaml)
- **Postman:** Import `docs/openapi.yaml` into Postman

### Quick Links
- 🔗 Base URL: `https://croacia-mvp.fly.dev`
- 📄 Health Check: `GET /health`
- 🔍 Analyze: `POST /analyze`
```

***

**Pronto! Agora você tem uma documentação OpenAPI 3.0 completa e profissional!** 📚✨🚀

Quer que eu crie também:

- [ ] Postman Collection?
- [ ] Client SDKs (Python/JavaScript)?
- [ ] AsyncAPI spec (para webhooks futuros)?
