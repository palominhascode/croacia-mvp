# Package

version       = "0.1.0"
author        = "Palominhas Code"
description   = "Competitive Intelligence API - Stateless Web Scraper"
license       = "MIT"

# Source and binary configuration
srcDir        = "src/core"
bin           = @["croacia_mvp"]
binDir        = "build"

# Dependencies

requires "nim >= 2.2.0"
requires "jesterfork >= 1.0.0"
requires "htmlparser"

# Tasks

task dev, "Run development server":
  # O -d:ssl e --mm:arc já virão do config.nims automaticamente
  exec "nim c -r -d:debug src/core/croacia_mvp.nim"

task build, "Build release binary":
  # Agora você só precisa passar o que for específico desta tarefa (como -d:release)
  exec "nim c -d:release --opt:speed src/core/croacia_mvp.nim"

task build_docker, "Build Docker image (multi-stage)":
  echo "🐳 Building Docker image..."
  echo "   Using: Dockerfile (corrigido)"
  echo "   Target: croacia:latest"
  exec "docker build --no-cache -f Dockerfile -t croacia:latest ."
  echo "✅ Image created: croacia:latest"


task test_docker, "Test Docker image locally":
  echo "🧪 Testing Docker image..."
  exec "docker run -e SERPER_API_KEY=test -p 8080:8080 --rm croacia:latest"

task clean, "Clean build artifacts":
  echo "🗑️  Cleaning artifacts..."
  exec "rm -rf nimcache/ .nimcache/ htmldocs/ *.o *.out build/"
  echo "✅ Cleaned"

# ✅ ESTRUTURA FINAL:
# ───────────────────
# Source:   src/core/main.nim
# Output:   ./build/croacia_mvp (direto)
# Docker:   croacia:latest
#
# ✅ COMANDOS CORRETOS:
# ──────────────────
# - nimble dev          (dev com debug)
# - nimble build        (release otimizado) ← PADRÃO
# - nimble build_docker (docker image)
# - nimble test_docker  (testar image localmente)
# - nimble clean        (limpar cache)
