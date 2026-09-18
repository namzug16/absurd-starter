# AGENTS.md

## Fast Start Commands

- Install deps: `dart pub get`
- Run dev server with hot reload: `make dev`
- Run prod-like locally: `make prod`
- Rebuild Tailwind output: `make css`
- Regenerate Lucide icon wrapper: `make lucide`

## Verification Commands

- Analyze: `dart analyze`
- Tests: `dart test`
- Single test file: `dart test test/server_test.dart`

## Architecture Map

- Entry point: `bin/server.dart`
- Route wiring: `lib/router.dart`
- Generic pages: `lib/src/ui/pages/`
- Layout/assets: `lib/src/ui/layout/primary_layout.dart`
- Basecoat Dart component helpers: `lib/src/ui/basecoat/`
- HTMX helpers: `lib/src/utils/htmx.dart`
- hyperscript helpers: `lib/src/ui/components/hyperscript.dart`
- Lucide generator: `bin/generate_lucide.dart`

## Project Conventions

- Prefer server-rendered HTML and HTMX fragments over client-side state.
- Use `ctx.response.htmlPage`, `htmlFragments`, and `htmlFragmentsOob` for HTML responses.
- Keep Basecoat/Tailwind classes in Dart files so `make css` can discover them.
- Do not hand-edit `lib/src/ui/lucide.dart`; run `make lucide`.
- For htmleez syntax, use the `htmleez-html` skill; update installed skills with `dart run skills@ get`.
- For HTMX attributes, use htmleez custom attributes like `$("hx-post")("/route")`.
- For Basecoat markup/classes, reference `docs/basecoat-llms.md` and `docs/basecoat-kitchen-sink.html`.
