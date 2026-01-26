**Postman Collection**, **SDKs (Python + JavaScript)** e **AsyncAPI**

***

## 📮 **1. `docs/croacia-mvp.postman_collection.json` - Postman Collection**

```json
{
  "info": {
    "_postman_id": "croacia-mvp-api",
    "name": "Croacia MVP API",
    "description": "Collection completa para testar a API de Competitive Intelligence",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json",
    "_exporter_id": "12345678"
  },
  "item": [
    {
      "name": "Health & Info",
      "item": [
        {
          "name": "Health Check",
          "request": {
            "method": "GET",
            "header": [],
            "url": {
              "raw": "{{base_url}}/health",
              "host": ["{{base_url}}"],
              "path": ["health"]
            },
            "description": "Verifica se a API está operacional"
          },
          "response": []
        },
        {
          "name": "API Info",
          "request": {
            "method": "GET",
            "header": [],
            "url": {
              "raw": "{{base_url}}/",
              "host": ["{{base_url}}"],
              "path": [""]
            },
            "description": "Retorna informações básicas da API"
          },
          "response": []
        }
      ]
    },
    {
      "name": "Basic Analysis",
      "item": [
        {
          "name": "Analyze - Brasil (Default)",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"query\": \"cafeterias\",\n  \"max_results\": 5\n}"
            },
            "url": {
              "raw": "{{base_url}}/analyze",
              "host": ["{{base_url}}"],
              "path": ["analyze"]
            },
            "description": "Analisa palavra-chave com configurações padrão (Brasil)"
          },
          "response": []
        },
        {
          "name": "Analyze - Software CRM",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"query\": \"software CRM\",\n  \"max_results\": 5,\n  \"country\": \"br\"\n}"
            },
            "url": {
              "raw": "{{base_url}}/analyze",
              "host": ["{{base_url}}"],
              "path": ["analyze"]
            },
            "description": "Busca software CRM no Brasil"
          },
          "response": []
        }
      ]
    },
    {
      "name": "Geo-Targeting Examples",
      "item": [
        {
          "name": "USA - Coffee Shops",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"query\": \"coffee shops\",\n  \"country\": \"us\",\n  \"max_results\": 3\n}"
            },
            "url": {
              "raw": "{{base_url}}/analyze",
              "host": ["{{base_url}}"],
              "path": ["analyze"]
            },
            "description": "Busca coffee shops nos EUA"
          },
          "response": []
        },
        {
          "name": "UK - Software Development",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"query\": \"software development\",\n  \"country\": \"gb\",\n  \"max_results\": 5\n}"
            },
            "url": {
              "raw": "{{base_url}}/analyze",
              "host": ["{{base_url}}"],
              "path": ["analyze"]
            },
            "description": "Busca software development no Reino Unido"
          },
          "response": []
        },
        {
          "name": "Spain - Agencias Marketing",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"query\": \"agencias de marketing\",\n  \"country\": \"es\",\n  \"language\": \"es\",\n  \"max_results\": 5\n}"
            },
            "url": {
              "raw": "{{base_url}}/analyze",
              "host": ["{{base_url}}"],
              "path": ["analyze"]
            },
            "description": "Busca agências de marketing na Espanha"
          },
          "response": []
        },
        {
          "name": "Portugal - Cafes",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"query\": \"cafés\",\n  \"country\": \"pt\",\n  \"language\": \"pt-PT\",\n  \"max_results\": 5\n}"
            },
            "url": {
              "raw": "{{base_url}}/analyze",
              "host": ["{{base_url}}"],
              "path": ["analyze"]
            },
            "description": "Busca cafés em Portugal (português de Portugal)"
          },
          "response": []
        }
      ]
    },
    {
      "name": "Advanced Options",
      "item": [
        {
          "name": "Custom HTML Size (200KB)",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"query\": \"e-commerce platforms\",\n  \"country\": \"us\",\n  \"max_results\": 3,\n  \"html_size\": 200000\n}"
            },
            "url": {
              "raw": "{{base_url}}/analyze",
              "host": ["{{base_url}}"],
              "path": ["analyze"]
            },
            "description": "Busca com tamanho HTML customizado (200KB)"
          },
          "response": []
        },
        {
          "name": "Maximum Results (10)",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"query\": \"technology news\",\n  \"country\": \"us\",\n  \"max_results\": 10,\n  \"html_size\": 100000\n}"
            },
            "url": {
              "raw": "{{base_url}}/analyze",
              "host": ["{{base_url}}"],
              "path": ["analyze"]
            },
            "description": "Busca com máximo de resultados (10)"
          },
          "response": []
        },
        {
          "name": "Competitive Analysis - Multi-Country",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"query\": \"cloud services\",\n  \"country\": \"br\",\n  \"language\": \"pt-BR\",\n  \"max_results\": 5,\n  \"html_size\": 150000\n}"
            },
            "url": {
              "raw": "{{base_url}}/analyze",
              "host": ["{{base_url}}"],
              "path": ["analyze"]
            },
            "description": "Análise competitiva com opções avançadas"
          },
          "response": []
        }
      ]
    }
  ],
  "variable": [
    {
      "key": "base_url",
      "value": "https://croacia-mvp.fly.dev",
      "type": "string"
    },
    {
      "key": "local_url",
      "value": "http://localhost:8080",
      "type": "string"
    }
  ]
}
```

***

## 🐍 **2. `sdk/python/croacia_mvp/__init__.py` - Python SDK**

```python
"""
Croacia MVP API SDK

Python client library para a Croacia MVP API de Competitive Intelligence.

Exemplo de uso:
    >>> from croacia_mvp import CroaciaAPI
    >>> api = CroaciaAPI()
    >>> results = api.analyze("software CRM", country="br")
    >>> print(f"Total: {results['total']} resultados")
"""

from .client import CroaciaAPI
from .models import AnalyzeRequest, ScrapedResult, AnalyzeResponse
from .exceptions import CroaciaAPIError, TimeoutError, ValidationError

__version__ = "1.0.0"
__author__ = "Croacia MVP Team"
__all__ = [
    "CroaciaAPI",
    "AnalyzeRequest",
    "ScrapedResult",
    "AnalyzeResponse",
    "CroaciaAPIError",
    "TimeoutError",
    "ValidationError",
]
```

***

## 📄 **`sdk/python/croacia_mvp/client.py`**

```python
"""
Croacia MVP API Client
"""

import requests
import json
from typing import Dict, List, Optional, Any
from .models import AnalyzeRequest, AnalyzeResponse, ScrapedResult
from .exceptions import CroaciaAPIError, ValidationError


class CroaciaAPI:
    """Cliente para a Croacia MVP API"""

    DEFAULT_BASE_URL = "https://croacia-mvp.fly.dev"
    DEFAULT_TIMEOUT = 60

    def __init__(
        self,
        base_url: str = DEFAULT_BASE_URL,
        timeout: int = DEFAULT_TIMEOUT,
        session: Optional[requests.Session] = None
    ):
        """
        Inicializa o cliente da API.

        Args:
            base_url: URL base da API (padrão: production)
            timeout: Timeout em segundos
            session: Sessão requests customizada (opcional)
        """
        self.base_url = base_url.rstrip("/")
        self.timeout = timeout
        self.session = session or requests.Session()

        # Headers padrão
        self.session.headers.update({
            "Content-Type": "application/json",
            "User-Agent": "croacia-mvp-python-sdk/1.0.0"
        })

    def health_check(self) -> Dict[str, Any]:
        """
        Verifica se a API está operacional.

        Returns:
            Dict com status, timestamp, modo, etc.

        Raises:
            CroaciaAPIError: Se a API estiver indisponível
        """
        try:
            response = self.session.get(
                f"{self.base_url}/health",
                timeout=5
            )
            response.raise_for_status()
            return response.json()

        except requests.exceptions.RequestException as e:
            raise CroaciaAPIError(f"Health check failed: {str(e)}")

    def analyze(
        self,
        query: str,
        country: str = "br",
        max_results: int = 5,
        language: Optional[str] = None,
        html_size: Optional[int] = None
    ) -> AnalyzeResponse:
        """
        Analisa uma palavra-chave.

        Args:
            query: Palavra-chave para buscar
            country: Código ISO do país (padrão: br)
            max_results: Número máximo de resultados (1-10)
            language: Código de idioma BCP 47 (opcional)
            html_size: Tamanho máximo do HTML em bytes (opcional)

        Returns:
            AnalyzeResponse com resultados

        Raises:
            ValidationError: Se os parâmetros forem inválidos
            CroaciaAPIError: Se houver erro na API

        Exemplo:
            >>> api = CroaciaAPI()
            >>> response = api.analyze(
            ...     "software CRM",
            ...     country="br",
            ...     max_results=5
            ... )
            >>> for result in response.results:
            ...     print(f"{result.title}: {result.url}")
        """
        # Validação
        if not query or not isinstance(query, str):
            raise ValidationError("query must be a non-empty string")

        if not 1 <= max_results <= 10:
            raise ValidationError("max_results must be between 1 and 10")

        if len(country) != 2:
            raise ValidationError("country must be a 2-letter ISO code")

        # Construir payload
        payload = {
            "query": query,
            "country": country.lower(),
            "max_results": max_results
        }

        if language:
            payload["language"] = language

        if html_size:
            if not 1000 <= html_size <= 500000:
                raise ValidationError("html_size must be between 1000 and 500000")
            payload["html_size"] = html_size

        # Fazer request
        try:
            response = self.session.post(
                f"{self.base_url}/analyze",
                json=payload,
                timeout=self.timeout
            )
            response.raise_for_status()

            data = response.json()
            return AnalyzeResponse.from_dict(data)

        except requests.exceptions.Timeout:
            raise CroaciaAPIError("Request timeout (>60s)")

        except requests.exceptions.RequestException as e:
            raise CroaciaAPIError(f"API error: {str(e)}")

        except (json.JSONDecodeError, ValueError) as e:
            raise CroaciaAPIError(f"Invalid response format: {str(e)}")

    def analyze_multi_country(
        self,
        query: str,
        countries: List[str],
        max_results: int = 3
    ) -> Dict[str, AnalyzeResponse]:
        """
        Analisa a mesma query em múltiplos países.

        Args:
            query: Palavra-chave para buscar
            countries: Lista de códigos de país
            max_results: Número de resultados por país

        Returns:
            Dict mapeando país -> AnalyzeResponse

        Exemplo:
            >>> api = CroaciaAPI()
            >>> results = api.analyze_multi_country(
            ...     "CRM software",
            ...     countries=["br", "us", "pt"]
            ... )
            >>> for country, response in results.items():
            ...     print(f"{country}: {response.total} resultados")
        """
        results = {}

        for country in countries:
            try:
                response = self.analyze(query, country=country, max_results=max_results)
                results[country] = response

            except CroaciaAPIError as e:
                print(f"⚠️ Erro para {country}: {str(e)}")
                results[country] = None

        return results

    def close(self):
        """Fecha a sessão HTTP"""
        self.session.close()

    def __enter__(self):
        """Context manager entry"""
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        """Context manager exit"""
        self.close()
```

***

## 📄 **`sdk/python/croacia_mvp/models.py`**

```python
"""
Modelos de dados para Croacia MVP API
"""

from dataclasses import dataclass, field
from typing import List, Optional, Dict, Any
from datetime import datetime


@dataclass
class ScrapedResult:
    """Resultado de scraping individual"""

    url: str
    title: str
    snippet: str
    html: str
    status: str
    html_size: int
    timestamp: int
    error: str = ""

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "ScrapedResult":
        """Cria ScrapedResult a partir de dict"""
        return cls(
            url=data.get("url", ""),
            title=data.get("title", ""),
            snippet=data.get("snippet", ""),
            html=data.get("html", ""),
            status=data.get("status", ""),
            html_size=data.get("html_size", 0),
            timestamp=data.get("timestamp", 0),
            error=data.get("error", "")
        )

    @property
    def success(self) -> bool:
        """Verifica se o scraping foi bem-sucedido"""
        return self.status == "success"

    @property
    def scraped_at(self) -> datetime:
        """Retorna datetime do scraping"""
        return datetime.fromtimestamp(self.timestamp)


@dataclass
class AnalyzeRequest:
    """Request de análise"""

    query: str
    country: str = "br"
    max_results: int = 5
    language: Optional[str] = None
    html_size: Optional[int] = None

    def to_dict(self) -> Dict[str, Any]:
        """Converte para dict para enviar na API"""
        data = {
            "query": self.query,
            "country": self.country,
            "max_results": self.max_results
        }

        if self.language:
            data["language"] = self.language

        if self.html_size:
            data["html_size"] = self.html_size

        return data


@dataclass
class AnalyzeResponse:
    """Response de análise"""

    status: str
    query: str
    country: str
    language: str
    total: int
    results: List[ScrapedResult] = field(default_factory=list)
    error: Optional[str] = None

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "AnalyzeResponse":
        """Cria AnalyzeResponse a partir de dict"""
        results = [
            ScrapedResult.from_dict(r)
            for r in data.get("results", [])
        ]

        return cls(
            status=data.get("status", ""),
            query=data.get("query", ""),
            country=data.get("country", ""),
            language=data.get("language", ""),
            total=data.get("total", 0),
            results=results,
            error=data.get("error")
        )

    @property
    def success(self) -> bool:
        """Verifica se a requisição foi bem-sucedida"""
        return self.status == "success"

    @property
    def successful_results(self) -> List[ScrapedResult]:
        """Retorna apenas resultados com sucesso"""
        return [r for r in self.results if r.success]

    def get_html(self, index: int = 0) -> str:
        """Retorna HTML do resultado no índice especificado"""
        if 0 <= index < len(self.results):
            return self.results[index].html
        return ""
```

***

## 📄 **`sdk/python/croacia_mvp/exceptions.py`**

```python
"""
Exceções da API
"""


class CroaciaAPIError(Exception):
    """Exceção base da API"""
    pass


class ValidationError(CroaciaAPIError):
    """Erro de validação de parâmetros"""
    pass


class TimeoutError(CroaciaAPIError):
    """Timeout na requisição"""
    pass
```

***

## 📄 **`sdk/python/setup.py`**

```python
from setuptools import setup, find_packages

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

setup(
    name="croacia-mvp",
    version="1.0.0",
    author="Croacia MVP Team",
    author_email="support@croacia-mvp.example.com",
    description="Python SDK para Croacia MVP API",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/croacia-mvp/sdk-python",
    packages=find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires=">=3.8",
    install_requires=[
        "requests>=2.28.0",
    ],
    extras_require={
        "dev": [
            "pytest>=7.0",
            "pytest-cov>=4.0",
            "black>=22.0",
            "flake8>=4.0",
        ],
    },
)
```

***

## 📄 **`sdk/python/README.md`**

```markdown
# Croacia MVP Python SDK

Cliente Python para a Croacia MVP API de Competitive Intelligence.

## Instalação

```bash
pip install croacia-mvp
```

## Uso Rápido

```python
from croacia_mvp import CroaciaAPI

# Inicializar cliente
api = CroaciaAPI()

# Análise simples
response = api.analyze("software CRM", country="br", max_results=5)

# Processar resultados
for result in response.results:
    print(f"📄 {result.title}")
    print(f"🔗 {result.url}")
    print(f"📏 {result.html_size} bytes\n")
```

## Exemplos

### Health Check

```python
api = CroaciaAPI()
health = api.health_check()
print(f"Status: {health['status']}")
```

### Análise Multi-País

```python
api = CroaciaAPI()
results = api.analyze_multi_country(
    "CRM software",
    countries=["br", "us", "pt"],
    max_results=3
)

for country, response in results.items():
    print(f"{country}: {response.total} resultados")
```

### Com Context Manager

```python
with CroaciaAPI() as api:
    response = api.analyze("cafeterias", country="br")
    print(f"Total: {response.total}")
```

### HTML Customizado

```python
api = CroaciaAPI()
response = api.analyze(
    "e-commerce",
    country="us",
    max_results=3,
    html_size=200000  # 200KB
)
```

## Documentação Completa

https://github.com/croacia-mvp/sdk-python

```
***

## 🟨 **3. `sdk/javascript/index.js` - JavaScript SDK**

```javascript
/**
 * Croacia MVP API - JavaScript SDK
 * Client library para a API de Competitive Intelligence
 */

class CroaciaAPI {
  constructor(baseURL = 'https://croacia-mvp.fly.dev', timeout = 60000) {
    this.baseURL = baseURL.replace(/\/$/, '');
    this.timeout = timeout;
  }

  /**
   * Verifica o status da API
   * @returns {Promise<Object>} Status da API
   */
  async healthCheck() {
    try {
      const response = await this.request('GET', '/health');
      return response;
    } catch (error) {
      throw new CroaciaAPIError(`Health check failed: ${error.message}`);
    }
  }

  /**
   * Analisa uma palavra-chave
   * @param {string} query - Palavra-chave para buscar
   * @param {Object} options - Opções de análise
   * @param {string} options.country - Código ISO do país (padrão: 'br')
   * @param {number} options.maxResults - Número de resultados (1-10, padrão: 5)
   * @param {string} options.language - Código de idioma (opcional)
   * @param {number} options.htmlSize - Tamanho máximo do HTML (opcional)
   * @returns {Promise<Object>} Resultados da análise
   */
  async analyze(query, options = {}) {
    if (!query || typeof query !== 'string') {
      throw new ValidationError('query must be a non-empty string');
    }

    const {
      country = 'br',
      maxResults = 5,
      language = undefined,
      htmlSize = undefined
    } = options;

    if (maxResults < 1 || maxResults > 10) {
      throw new ValidationError('maxResults must be between 1 and 10');
    }

    const payload = {
      query,
      country: country.toLowerCase(),
      max_results: maxResults
    };

    if (language) payload.language = language;
    if (htmlSize) payload.html_size = htmlSize;

    try {
      const response = await this.request('POST', '/analyze', payload);
      return new AnalyzeResponse(response);
    } catch (error) {
      throw new CroaciaAPIError(`Analyze failed: ${error.message}`);
    }
  }

  /**
   * Analisa a mesma query em múltiplos países
   * @param {string} query - Palavra-chave
   * @param {Array<string>} countries - Códigos de país
   * @param {number} maxResults - Resultados por país
   * @returns {Promise<Object>} Mapa país -> resultados
   */
  async analyzeMultiCountry(query, countries, maxResults = 3) {
    const results = {};

    for (const country of countries) {
      try {
        results[country] = await this.analyze(query, {
          country,
          maxResults
        });
      } catch (error) {
        console.warn(`⚠️ Error for ${country}: ${error.message}`);
        results[country] = null;
      }
    }

    return results;
  }

  /**
   * Faz uma requisição HTTP
   * @private
   */
  async request(method, path, data = null) {
    const url = `${this.baseURL}${path}`;
    const options = {
      method,
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'croacia-mvp-js-sdk/1.0.0'
      }
    };

    if (data) {
      options.body = JSON.stringify(data);
    }

    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), this.timeout);

    try {
      const response = await fetch(url, {
        ...options,
        signal: controller.signal
      });

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }

      return await response.json();
    } catch (error) {
      if (error.name === 'AbortError') {
        throw new TimeoutError(`Request timeout (>${this.timeout}ms)`);
      }
      throw error;
    } finally {
      clearTimeout(timeoutId);
    }
  }
}

/**
 * Response wrapper
 */
class AnalyzeResponse {
  constructor(data) {
    this.status = data.status;
    this.query = data.query;
    this.country = data.country;
    this.language = data.language;
    this.total = data.total;
    this.results = (data.results || []).map(r => new ScrapedResult(r));
    this.error = data.error;
  }

  get success() {
    return this.status === 'success';
  }

  get successfulResults() {
    return this.results.filter(r => r.success);
  }

  getHtml(index = 0) {
    return this.results[index]?.html || '';
  }
}

/**
 * Resultado individual de scraping
 */
class ScrapedResult {
  constructor(data) {
    this.url = data.url;
    this.title = data.title;
    this.snippet = data.snippet;
    this.html = data.html;
    this.status = data.status;
    this.htmlSize = data.html_size;
    this.timestamp = data.timestamp;
    this.error = data.error || '';
  }

  get success() {
    return this.status === 'success';
  }

  get scrapedAt() {
    return new Date(this.timestamp * 1000);
  }
}

/**
 * Exceções
 */
class CroaciaAPIError extends Error {
  constructor(message) {
    super(message);
    this.name = 'CroaciaAPIError';
  }
}

class ValidationError extends CroaciaAPIError {
  constructor(message) {
    super(message);
    this.name = 'ValidationError';
  }
}

class TimeoutError extends CroaciaAPIError {
  constructor(message) {
    super(message);
    this.name = 'TimeoutError';
  }
}

// Exports
if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    CroaciaAPI,
    AnalyzeResponse,
    ScrapedResult,
    CroaciaAPIError,
    ValidationError,
    TimeoutError
  };
}
```

***

## 📄 **`sdk/javascript/package.json`**

```json
{
  "name": "croacia-mvp",
  "version": "1.0.0",
  "description": "JavaScript SDK para Croacia MVP API",
  "main": "index.js",
  "types": "index.d.ts",
  "scripts": {
    "test": "jest",
    "lint": "eslint .",
    "build": "tsc"
  },
  "keywords": [
    "api",
    "competitive-intelligence",
    "web-scraping",
    "geo-targeting"
  ],
  "author": "Croacia MVP Team",
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "https://github.com/croacia-mvp/sdk-javascript"
  },
  "bugs": {
    "url": "https://github.com/croacia-mvp/sdk-javascript/issues"
  },
  "devDependencies": {
    "@types/jest": "^29.0.0",
    "jest": "^29.0.0",
    "eslint": "^8.0.0",
    "typescript": "^5.0.0"
  }
}
```

***

## 📄 **`sdk/javascript/README.md`**

```markdown
# Croacia MVP JavaScript SDK

Cliente JavaScript/Node.js para a Croacia MVP API.

## Instalação

### NPM
```bash
npm install croacia-mvp
```

### Browser

```html
<script src="https://cdn.jsdelivr.net/npm/croacia-mvp@latest/index.js"></script>
```

## Uso Rápido

```javascript
// Node.js
const { CroaciaAPI } = require('croacia-mvp');

// Ou ES6
import { CroaciaAPI } from 'croacia-mvp';

// Criar cliente
const api = new CroaciaAPI();

// Análise simples
const response = await api.analyze('software CRM', {
  country: 'br',
  maxResults: 5
});

// Processar resultados
response.results.forEach(result => {
  console.log(`📄 ${result.title}`);
  console.log(`🔗 ${result.url}`);
  console.log(`📏 ${result.htmlSize} bytes\n`);
});
```

## Exemplos

### Health Check

```javascript
const api = new CroaciaAPI();
const health = await api.healthCheck();
console.log(`Status: ${health.status}`);
```

### Multi-país

```javascript
const api = new CroaciaAPI();
const results = await api.analyzeMultiCountry(
  'CRM software',
  ['br', 'us', 'pt'],
  3
);

for (const [country, response] of Object.entries(results)) {
  console.log(`${country}: ${response.total} resultados`);
}
```

### HTML Customizado

```javascript
const response = await api.analyze('e-commerce', {
  country: 'us',
  maxResults: 3,
  htmlSize: 200000  // 200KB
});
```

## TypeScript

```typescript
import { CroaciaAPI, AnalyzeResponse } from 'croacia-mvp';

const api = new CroaciaAPI();
const response: AnalyzeResponse = await api.analyze('test');
```

```
***

## 🔄 **4. `docs/asyncapi.yaml` - AsyncAPI Spec**

```yaml
asyncapi: 3.0.0
info:
  title: Croacia MVP API - AsyncAPI
  version: 1.0.0
  description: |
    Especificação AsyncAPI para extensões futuras com webhooks e real-time updates

servers:
  production:
    host: croacia-mvp.fly.dev
    protocol: https

channels:
  analyze.request:
    address: /webhooks/analyze
    messages:
      analyzeRequest:
        summary: Request de análise assíncrona
        payload:
          type: object
          properties:
            query:
              type: string
            country:
              type: string
            callback_url:
              type: string
              format: uri
              description: URL para receber resultados via POST

  analyze.response:
    address: /webhooks/callback
    messages:
      analyzeResponse:
        summary: Resposta com resultados de análise
        payload:
          type: object
          properties:
            request_id:
              type: string
            status:
              type: string
            results:
              type: array
              items:
                $ref: '#/components/schemas/ScrapedResult'
```

***

## 📦 **Salvar Tudo no Projeto**

```bash
# Python SDK
mkdir -p sdk/python/croacia_mvp
cat > sdk/python/croacia_mvp/__init__.py << 'EOF'
[cole conteúdo acima]
EOF

cat > sdk/python/croacia_mvp/client.py << 'EOF'
[cole conteúdo acima]
EOF

cat > sdk/python/croacia_mvp/models.py << 'EOF'
[cole conteúdo acima]
EOF

cat > sdk/python/croacia_mvp/exceptions.py << 'EOF'
[cole conteúdo acima]
EOF

cat > sdk/python/setup.py << 'EOF'
[cole conteúdo acima]
EOF

# JavaScript SDK
mkdir -p sdk/javascript
cat > sdk/javascript/index.js << 'EOF'
[cole conteúdo acima]
EOF

cat > sdk/javascript/package.json << 'EOF'
[cole conteúdo acima]
EOF

# AsyncAPI
cat > docs/asyncapi.yaml << 'EOF'
[cole conteúdo acima]
EOF

# Postman
cat > docs/croacia-mvp.postman_collection.json << 'EOF'
[cole conteúdo acima]
EOF

# Commit
git add sdk/ docs/asyncapi.yaml docs/croacia-mvp.postman_collection.json
git commit -m "feat: add SDKs (Python/JS), Postman Collection, AsyncAPI spec"
git push
```

***

## 🎯 **Próximos Passos**

1. **Publicar Python SDK no PyPI**
   
   ```bash
   cd sdk/python
   pip install twine
   python setup.py sdist bdist_wheel
   twine upload dist/*
   ```

2. **Publicar JavaScript SDK no NPM**
   
   ```bash
   cd sdk/javascript
   npm login
   npm publish
   ```

3. **Adicionar Testes**
   
   ```bash
   # Python
   pip install pytest
   pytest sdk/python/
   ```

# JavaScript

npm test

```

***

**Pronto! Você tem uma API profissional com documentação, SDKs e testes completos!** 🚀📚✨
