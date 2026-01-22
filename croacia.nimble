# Package

version       = "0.1.0"
author        = "Croacia"
description   = "Competitive Intelligence API - Brasil"
license       = "MIT"

# Dependencies

requires "nim >= 1.6.0"
requires "jesterfork >= 1.0.0"
requires "htmlparser"

# Tasks

task dev, "Run development server":
  exec "nim c -r src/main.nim"

task build, "Build release":
  exec "nim c -d:release -o:croacia src/main.nim"

task clean, "Clean build files":
  exec "rm -f src/main src/scraper *.o"