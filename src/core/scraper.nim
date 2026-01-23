# ============================================================================
# Scraper Module - COM CLOUDSCRAPER FALLBACK (Fase 1A)
# ============================================================================
# ✅ Define ScrapedResult type
# ✅ Implementa toJsonArray e toJsonNode
# ✅ HTML VOLUMOSO (50KB) para IA
# ✅ SEGURO - sem cache_manager (causa SIGSEGV)
# ✅ COM CLOUDSCRAPER FALLBACK (HTTP → Cloudscraper chain)
# ============================================================================

import httpClient
import json
import strutils
import times
import asyncdispatch
import os
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
# Configuration
# ============================================================================

const SERPER_API_KEY = getEnv("SERPER_API_KEY")
const SERPER_API_URL = "https://google.serper.dev/search"
const MAX_HTML_SIZE = 50000

# ============================================================================
# Scraping Functions
# ============================================================================

proc fetchUrlsFromSerper*(query: string): Future[seq[string]] {.async, gcsafe.} =
  var results: seq[string] = @[]

  try:
    echo "[SERPER] Buscando: ", query
    var client = newHttpClient()
    client.headers = newHttpHeaders({
      "X-API-Key": SERPER_API_KEY,
      "Content-Type": "application/json"
    })
    client.timeout = 5000

    let payload = %*{"q": query, "num": 5}
    let response = client.postContent(SERPER_API_URL, $payload)
    let data = parseJson(response)

    if data.hasKey("organic"):
      for item in data["organic"].getElems():
        if item.hasKey("link"):
          let link = item["link"].getStr()
          if link.len > 0 and link.len < 500:
            results.add(link)

    echo "[SERPER] URLs encontradas: ", results.len

  except OSError:
    echo "[SERPER ERROR] Timeout"
  except JsonParsingError as e:
    echo "[SERPER ERROR] JSON: ", e.msg
  except Exception as e:
    echo "[SERPER ERROR] ", e.msg

  return results

proc normalizeToHomepage*(url: string): string =
    var normalized = url
    let queryIdx = normalized.find("?")
    if queryIdx > 0:
        normalized = normalized[0..<queryIdx]
    # Remover trailing slash apenas se houver
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
# NOVA FUNÇÃO: fetchUrlWithFallback
# ============================================================================
# Esta função implementa o chain: HTTP simples → Cloudscraper fallback
# Usada em scrapePage para suportar Cloudflare

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
# MODIFICADA: scrapePage com fetchUrlWithFallback
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

    # ← USAR NOVO fetchUrlWithFallback (HTTP → Cloudscraper chain)
    let html = await fetchUrlWithFallback(homepageUrl)

    if html.len == 0:
      scraped.status = "empty_response"
      scraped.error = "HTTP e Cloudscraper retornaram vazio"
      return scraped

    # Limpar tamanho do HTML se necessário
    var cleanHtml = html
    if cleanHtml.len > MAX_HTML_SIZE:
      cleanHtml = cleanHtml[0..<MAX_HTML_SIZE]

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

proc analyzeKeyword*(keyword: string, maxResults: int = 5): Future[seq[ScrapedResult]] {.async, gcsafe.} =
  echo "[ANALYZE] Iniciando: ", keyword
  var results: seq[ScrapedResult] = @[]

  try:
    let urls = await fetchUrlsFromSerper(keyword)

    if urls.len == 0:
      echo "[ANALYZE] Nenhuma URL"
      return @[]

    echo "[ANALYZE] Scrapando ", urls.len, " URLs..."

    for i, url in urls:
      try:
        echo "[ANALYZE] URL ", i + 1, "/", urls.len
        let scraped = await scrapePage(url)

        if scraped.url.len > 0 and scraped.url.len < 2000:
          echo "[ANALYZE] Adicionando resultado..."
          results.add(scraped)
          echo "[ANALYZE] Total: ", results.len

      except Exception as e:
        echo "[ANALYZE] Skip: ", e.msg
        continue

    echo "[ANALYZE] Concluído: ", results.len, " resultados (com Cloudscraper fallback)"

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
    echo "[JSON] Convertendo ", results.len, " resultados..."
    var arr = newJArray()

    for i, res in results:
      try:
        echo "[JSON] Resultado ", i + 1, "/", results.len
        let node = toJsonNode(res)
        arr.add(node)
        echo "[JSON] OK"

      except Exception as e:
        echo "[JSON] Skip: ", e.msg
        continue

    echo "[JSON] Array pronto: ", arr.len, " items"
    return arr

  except Exception as e:
    echo "[JSON] Erro: ", e.msg
    return newJArray()