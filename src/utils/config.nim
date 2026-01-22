# ============================================================================
# CONFIG - Gerenciamento de Configuração
# ============================================================================

import os
import ../core/types

proc loadConfig*(): Config =
  Config(
    serperApiKey: getEnv("SERPER_API_KEY", ""),
    port: getEnv("PORT", "8080").parseInt,
    maxHtmlSize: getEnv("MAX_HTML_SIZE", "500000").parseInt,
    cacheDir: getEnv("CACHE_DIR", "/tmp/scraper_cache"),
    pythonPath: getEnv("PYTHON_PATH", "python3")
  )

proc validateConfig*(config: Config): bool =
  if config.serperApiKey == "":
    echo "❌ SERPER_API_KEY não definida"
    return false
  if config.port <= 0:
    echo "❌ PORT inválida"
    return false
  true
