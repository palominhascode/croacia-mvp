# ============================================================================
# CROACIA MVP - Main API Server (SEM CACHE_MANAGER)
# ============================================================================
# ✅ Removido cache_manager (causava SIGSEGV)
# ✅ Usa apenas scraper estateless
# ✅ Suporte a geolocalização por país
# ✅ Simples, direto, funciona
# ============================================================================

import pkg/jesterfork
import asyncdispatch
import json
import strutils
import times
import scraper

# ============================================================================
# CRITICAL: Initialize secrets IMMEDIATELY (before settings/routes)
# ============================================================================
initializeSecrets()

# ============================================================================
# Server Configuration
# ============================================================================

settings:
  port = Port(8080)
  bindAddr = "0.0.0.0"

# ============================================================================
# API Routes
# ============================================================================

routes:
  get "/":
    resp "🚀 Croacia MVP - Competitive Intelligence API (Stateless + Geo-targeted)"

  get "/health":
    resp(%*{
      "status": "ok",
      "timestamp": int64(epochTime()),
      "mode": "stateless",
      "geo_targeting": true,
      "gc_safe": true
    })

  post "/analyze":
    try:
      let body = request.body
      let params = parseJson(body)
      
      # Query obrigatória
      let query = params{"query"}.getStr("test")
      
      # Max results (padrão: 5)
      let maxResults = if params.hasKey("max_results"):
        params{"max_results"}.getInt(5)
      else:
        5
      
      # Country code (padrão: br)
      let countryCode = if params.hasKey("country"):
        params{"country"}.getStr("br")
      else:
        "br"
      
      # Language (auto-detecta baseado no país ou usa padrão)
      let language = if params.hasKey("language"):
        params{"language"}.getStr("")
      else:
        # Auto-detectar idioma baseado no país
        case countryCode
        of "br": "pt-BR"
        of "pt": "pt-PT"
        of "us", "gb", "au", "ca": "en"
        of "es": "es"
        of "mx": "es-MX"
        of "ar": "es-AR"
        of "fr": "fr"
        of "de": "de"
        of "it": "it"
        of "jp": "ja"
        of "cn": "zh-CN"
        else: "en"

      echo "[API] Query: ", query, " | Max: ", maxResults, " | País: ", countryCode, " | Lang: ", language

      let results = waitFor analyzeKeyword(query, maxResults, countryCode, language)
      
      let response = %*{
        "status": "success",
        "query": query,
        "country": countryCode,
        "language": language,
        "total": results.len,
        "results": toJsonArray(results)
      }
      
      resp(response)

    except Exception as e:
      echo "[ERROR] ", e.msg
      resp(%*{
        "status": "error",
        "error": e.msg
      })

# ============================================================================
# Program Startup
# ============================================================================

when isMainModule:
  echo ""
  echo "╔" & "═".repeat(78) & "╗"
  echo "║" & " CROACIA MVP - STATELESS ARCHITECTURE".alignLeft(78) & "║"
  echo "╠" & "═".repeat(78) & "╣"
  echo "║" & " Features: Geo-targeting | Cloudscraper | 50KB HTML".alignLeft(78) & "║"
  echo "╚" & "═".repeat(78) & "╝"
  echo ""
  echo "[INIT] 🚀 Servidor iniciando em 0.0.0.0:8080..."
  echo ""
  
  runForever()
  
  echo "[SHUTDOWN] ✅ Servidor finalizado gracefully"
