# ============================================================================
# TYPES - Definições Compartilhadas
# ============================================================================

import asyncdispatch, httpclient

type
  # Response types
  SearchResult* = object
    url*: string
    title*: string
    snippet*: string
    html*: string
    status*: string

  AnalyzeResponse* = object
    query*: string
    results*: seq[SearchResult]
    total*: int

  # Config types
  Config* = object
    serperApiKey*: string
    port*: int
    maxHtmlSize*: int
    cacheDir*: string
    pythonPath*: string

  # Error types
  ScraperError* = object of CatchableError
    code*: int
    message*: string
