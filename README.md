# Absurd Starter

Absurd Starter is a pragmatic Dart web template for building small,
server-driven web apps without pulling in a SPA stack.

It combines Netto, hotreloader, server-rendered HTML, HTMX fragments, tiny
client-side behavior with hyperscript, Tailwind CSS, Basecoat UI, and generated
Lucide icon helpers. The goal is to make the common path fast: add routes,
return full pages or fragments, style with Tailwind/Basecoat classes, iterate
quickly in development, and ship a Docker image.

The starter uses:

- Netto for the HTTP server
- hotreloader for faster local development iterations
- htmdart/htmleez for server-rendered HTML and HTMX attributes
- HTMX for partial updates
- hyperscript for tiny client-side behaviors
- Tailwind CSS and Basecoat for styling/components
- Lucide icons generated into Dart helpers
- Docker for deployment

## Quick Start

```sh
dart pub get
make css
make lucide
make dev
```

Open `http://localhost:8080`.

## Common Commands

```sh
make dev       # run the development server with hot reload enabled
make prod      # run the server without DEV=true
make css       # rebuild public/index.css from input.css
make basecoat  # download Basecoat CSS bundles and JS
make lucide    # regenerate lib/src/ui/lucide.dart from Lucide SVGs
```

`make dev` runs `DEV=true dart run --enable-vm-service bin/server.dart`, using
Netto for the HTTP server and hotreloader/dev reload wiring for faster feedback
while editing Dart files.

## Verification

```sh
dart analyze
dart test
```

## How To

### Add A Page

1. Create a page function under `lib/src/ui/pages/`.
2. Wrap full pages with `primaryLayout(...)` from `lib/src/ui/layout/primary_layout.dart`.
3. Register the route in `lib/router.dart`.
4. Return HTML with `ctx.response.htmlPage(...)`.

### Return An HTMX Fragment

Use the HTMX attributes from `htmdart` in your markup, then return only the
fragment that should replace the target.

```dart
form([
  $hx.post("/api/counter/increment"),
  $hx.target("#counter-result"),
  $hx.swap("outerHTML"),
  // ...
]);
```

For response helpers, see `lib/src/utils/htmx.dart`. For syntax examples, see
`docs/htmdart_llms.md`.

### Update Basecoat CSS And JS

Basecoat assets are vendored into the repo so the app does not depend on a CDN
for component CSS or JS at runtime.

```sh
make basecoat
```

This runs `dart run bin/download_basecoat.dart`, which downloads the pinned
`basecoat-css` version into:

- `basecoat/*.cdn.min.css`
- `public/basecoat.all.min.js`

To change the Basecoat version, update `_version` in
`bin/download_basecoat.dart`, then run:

```sh
make basecoat
make css
```

The active theme import lives in `input.css`:

```css
@import "./basecoat/basecoat-vega.cdn.min.css";
```

Switch that import to another downloaded bundle, then run `make css`.

### Regenerate Lucide Icons

Lucide SVGs are converted into Dart helpers so icons can be used directly in
server-rendered markup.

```sh
make lucide
```

This runs `dart run bin/generate_lucide.dart` and writes
`lib/src/ui/lucide.dart`.

Do not hand-edit `lib/src/ui/lucide.dart`; change `_version` in
`bin/generate_lucide.dart` if you want a different Lucide release, then
regenerate.

Example usage:

```dart
import "package:absurd_starter/src/ui/lucide.dart";

button([
  $class("btn"),
  Lucide.plus([$class("size-4")]),
  "Add item".t,
]);
```

### Use Extra Components

Project-specific components live in `lib/src/ui/components/`.

- `hyperscript.dart`: reusable hyperscript snippets for HTMX loading states.
- `temporary_dialog.dart`: a self-contained temporary `<dialog>` component for
  HTMX/server responses.

`temporaryDialog(...)` is useful when a route returns a modal as an HTML
fragment. It opens itself when inserted into the DOM and removes itself after it
closes, so it is best for short-lived dialogs rather than persistent page
structure.

```dart
ctx.response.htmlFragments([
  div([
    $hx.swapOob("beforeend:body"),
    temporaryDialog(
      id: "item-details-dialog",
      title: "Item details",
      body: div(["Loaded from the server".t]),
    ),
  ]),
]);
```

## Basecoat Kitchen Sink

The repo includes Basecoat references to help both humans and agents translate
Basecoat examples into Dart markup:

- `docs/basecoat-llms.md`: Basecoat component/class reference.
- `docs/basecoat-kitchen-sink.html`: broad HTML examples for many Basecoat
  components.

When adding a new Basecoat component, check the kitchen sink HTML first, then
translate the markup into `htmdart`/`htmleez` Dart code. Keep Tailwind and
Basecoat classes in Dart files so Tailwind can discover them through
`@source "./lib/**/*.{dart}"` in `input.css`.

## Structure

- `bin/server.dart`: server entry point, hot reload, shutdown handling
- `lib/router.dart`: route wiring
- `lib/src/ui/layout/primary_layout.dart`: base HTML layout and assets
- `lib/src/ui/basecoat/`: reusable Dart helpers for Basecoat components
- `lib/src/ui/components/`: extra app/template components
- `lib/src/ui/pages/home_page.dart`: starter page and HTMX demo
- `lib/src/utils/htmx.dart`: response/request helpers for HTMX
- `lib/src/ui/components/hyperscript.dart`: reusable hyperscript snippets
- `lib/src/ui/components/temporary_dialog.dart`: temporary HTMX dialog helper
- `bin/download_basecoat.dart`: downloads pinned Basecoat CSS and JS assets
- `bin/generate_lucide.dart`: downloads Lucide SVGs and generates `lib/src/ui/lucide.dart`
- `input.css`: Tailwind/Basecoat input
- `public/`: static assets
- `docs/`: LLM-oriented references for htmleez, htmdart, and Basecoat

## LLM Docs

- `docs/htmleez_llms.md`: Dart HTML builder reference
- `docs/htmdart_llms.md`: HTMX attributes, events, and response headers
- `docs/basecoat-llms.md`: Basecoat component/class reference
- `docs/basecoat-kitchen-sink.html`: broad Basecoat markup examples

For agents: read `docs/basecoat-kitchen-sink.html` before implementing an
unfamiliar Basecoat component, then use `docs/htmleez_llms.md` and
`docs/htmdart_llms.md` for the Dart syntax.

## Docker

```sh
docker build . -t absurd-starter
docker run --rm -p 8080:8080 absurd-starter
```
