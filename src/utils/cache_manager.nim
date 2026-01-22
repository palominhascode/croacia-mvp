# ============================================================================
# Cache Manager Module - Thread-Safe Cache using Channels (FINAL - NO IMPORT)
# ============================================================================
# ✅ CRÍTICO: Threads é parte do sistema em Nim 2.2.6+
# ✅ NÃO precisa import threads - apenas compile com --threads:on
# ✅ Channel-based architecture 100% GC-safe
# ============================================================================

import tables
import times

# ============================================================================
# Types
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

  CacheEntry* = object
    data*: seq[ScrapedResult]
    age*: float

  # Discriminated union para requisições de cache
  CacheRequestKind* = enum
    ckGet
    ckSet
    ckClear

  CacheRequest* = object
    kind*: CacheRequestKind
    key*: string
    value*: CacheEntry

  CacheResponse* = object
    found*: bool
    data*: CacheEntry

# ============================================================================
# Global Cache Channels (processo-wide thread-safe)
# ============================================================================

var gCacheRequestChan*: Channel[CacheRequest]
var gCacheResponseChan*: Channel[CacheResponse]

proc initCacheManager*() =
  ## Inicializa o sistema de cache com canais thread-safe
  gCacheRequestChan.open(maxItems=100)
  gCacheResponseChan.open(maxItems=100)

proc closeCacheManager*() =
  ## Fecha os canais de cache
  gCacheRequestChan.close()
  gCacheResponseChan.close()

# ============================================================================
# Cache Operations (100% GC-safe, usando channels)
# ============================================================================

proc getCached*(keyword: string): tuple[found: bool, data: CacheEntry] {.gcsafe.} =
  ## Obtém resultado do cache de forma thread-safe
  ## Retorna (encontrado, dados) tuple
  var request = CacheRequest(kind: ckGet, key: keyword)
  
  # Envia requisição
  gCacheRequestChan.send(request)
  
  # Aguarda resposta
  let response = gCacheResponseChan.recv()
  
  return (response.found, response.data)

proc isCacheValid*(keyword: string): bool {.gcsafe.} =
  ## Verifica se cache existe e não expirou (24h)
  let (found, entry) = getCached(keyword)
  
  if not found:
    return false
  
  let age = (epochTime() - entry.age).abs()
  return age < 86400  # 24 horas

proc setCached*(keyword: string, results: seq[ScrapedResult]) {.gcsafe.} =
  ## Armazena resultados no cache de forma thread-safe
  let entry = CacheEntry(data: results, age: epochTime())
  var request = CacheRequest(kind: ckSet, key: keyword, value: entry)
  
  # Envia requisição
  gCacheRequestChan.send(request)
  
  # Aguarda confirmação (vazio)
  discard gCacheResponseChan.recv()

proc clearCache*() {.gcsafe.} =
  ## Limpa todo o cache
  var request = CacheRequest(kind: ckClear, key: "")
  
  # Envia requisição
  gCacheRequestChan.send(request)
  
  # Aguarda confirmação
  discard gCacheResponseChan.recv()

# ============================================================================
# Cache Backend Worker (executa em thread separada)
# ============================================================================

proc cacheBackendWorker*() {.thread.} =
  ## Worker thread que gerencia o cache
  ## Executa em loop infinito processando requisições
  var cache: Table[string, CacheEntry]
  
  while true:
    try:
      # Aguarda requisição
      let request = gCacheRequestChan.recv()
      
      case request.kind
      of ckGet:
        # Retorna cache hit/miss
        let found = request.key in cache
        var response: CacheResponse
        
        if found:
          response = CacheResponse(found: true, data: cache[request.key])
        else:
          response = CacheResponse(found: false)
        
        gCacheResponseChan.send(response)
      
      of ckSet:
        # Armazena no cache
        cache[request.key] = request.value
        
        # Confirma
        let response = CacheResponse(found: true)
        gCacheResponseChan.send(response)
      
      of ckClear:
        # Limpa cache
        cache.clear()
        
        # Confirma
        let response = CacheResponse(found: true)
        gCacheResponseChan.send(response)
    
    except Exception as e:
      echo "[CACHE WORKER ERROR] ", e.msg
      # Continua processando

# ============================================================================
# Inicialização no início do programa
# ============================================================================

when isMainModule:
  echo "[CACHE] Inicializando cache manager..."
  initCacheManager()
  
  # Inicia worker thread
  var cacheWorker: Thread[void]
  createThread(cacheWorker, cacheBackendWorker)
  
  # Testa cache
  echo "[CACHE] Testando cache..."
  setCached("test_keyword", @[ScrapedResult(url: "http://example.com")])
  let (found, entry) = getCached("test_keyword")
  echo "[CACHE] Cache hit: ", found, " | Resultados: ", entry.data.len
  
  # Cleanup
  closeCacheManager()
  joinThread(cacheWorker)