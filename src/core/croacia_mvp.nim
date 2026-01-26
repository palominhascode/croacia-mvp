# ============================================================================
# CROACIA MVP - Main API Server (SEM CACHE_MANAGER)
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
    resp "🚀 Croacia MVP - Competitive Intelligence API (Stateless)"

  get "/health":
    resp(%*{
      "status": "ok",
      "timestamp": int64(epochTime()),
      "mode": "stateless",
      "gc_safe": true
    })

  post "/analyze":
    try:
      let body = request.body
      let params = parseJson(body)
      let query = params{"query"}.getStr("test")
      let maxResults = if params.hasKey("max_results"):
        params{"max_results"}.getInt(5)
      else:
        5

      echo "[API] Query: ", query, " | Max: ", maxResults

      let results = waitFor analyzeKeyword(query, maxResults)
      
      let response = %*{
        "status": "success",
        "query": query,
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
  echo "╚" & "═".repeat(78) & "╝"
  echo ""
  echo "[INIT] 🚀 Servidor iniciando em 0.0.0.0:8080..."
  echo ""
  
  runForever()
  
  echo "[SHUTDOWN] ✅ Servidor finalizado gracefully"
