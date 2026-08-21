# Absurd Starter

A pragmatic Dart web starter using:

- Netto for the HTTP server
- htmdart/htmleez for server-rendered HTML and HTMX attributes
- HTMX for partial updates
- hyperscript for tiny client-side behaviors
- Tailwind CSS and Basecoat for styling/components
- Lucide icons generated into Dart helpers
- Docker for deployment

## Commands

```sh
dart pub get
make css
make lucide
make dev
```

## Verification

```sh
dart analyze
dart test
```

## Structure

- `bin/server.dart`: server entry point, hot reload, shutdown handling
- `lib/router.dart`: route wiring
- `lib/src/ui/layout/primary_layout.dart`: base HTML layout and assets
- `lib/src/ui/basecoat/`: reusable Dart helpers for Basecoat components
- `lib/src/ui/pages/home_page.dart`: starter page and HTMX demo
- `lib/src/utils/htmx.dart`: response/request helpers for HTMX
- `lib/src/ui/components/hyperscript.dart`: reusable hyperscript snippets
- `bin/generate_lucide.dart`: downloads Lucide SVGs and generates `lib/src/ui/lucide.dart`
- `input.css`: Tailwind/Basecoat input
- `public/`: static assets
- `docs/`: LLM-oriented references for htmleez, htmdart, and Basecoat

## LLM Docs

- `docs/htmleez_llms.md`: Dart HTML builder reference
- `docs/htmdart_llms.md`: HTMX attributes, events, and response headers
- `docs/basecoat-llms.md`: Basecoat component/class reference
- `docs/basecoat-kitchen-sink.html`: broad Basecoat markup examples

## Docker

```sh
docker build . -t absurd-starter
docker run --rm -p 8080:8080 absurd-starter
```
