# AGENTS.md

## Commands

- Install deps: `dart pub get`
- Rebuild CSS/templates and run development: `make start`
- Generate templates and run development: `make dev`
- Generate templates and run prod-like locally: `make prod`
- Generate HTML Dart: `make templates` (`abs` 0.1.0 on PATH)
- Rebuild Tailwind: `make css`
- Vendor pinned Lucide browser JS: `make lucide`
- Verify in order: `abs check`, `abs`, `dart analyze`, `dart test`
- Focused test: `dart test test/server_test.dart`
- Browser initialization unit tests: `node --test test/index_test.js`

## Architecture

- Entry point: `bin/server.dart`
- Routes: `lib/router.dart`
- All markup: `lib/src/ui/templates/**/*.html`
- Template config: `abs.yaml` (input `lib/src/ui/templates`, output `lib/generated/html.dart`, class `Html`)
- Dart composition: `lib/src/ui/`
- HTMX helpers: `lib/src/utils/htmx.dart`
- Temporary dialog markup/composition: `lib/src/ui/templates/temporary-dialog.html`, `lib/src/ui/components/temporary_dialog.dart`
- Browser initialization: `public/index.js`
- Vendored Lucide: `public/js/lucide.min.js`

## Conventions

- Prefer server-rendered HTML and HTMX fragments over client-side state.
- Use the `absurd-templates` skill. Edit templates, run `abs check`, then `abs`; never hand-edit generated Dart. Commit generated output; it has no runtime dependency.
- All markup belongs in HTML templates. Compute values in Dart and compose generated `Fragment` values through typed props.
- Use `htmlPage(Fragment)` and `htmlFragments(List<Fragment>)`. For OOB updates, set `hx-swap-oob` directly in templates and return them with `htmlFragments`.
- Write `hx-*` attributes directly in templates. This project uses HTMX 4; initialization after swaps listens only to `htmx:after:swap`.
- Use `<i data-lucide="icon-name">` in templates. `public/index.js` initializes icons; never add inline initialization.
- `public/index.js` auto-opens/removes temporary dialog nodes marked `data-temporary-dialog`; do not put lifecycle scripts in templates.
- Tailwind scans HTML templates and non-generated Dart. Keep complete utility strings in these sources; run `make css` after class changes.
- Basecoat is CSS/JS only. Write its HTML directly where needed; do not add a wrapper layer or a component catalog.
- Basecoat references: `docs/basecoat-llms.md` and `docs/basecoat-kitchen-sink.html`.
