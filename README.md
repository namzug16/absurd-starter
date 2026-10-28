# Absurd Starter

A small server-rendered Dart starter: Relic, Absurd Templates, HTMX 4,
Tailwind CSS 4, Basecoat 1.0.2 and Lucide 1.33.0. No SPA stack.

## Quick Start

Requires Dart `^3.12.0`, Node/npm for Tailwind, and `abs` 0.1.0 on your PATH.

```sh
dart pub get
make start
```

Open `http://localhost:8080`. Generated HTML Dart and browser assets are
committed; there is no Absurd Templates runtime dependency. Only template
generation needs the `abs` CLI.

## Commands

```sh
make start      # rebuild CSS and templates before starting development
make dev        # regenerate templates, then run the server
make prod       # same server startup, without rebuilding CSS
make templates  # run abs using abs.yaml
make css        # rebuild public/index.css
make basecoat   # download pinned Basecoat CSS and JS
make lucide     # download pinned Lucide JS to public/js/lucide.min.js
```

Re-run `make templates` after editing markup; these commands do not watch files.
`make dev` and `make prod` do not rebuild CSS; use `make start` or `make css`
after changing utility classes. The start target waits for CSS before launching
the template-generation/server target, including with `make -j`.

## Templates And Dart Composition

All markup belongs in `lib/src/ui/templates/**/*.html`, including layouts, pages and small
fragments. `abs.yaml` configures input `lib/src/ui/templates`,
output `lib/generated/html.dart`, and entry class `Html`. Never hand-edit the
generated file; regenerate and commit it with template changes.

Templates declare typed props and render escaped values:

```html
<x-props title="String" content="Fragment"></x-props>
<section class="space-y-4">
  <h1>{{ title }}</h1>
  {{ content }}
</section>
```

Keep calculations and conditional utility strings in Dart. Compose typed
`Fragment` values from generated methods, then pass them to outer templates.
A template at `lib/src/ui/templates/section.html` generates `Html.section(...)`;
subdirectories become namespaces such as `Html.pages.home(...)`.

```dart
import 'package:absurd_starter/generated/html.dart';

Fragment section(Fragment content) => Html.section(
  title: 'Overview',
  content: content,
);
```

To add a page, create its HTML template, compose it with the layout in
`lib/src/ui/pages/`, register a route in `lib/router.dart`, and return
`htmlPage(Fragment)`. Use `htmlFragments(List<Fragment>)` for partial responses.
Both helpers live in `lib/src/utils/htmx.dart`.

Write HTMX attributes directly in HTML. For out-of-band updates, set
`hx-swap-oob` directly in templates and return them with `htmlFragments`.

### Verification

```sh
abs check
abs
dart analyze
dart test
node --test test/index_test.js
```

For a focused edit, use `abs check lib/src/ui/templates/path/to/template.html` first.
The `absurd-templates` agent skill describes syntax and composition patterns.

## Styling And Browser Behavior

Check `docs/basecoat-kitchen-sink.html` and `docs/basecoat-llms.md` for Basecoat
markup. Write that HTML directly in the page or fragment where it is needed;
there is no Basecoat wrapper layer or component catalog route.

`input.css` scans `lib/src/ui/templates/**/*.html` and Dart sources for complete utility
strings, excluding generated Dart. Do not assemble utility names dynamically
(for example, `bg-$color-600`); choose complete strings in Dart instead.
The active Basecoat theme is the import in `input.css`. To update assets,
change `_version` in `bin/download_basecoat.dart`, run `make basecoat`, then
`make css`.

### Lucide Icons

Use ordinary template markup:

```html
<i data-lucide="plus" class="size-4" aria-hidden="true"></i>
```

Give icon-only buttons an accessible label. The layout loads vendored
`public/js/lucide.min.js`; `public/index.js` initializes icons on page load and
after HTMX 4's `htmx:after:swap` event. Do not add inline initialization or
legacy HTMX event names to templates.

`make lucide` downloads the pinned UMD bundle from
`https://unpkg.com/lucide@1.33.0/dist/umd/lucide.min.js`. It replaces the existing
asset only after a successful download. Change the URL version in `Makefile`
to upgrade, then regenerate and commit the asset.

### Temporary Dialogs

`lib/src/ui/templates/temporary-dialog.html` owns dialog markup;
`lib/src/ui/components/temporary_dialog.dart` composes its fragments.
`public/index.js` automatically opens inserted nodes marked
`data-temporary-dialog` and removes them when closed. No inline scripts are
needed. Put OOB insertion attributes in the relevant HTML template.

## Structure

- `bin/server.dart`: entry point and shutdown handling
- `lib/router.dart`: routes
- `lib/src/ui/templates/`: all HTML templates
- `abs.yaml`: template compiler configuration
- `lib/generated/html.dart`: committed, generated `Html` methods and `Fragment`
- `lib/src/ui/`: Dart composition and page logic
- `lib/src/utils/htmx.dart`: HTML response/request helpers
- `input.css`: Tailwind sources and Basecoat theme
- `public/`: committed CSS and vendored browser assets
- `docs/`: Basecoat markup references

## Docker

Regenerate templates and CSS before packaging changes:

```sh
make templates css
docker build . -t absurd-starter
docker run --rm -p 8080:8080 absurd-starter
```
