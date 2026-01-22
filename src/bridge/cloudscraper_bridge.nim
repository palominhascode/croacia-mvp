# ============================================================================
# Cloudscraper Bridge - CLOUDFLARE BYPASS (Fase 1A) - CORRIGIDO
# ============================================================================
# ✅ Erros resolvidos
# ✅ Pronto para usar 
# ============================================================================

import json
import strutils
import asyncdispatch
import osproc
import posix       # ← ADICIONADO (para getpid)
import random      # ← ADICIONADO (para ID único)

# ============================================================================
# Type Definitions
# ============================================================================

type
  CloudscraperResponse* = object
    status*: string
    html*: string
    latency_ms*: int
    error_msg*: string
    cf_cleared*: bool

# ============================================================================
# Configuration
# ============================================================================

const CLOUDSCRAPER_RETRIES = 2

# ============================================================================
# Helper Functions
# ============================================================================

proc getRandomPid(): string {.inline.} =
  ## Gera ID único para arquivo temporário
  return $getpid() & "_" & $rand(100000..999999)

# ============================================================================
# Scraping Functions
# ============================================================================

proc fetchWithCloudscraperSync*(url: string, attempt: int = 1): CloudscraperResponse =
  let uniqueId = getRandomPid()
  let sanitizedUrl = url.replace("\"", "\\\"")
  
  let pythonScript = """
import cloudscraper
import json
import sys
import time

try:
    start = time.time()
    scraper = cloudscraper.create_scraper()
    url = sys.argv[1]
    response = scraper.get(url, timeout=15)
    elapsed = int((time.time() - start) * 1000)
    
    if response.status_code == 200:
        result = {
            "status": "success",
            "html": response.text[:50000],
            "latency_ms": elapsed,
            "cf_cleared": True
        }
    else:
        result = {
            "status": "http_error",
            "html": "",
            "latency_ms": elapsed,
            "error_msg": f"HTTP {response.status_code}",
            "cf_cleared": False
        }
    print(json.dumps(result))
except Exception as e:
    result = {
        "status": "error",
        "html": "",
        "latency_ms": 0,
        "error_msg": str(e),
        "cf_cleared": False
    }
    print(json.dumps(result))
"""
  
  try:
    echo "[CLOUDSCRAPER] Tentativa ", attempt, "/", CLOUDSCRAPER_RETRIES, " para: ", url
    
    let scriptFile = "/tmp/cloudscraper_fetch_" & uniqueId & ".py"
    let f = open(scriptFile, fmWrite)
    f.write(pythonScript)
    f.close()
    
    let cmd = "python3 " & scriptFile & " \"" & sanitizedUrl & "\""
    let (output, exitCode) = execCmdEx(cmd)
    
    discard execCmd("rm -f " & scriptFile)
    
    if exitCode == 0 and output.len > 0:
      try:
        let jsonResponse = parseJson(output)
        return CloudscraperResponse(
          status: jsonResponse{"status"}.getStr("error"),
          html: jsonResponse{"html"}.getStr(""),
          latency_ms: jsonResponse{"latency_ms"}.getInt(0),
          error_msg: jsonResponse{"error_msg"}.getStr(""),
          cf_cleared: jsonResponse{"cf_cleared"}.getBool(false)
        )
      except JsonParsingError:
        echo "[CLOUDSCRAPER ERROR] JSON parse fail"
        return CloudscraperResponse(
          status: "json_error",
          html: "",
          latency_ms: 0,
          error_msg: "JSON parsing failed",
          cf_cleared: false
        )
    else:
      echo "[CLOUDSCRAPER ERROR] Exit code: ", exitCode
      return CloudscraperResponse(
        status: "execution_error",
        html: "",
        latency_ms: 0,
        error_msg: "Python execution failed",
        cf_cleared: false
      )
  except Exception as e:
    echo "[CLOUDSCRAPER ERROR] ", e.msg
    return CloudscraperResponse(
      status: "error",
      html: "",
      latency_ms: 0,
      error_msg: e.msg,
      cf_cleared: false
    )

proc fetchWithCloudscraperAsync*(url: string): Future[CloudscraperResponse] {.async, gcsafe.} =
  var response: CloudscraperResponse
  
  for attempt in 1..CLOUDSCRAPER_RETRIES:
    response = fetchWithCloudscraperSync(url, attempt)
    
    if response.status == "success" and response.cf_cleared:
      echo "[CLOUDSCRAPER] ✅ SUCESSO (tentativa ", attempt, ")"
      return response
    elif response.status == "blocked":
      echo "[CLOUDSCRAPER] ⚠️  Bloqueado"
      await sleepAsync(1000)
      continue
    else:
      echo "[CLOUDSCRAPER] ❌ Falha: ", response.error_msg
      if attempt < CLOUDSCRAPER_RETRIES:
        await sleepAsync(2000)
  
  return response

proc isCloudflareProtected*(url: string): bool =
  let cf_indicators = ["cloudflare", "protected", "challenge"]
  let cf_domains = ["linkedin.com", "pinterest.com", "discord.com", "stripe.com"]
  
  let urlLower = url.toLowerAscii()
  for indicator in cf_indicators:
    if indicator in urlLower:
      return true
  
  for domain in cf_domains:
    if domain in urlLower:
      return true
  
  return false

proc getCloudscraperStatus*(): bool =
  let (_, code) = execCmdEx("python3 -c \"import cloudscraper; print('ok')\"")
  return code == 0