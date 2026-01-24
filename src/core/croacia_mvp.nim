# ============================================================================
# CROACIA MVP - Main API Server (SEM CACHE_MANAGER)
# ============================================================================
# ✅ Removido cache_manager (causava SIGSEGV)
# ✅ Usa apenas scraper estateless
# ✅ Simples, direto, funciona
# ============================================================================

import pkg/jesterfork
import asyncdispatch
import json
import strutils
import times
import scraper

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
  # GET /
  get "/":
    resp "🚀 Croacia MVP - Competitive Intelligence API (Stateless)"

  # GET /health
  get "/health":
    resp(%*{
      "status": "ok",
      "timestamp": int64(epochTime()),
      "mode": "stateless",
      "gc_safe": true
    })

  # POST /analyze
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

      # ✅ Chamar analyzeKeyword diretamente (sem cache)
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
# Program Startup & Shutdown
# ============================================================================

when isMainModule:
  echo ""
  echo "╔" & "═".repeat(78) & "╗"
  echo "║" & " CROACIA MVP - STATELESS ARCHITECTURE (50KB HTML for AI)".alignLeft(78) & "║"
  echo "╠" & "═".repeat(78) & "╣"
  echo "║" & " Compile: Nim 2.2.6+ | Framework: Jesterfork | API: SERPER".alignLeft(78) & "║"
  echo "║" & " Mode: Stateless (no cache) | Deploy: Fly.io".alignLeft(78) & "║"
  echo "╚" & "═".repeat(78) & "╝"
  echo ""
  
  # ← INICIALIZAR SECRETS ANTES DO JESTER
  echo "[MAIN] Inicializando secrets..."
  initializeSecrets()
  echo "[MAIN] ✓ Secrets carregados!"
  
  echo "[INIT] 🚀 Servidor iniciando em 0.0.0.0:8080..."
  echo ""
  
  # ✅ Roda servidor (blocking)
  runForever()
  
  echo "[SHUTDOWN] ✅ Servidor finalizado gracefully"
