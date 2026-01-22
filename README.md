# 🌍 Croácia MVP - Web Scraper

Modern web scraper built with Nim + Async + Python bridge

## ✨ Features

- Async HTTP requests
- Cloudscraper fallback for Cloudflare
- Caching layer
- Docker ready
- Fly.io ready

## 🚀 Quick Start

### Local Development
```bash
# Setup
bash scripts/setup.sh

# Dev server
bash scripts/local_dev.sh

# Tests
bash test/scripts/test.sh
```

### Docker
```bash
docker-compose up
```

### Production
```bash
flyctl deploy
```

## 📋 Requirements

- Nim 1.6+
- Python 3.8+
- Cloudscraper library

## 📚 Documentation

- [Architecture](docs/ARCHITECTURE.md)
- [API](docs/API.md)
- [Deployment](docs/DEPLOYMENT.md)

## 📄 License

MIT
