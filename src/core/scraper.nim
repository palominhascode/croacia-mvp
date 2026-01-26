# ============================================================================
# Scraper Module - COM CLOUDSCRAPER FALLBACK (Fase 1A)
# ============================================================================
# ✅ Define ScrapedResult type
# ✅ Implementa toJsonArray e toJsonNode
# ✅ HTML VOLUMOSO (50KB) para IA
# ✅ SEGURO - sem cache_manager (causa SIGSEGV)
# ✅ COM CLOUDSCRAPER FALLBACK (HTTP → Cloudscraper chain)
# ✅ Secrets via runtime env (GC-safe)
# ============================================================================

import os
import httpClient
import json
import strutils
import times
import asyncdispatch
import ../bridge/cloudscraper_bridge

# ============================================================================
# Type Definitions
# ============================================================================

type
  ScrapedResult* = object
    url*: string
    title*: string
    snippet*: string
    html*: string
    status*: string
    error*: string
    timestamp*: int64

# ============================================================================
# Configuration - Runtime secrets (GC-safe com threadvar)
# ============================================================================

var gSerperApiKey {.threadvar.}: string
var gSerperApiUrl {.threadvar.}: string
var gMaxHtmlSize {.threadvar.}: int

proc initializeSecrets*() =
  echo "[INIT] ✓ Carregando secrets do ambiente..."
  
  gSerperApiKey = getEnv("SERPER_API_KEY", "")
  gSerperApiUrl = "https://google.serper.dev/search"
  gMaxHtmlSize = 50000
  
  if gSerperApiKey.len == 0:
    echo "[ERROR] SERPER_API_KEY não encontrada!"
    echo "[ERROR] Configure: flyctl secrets set SERPER_API_KEY=your_key -a croacia-mvp"
    quit(1)
  
  if gSerperApiKey.len < 10:
    echo "[ERROR] SERPER_API_KEY inválida (muito curta)!"
    quit(1)
  
  echo "[INIT] ✓ API Key válida (", gSerperApiKey.len, " caracteres)"

# Getters GC-safe
proc SERPER_API_KEY(): string {.inline.} = gSerperApiKey
proc SERPER_API_URL(): string {.inline.} = gSerperApiUrl
proc MAX_HTML_SIZE(): int {.inline.} = gMaxHtmlSize

# ============================================================================
# Scraping Functions
# ============================================================================

proc fetchUrlsFromSerper*(query: string): Future[seq[string]] {.async, gcsafe.} =
  var results: seq[string] = @[]
  var response: string = ""

  try:
    echo "[SERPER] Buscando: ", query
    
    var client = newHttpClient()
    client.timeout = 15000
    
    client.headers = newHttpHeaders({
      "x-api-key": SERPER_API_KEY(),
      "Content-Type": "application/json",
      "User-Agent": "Croacia-MVP/1.0"
    })
    
    let payload = %*{"q": query, "num": 5}
    response = client.postContent(SERPER_API_URL(), $payload)
    
    let data = parseJson(response)

    if data.hasKey("organic"):
      for item in data["organic"].getElems():
        if item.hasKey("link"):
          let link = item["link"].getStr()
          if link.len > 0 and link.len < 500:
            results.add(link)

    echo "[SERPER] ✓ ", results.len, " URLs encontradas"

  except Exception as e:
    echo "[SERPER ERROR] ", e.msg

  return results

proc normalizeToHomepage*(url: string): string =
    var normalized = url
    let queryIdx = normalized.find("?")
    if queryIdx > 0:
        normalized = normalized[0..<queryIdx]
    if normalized.endsWith("/"):
        normalized = normalized[0..<(normalized.len - 1)]
    return normalized

proc safeStringChunk*(s: string, start: int, chunkSize: int): string =
  try:
    if start < 0 or start >= s.len:
      return ""

    let endIdx = min(start + chunkSize, s.len)
    if endIdx <= start:
      return ""

    return s[start..<endIdx]
  except:
    return ""

proc extractTextContent*(html: string): string =
  try:
    var text = ""
    var inTag = false

    for c in html:
      if c == '<':
        inTag = true
      elif c == '>':
        inTag = false
        text.add(' ')
      elif not inTag:
        if c in ['\n', '\r', '\t']:
          text.add(' ')
        else:
          text.add(c)

      if text.len > 20000:
        break

    while "  " in text:
      text = text.replace("  ", " ")

    return text.strip()

  except:
    return ""

# ============================================================================
# Fetch with HTTP → Cloudscraper Fallback
# ============================================================================

proc fetchUrlWithFallback*(url: string): Future[string] {.async.} =
  let homepageUrl = normalizeToHomepage(url)

  # PASSO 1: Tentar HTTP simples (rápido)
  try:
    echo "[FETCH] HTTP simples: ", homepageUrl
    var client = newHttpClient()
    client.timeout = 5000
    let html = client.getContent(homepageUrl)

    if html.len > 100:
      echo "[FETCH] ✅ HTTP OK"
      return html[0..min(html.len - 1, 49999)]

  except:
    discard

  # PASSO 2: Fallback para Cloudscraper
  echo "[FETCH] HTTP falhou, tentando Cloudscraper..."
  let cfResponse = await fetchWithCloudscraperAsync(homepageUrl)

  if cfResponse.status == "success" and cfResponse.html.len > 100:
    echo "[FETCH] ✅ Cloudscraper OK"
    return cfResponse.html

  return ""

# ============================================================================
# Scrape Page
# ============================================================================

proc scrapePage*(url: string): Future[ScrapedResult] {.async, gcsafe.} =
  var scraped = ScrapedResult(
    url: url,
    title: "",
    snippet: "",
    html: "",
    status: "success",
    error: "",
    timestamp: int64(epochTime())
  )

  try:
    let homepageUrl = normalizeToHomepage(url)
    echo "[SCRAPER] Buscando: ", homepageUrl

    let html = await fetchUrlWithFallback(homepageUrl)

    if html.len == 0:
      scraped.status = "empty_response"
      scraped.error = "HTTP e Cloudscraper retornaram vazio"
      return scraped

    var cleanHtml = html
    let maxSize = MAX_HTML_SIZE()
    if cleanHtml.len > maxSize:
      cleanHtml = cleanHtml[0..<maxSize]

    scraped.html = cleanHtml

    # Extrair título do HTML
    try:
      let titleStart = cleanHtml.find("<title>")
      if titleStart >= 0:
        let titleEnd = cleanHtml.find("</title>", titleStart)
        if titleEnd > titleStart + 7:
          let titleLen = titleEnd - titleStart - 7
          if titleLen > 0 and titleLen <= 500:
            scraped.title = safeStringChunk(cleanHtml, titleStart + 7, titleLen).strip()
    except:
      scraped.title = ""

    # Extrair snippet do conteúdo de texto
    try:
      let textContent = extractTextContent(cleanHtml)
      if textContent.len > 0:
        scraped.snippet = safeStringChunk(textContent, 0, 300).strip()
    except:
      scraped.snippet = ""

    scraped.status = "success"
    echo "[SCRAPER] ✅ OK: ", homepageUrl, " (", cleanHtml.len, " bytes)"

  except Exception as e:
    scraped.status = "error"
    scraped.error = e.msg
    echo "[SCRAPER] Erro: ", e.msg

  return scraped

# ============================================================================
# Analyze Keyword
# ============================================================================

proc analyzeKeyword*(keyword: string, maxResults: int = 5): Future[seq[ScrapedResult]] {.async, gcsafe.} =
  echo "[ANALYZE] Iniciando: ", keyword
  var results: seq[ScrapedResult] = @[]

  try:
    let urls = await fetchUrlsFromSerper(keyword)

    if urls.len == 0:
      echo "[ANALYZE] Nenhuma URL encontrada"
      return @[]

    echo "[ANALYZE] Scrapando ", urls.len, " URLs..."

    for i, url in urls:
      try:
        echo "[ANALYZE] URL ", i + 1, "/", urls.len
        let scraped = await scrapePage(url)

        if scraped.url.len > 0 and scraped.url.len < 2000:
          results.add(scraped)

      except Exception as e:
        echo "[ANALYZE] Skip: ", e.msg
        continue

    echo "[ANALYZE] ✓ ", results.len, " resultados obtidos"

  except Exception as e:
    echo "[ANALYZE ERROR] ", e.msg

  return results

# ============================================================================
# JSON Conversion
# ============================================================================

proc toJsonNode*(res: ScrapedResult): JsonNode =
  try:
    var node = newJObject()

    var url = res.url
    if url.len > 2000:
      url = url[0..<2000]
    node["url"] = newJString(url)

    var title = res.title
    if title.len > 500:
      title = title[0..<500]
    node["title"] = newJString(title)

    var snippet = res.snippet
    if snippet.len > 1000:
      snippet = snippet[0..<1000]
    node["snippet"] = newJString(snippet)

    try:
      node["html"] = newJString(res.html)
    except:
      node["html"] = newJString("")

    var status = res.status
    if status.len > 100:
      status = status[0..<100]
    node["status"] = newJString(status)

    node["html_size"] = newJInt(res.html.len)
    node["timestamp"] = newJInt(res.timestamp)

    return node

  except:
    var empty = newJObject()
    empty["url"] = newJString("")
    empty["status"] = newJString("error")
    return empty

proc toJsonArray*(results: seq[ScrapedResult]): JsonNode =
  try:
    var arr = newJArray()

    for res in results:
      try:
        let node = toJsonNode(res)
        arr.add(node)
      except Exception as e:
        echo "[JSON] Skip: ", e.msg
        continue

    return arr

  except Exception as e:
    echo "[JSON] Erro: ", e.msg
    return newJArray()
