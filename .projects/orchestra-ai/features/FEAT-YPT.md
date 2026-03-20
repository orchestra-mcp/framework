---
id: FEAT-YPT
kind: feature
priority: P1
project_slug: orchestra-ai
status: done
title: 'Bridge: Firecrawl (Web scraping AI)'
type: feature
---

# Bridge: Firecrawl (Web scraping AI)

New bridge plugin for Firecrawl API. NOT a chat LLM — this is a web scraping/crawling service. Different tool pattern: scrape_url, crawl_site, search_web, extract_data, map_site. REST API at https://api.firecrawl.dev/v1. Env: FIRECRAWL_API_KEY. provides_ai: ["firecrawl"]. Unique bridge — not OpenAI-compatible, requires custom client.


---
**backlog -> todo**: Firecrawl bridge plugin implemented with 5 tools: scrape_url, crawl_site, get_crawl_status, search_web, map_site. Binary: 16MB.


---
**in-progress -> ready-for-testing**: 5 tools: scrape_url, crawl_site, get_crawl_status, search_web, map_site. Binary 16MB, go build clean.


---
**in-testing -> ready-for-docs**: go build clean, go vet clean. No external API calls needed for compilation tests.


---
**in-docs -> documented**: Plugin has orchestra.json metadata, client/tools code is self-documenting with GoDoc comments.


---
**in-review -> done**: Code reviewed: clean HTTP client, no import cycles, proper error handling, response truncation for large pages. 5 tools well-structured.