# Basecoat templates

App-owned ports of all 11 public macros in the **basecoat-css 1.0.2** Jinja
templates: combobox, command, command dialog, dialog, dropdown menu, popover,
select, sidebar, tabs, toast and toaster. Source:
<https://cdn.jsdelivr.net/npm/basecoat-css@1.0.2/templates/jinja/>.
Upstream MIT attribution is in `LICENSE.md` beside this file and applies to
the adapted HTML in `../templates/basecoat/` too.

All markup lives in `../templates/basecoat/`, one template per macro; `abs`
generates `Html.basecoat.*`. `basecoat.dart` prepares defaults, selection state, JSON and the
item records the templates loop over. There is no Jinja runtime, new dependency or gallery route.

```dart
import "package:absurd_starter/generated/html.dart";
import "package:absurd_starter/src/ui/basecoat/basecoat.dart" as bc;

final fruit = bc.select(
  id: "fruit",
  name: "fruit",
  placeholder: "Choose a fruit",
  items: const [
    bc.Item(value: "apple", label: "Apple"),
    bc.Item(value: "pear", label: "Pear"),
  ],
  selected: ["pear"],
);

final details = bc.dialog(
  id: "fruit-details",
  title: "Fruit details",
  trigger: "Open details",
  triggerAttrs: {"class": "btn", "data-variant": "outline"},
  body: fruit,
);
```

## Composition

- `body` replaces Jinja's `caller()`. Structured `items` / sidebar `menu`
  take precedence when nonempty. Triggers, bodies, slots, tabs and panels take
  a `String` (escaped text) or a `Fragment` (markup). Titles, descriptions and
  labels are escaped text; use an item's `content` / `icon` fragments for rich
  labels and `label` for its accessible/display text.
- `ItemType.group`, `separator`, and sidebar-only `submenu` nest one level,
  because templates cannot recurse: groups hold plain items, sidebar menus are
  groups (or separators) holding links and submenus, and submenus hold links.
  Deeper nesting throws `ArgumentError`.
  Each item supports `attrs`, `disabled`, `current`, `open`, `keywords`, `url`,
  `icon` and rich `content` where applicable.
  Dropdown items accept `attrs: {"role": "menuitemcheckbox", "aria-checked": "false"}`
  or `menuitemradio` for Basecoat's checkbox/radio behavior.
- Select `selected` is always a `List<String>`, including single mode.
  Combobox `selected` is a list of `(value: "pear", label: "Pear")` records.
  This replaces Jinja's polymorphic string/list/object parameter. Enable
  `objectFormat` for object JSON; otherwise hidden values are strings or JSON
  arrays. Select's `selectedLabel` supplies display text for custom `body` options.
  For multiple combobox selections whose options are not loaded yet, use
  `objectFormat: true` to retain their labels; Basecoat 1.0.2's value-only
  multiple initialization cannot recover labels without matching options.
- Tabs use `TabSet(tab: fragment, panel: fragment)`; `defaultTabIndex` is
  one-based. A disabled or invalid default falls back to the first enabled tab.
- Toaster takes already-composed `List<Fragment>` toasts. Toast's `action` /
  `cancel` use `ToastAction(label: ..., href: ... / onclick: ...)`.
- Explicit IDs must be unique in the document. Otherwise IDs are generated
  by a process-local counter. Use explicit IDs for HTMX targets and labels.
- `open: true` on a dialog renders native `open` (nonmodal), just like upstream.
  Use the generated trigger / `showModal()` for a modal. Existing temporary
  dialogs keep their separate auto-open/remove lifecycle.

## Attributes and safety

Extra attributes use `Map<String, String>` with lowercase names. Use `"disabled": ""`
for a boolean attribute; omit it for false. Root `class` values extend Basecoat's
required class. Structural IDs, roles and ARIA wiring cannot be overridden by
extra attributes. URLs passed through the composition API allow relative URLs,
HTTP(S), mailto and tel, not executable schemes.

Attribute maps are **trusted application code**, not user input: `onclick`,
`hx-*`, `style`, etc. can execute behavior. Attribute values are HTML-escaped,
but that does not sanitize JavaScript or CSS. The low-level generated functions
accept prepared props and do not run the composition API's validation.

Existing `public/index.js` initializes Lucide and Basecoat on load and HTMX swaps.
Do not add lifecycle scripts to templates. Popovers are inline: watch clipping
ancestors (`overflow-hidden` cards and scrollable tables).

To upgrade, compare the matching npm release's Jinja templates, port changes,
then run `abs check`, `abs`, `make css`, `dart analyze`, `dart test` and
`node --test test/index_test.js`.
