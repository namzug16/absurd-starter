import "dart:convert";

import "package:absurd_starter/generated/html.dart";
import "package:absurd_starter/src/ui/basecoat/basecoat.dart" as bc;
import "package:test/test.dart";

Fragment text(String value) => Html.basecoat.text(text: value);
String element(String html, String id) => RegExp('<[^>]+\\bid="${RegExp.escape(id)}"[^>]*>').firstMatch(html)!.group(0)!;
String escaped(String value) => const HtmlEscape(HtmlEscapeMode.attribute).convert(value).replaceAll("'", "&#39;");

void main() {
  const fruits = [bc.Item(label: "Apple", value: "apple"), bc.Item(label: "Pear", value: "pear")];

  test("popover composes fragments, escapes attributes and protects wiring", () {
    final html = bc
        .popover(
          id: "help",
          trigger: text("Help <&>"),
          body: bc.toast(title: "Saved"),
          mainAttrs: {"class": "w-full", "id": "wrong", "hx-get": "/help?x=1&y=2"},
          triggerAttrs: {"class": "btn", "aria-controls": "wrong", "data-note": '" onmouseover="bad'},
          popoverAttrs: {"data-side": "top"},
        )
        .toHtml();
    expect(html, contains('class="popover w-full"'));
    expect(html, contains('hx-get="/help?x=1&amp;y=2"'));
    expect(html, contains('data-note="&quot; onmouseover=&quot;bad"'));
    expect(html, contains('aria-controls="help-popover"'));
    expect(html, contains('data-side="top"'));
    expect(html, contains("Help &lt;&amp;&gt;"));
    expect(html, contains('class="toast"'));
    expect(html, isNot(contains('id="wrong"')));
    expect(html, isNot(contains("<x-")));
  });

  test("dropdown renders recursive groups, links, separators and rich content", () {
    final html = bc
        .dropdownMenu(
          id: "account",
          trigger: text("Account"),
          items: [
            bc.Item(
              type: bc.ItemType.group,
              label: "Team",
              items: [
                bc.Item(
                  type: bc.ItemType.group,
                  label: "Members",
                  items: [
                    bc.Item(
                      label: "Gustavo",
                      url: "/members/1",
                      icon: Html.basecoat.icon(name: "user"),
                      content: text("Profile"),
                    ),
                  ],
                ),
              ],
            ),
            const bc.Item(type: bc.ItemType.separator),
            const bc.Item(label: "Delete", disabled: true, attrs: {"hx-delete": "/account"}),
          ],
        )
        .toHtml();
    expect(html, contains('aria-labelledby="group-label-account-items-1-1"'));
    expect(html, contains('id="account-items-1-1-1" href="/members/1" role="menuitem"'));
    expect(html, contains('data-lucide="user"'));
    expect(html, contains("Profile"));
    expect(html, contains('<hr role="separator">'));
    expect(html, contains('aria-disabled="true"'));
    expect(html, contains('hx-delete="/account"'));
  });

  test("dropdown preserves checkbox/radio roles without duplicate attributes", () {
    final html = bc
        .dropdownMenu(
          trigger: text("Options"),
          items: const [
            bc.Item(label: "Notifications", attrs: {"role": "menuitemcheckbox", "aria-checked": "false"}),
            bc.Item(label: "Light", attrs: {"role": "menuitemradio", "aria-checked": "true"}),
          ],
        )
        .toHtml();
    expect(html, contains('role="menuitemcheckbox" aria-checked="false"'));
    expect(html, contains('role="menuitemradio" aria-checked="true"'));
    expect(html, isNot(contains('role="menuitem"')));
    expect(
      () => bc.dropdownMenu(
        trigger: text("Options"),
        items: const [
          bc.Item(attrs: {"role": "invalid"}),
        ],
      ),
      throwsArgumentError,
    );
  });

  test("combobox preserves a single initial label without a loaded option", () {
    final html = bc.combobox(id: "remote", selected: [(value: "42", label: "Alice <&>")]).toHtml();
    expect(html, contains('role="combobox" value="Alice &lt;&amp;&gt;"'));
    expect(html, contains('type="hidden" value="42"'));
    final multiple = bc.combobox(multiple: true, objectFormat: true, selected: [(value: "42", label: "Alice")]).toHtml();
    expect(
      multiple,
      contains(
        'value="${escaped(jsonEncode([
          {"value": "42", "label": "Alice"},
        ]))}"',
      ),
    );
  });

  test("dialog optional regions and trigger do not interpolate IDs into JS", () {
    final html = bc.dialog(id: "details'quoted", trigger: text("Open"), title: "<Details>", description: "A & B", body: text("Body"), footer: text("Footer"), open: true).toHtml();
    expect(html, contains("&lt;Details&gt;"));
    expect(html, contains("A &amp; B"));
    expect(html, contains("document.getElementById(this.dataset.dialogId).showModal()"));
    expect(html, isNot(contains("getElementById('details")));
    expect(html, contains("<section >Body"));
    expect(html, contains("<footer >Footer"));
    expect(html, contains('aria-label="Close dialog"'));
    expect(html, isNot(contains("data-temporary-dialog")));

    final minimal = bc.dialog(id: "minimal", dialogAttrs: {"aria-label": "Details"}, closeButton: false, closeOnOverlayClick: false).toHtml();
    expect(minimal, isNot(contains("<header")));
    expect(minimal, isNot(contains("<section")));
    expect(minimal, isNot(contains("<footer")));
    expect(minimal, isNot(contains("onclick")));
    expect(minimal, isNot(contains("aria-labelledby")));
    expect(minimal, contains('aria-label="Details"'));
  });

  test("command and command dialog share search/menu wiring", () {
    const items = [
      bc.Item(
        type: bc.ItemType.group,
        label: "Navigation",
        items: [bc.Item(label: "Settings", url: "/settings", keywords: "preferences", disabled: true)],
      ),
    ];
    for (final fragment in [bc.command(id: "search", items: items, emptyText: "Nothing & more"), bc.commandDialog(id: "search", items: items, emptyText: "Nothing & more", open: true)]) {
      final html = fragment.toHtml();
      expect(html, contains('id="search-input"'));
      expect(html, contains('aria-controls="search-menu"'));
      expect(html, contains('data-empty="Nothing &amp; more"'));
      expect(html, contains('data-keywords="preferences"'));
      expect(html, contains('aria-disabled="true"'));
      expect(html, contains('<span role="heading"'));
    }
    expect(element(bc.commandDialog(id: "palette", open: true).toHtml(), "palette"), contains("open "));
    expect(bc.command(body: text("Custom command")).toHtml(), contains("Custom command"));
  });

  test("select picks first enabled option or preserves placeholder", () {
    final html = bc
        .select(
          id: "fruit",
          items: [
            const bc.Item(label: "Unavailable", value: "no", disabled: true),
            ...fruits,
          ],
        )
        .toHtml();
    expect(html, contains('name="fruit-value" value="apple"'));
    expect(html, contains('data-value="apple" aria-selected="true"'));
    expect(html, contains('<span class="truncate">Apple</span>'));
    final placeholder = bc.select(items: fruits, placeholder: "Choose a fruit").toHtml();
    expect(placeholder, contains('data-placeholder="Choose a fruit"'));
    expect(placeholder, contains('value=""'));
    expect(placeholder, isNot(contains('aria-selected="true"')));
    final empty = bc.select(items: fruits, multiple: true).toHtml();
    expect(empty, contains('value="[]"'));
    expect(empty, isNot(contains('aria-selected="true"')));
  });

  test("select recursively resolves labels, selection and JSON", () {
    final html = bc
        .select(
          id: "fruit",
          name: "fruits",
          multiple: true,
          objectFormat: true,
          closeOnSelect: true,
          selected: ["apple", "pear"],
          items: [
            const bc.Item(
              type: bc.ItemType.group,
              label: "Fruit",
              items: [bc.Item(type: bc.ItemType.group, label: "Available", items: fruits)],
            ),
          ],
        )
        .toHtml();
    expect(html, contains('<span class="truncate">Apple, Pear</span>'));
    expect(html, contains('data-format="object"'));
    expect(html, contains('aria-multiselectable="true"'));
    expect(html, contains('data-close-on-select="true"'));
    expect(
      html,
      contains(
        'value="${escaped(jsonEncode([
          {"value": "apple", "label": "Apple"},
          {"value": "pear", "label": "Pear"},
        ]))}"',
      ),
    );
    expect('aria-selected="true"'.allMatches(html), hasLength(2));
    final single = bc.select(items: fruits, selected: ["pear", "apple"]).toHtml();
    expect(single, contains('value="apple"'));
    expect('aria-selected="true"'.allMatches(single), hasLength(1));
    expect(
      bc
          .select(
            items: const [bc.Item(label: "Label only")],
            selected: ["Label only"],
          )
          .toHtml(),
      contains('value="Label only"'),
    );
  });

  test("select JSON survives quotes, apostrophes, ampersands and angle brackets", () {
    const value = 'a"&<b>';
    const label = "Pear's <label>";
    final html = bc
        .select(
          items: const [bc.Item(value: value, label: label)],
          selected: [value],
          objectFormat: true,
        )
        .toHtml();
    expect(html, contains('value="${escaped(jsonEncode({"value": value, "label": label}))}"'));
    expect(html, isNot(contains("<label>")));
    final custom = bc.select(body: text("Custom options"), selected: ["pear"], selectedLabel: "Pear").toHtml();
    expect(custom, contains("Custom options"));
    expect(custom, contains('value="pear"'));
    expect(custom, contains('<span class="truncate">Pear</span>'));
  });

  test("combobox supports plain, clear, multiple and object selections", () {
    final plain = bc.combobox(id: "fruit", name: "fruit", items: fruits, selected: [(value: "pear", label: "Pear")], placeholder: "Find fruit", autoHighlight: true).toHtml();
    expect(plain, contains('class="combobox-trigger-icon"'));
    expect(plain, contains('data-auto-highlight="true"'));
    expect(plain, contains('name="fruit" value="pear"'));
    expect(plain, isNot(contains("data-clear")));
    expect('role="combobox"'.allMatches(plain), hasLength(1));
    final clear = bc.combobox(id: "fruit", clear: true, inputAttrs: {"class": "w-full", "id": "fruit-input", "aria-label": "Fruit"}).toHtml();
    expect(clear, contains('class="input-group w-full"'));
    expect(clear, contains("data-clear"));
    expect(clear, contains('id="fruit-input"'));
    expect(clear, isNot(contains('class="combobox-trigger-icon"')));
    final multiple = bc.combobox(items: fruits, multiple: true, clear: true, closeOnSelect: true, objectFormat: true, selected: [(value: "pear", label: "Pear")]).toHtml();
    expect(multiple, contains('aria-multiselectable="true"'));
    expect(multiple, contains('data-close-on-select="true"'));
    expect(
      multiple,
      contains(
        'value="${escaped(jsonEncode([
          {"value": "pear", "label": "Pear"},
        ]))}"',
      ),
    );
    expect(multiple, isNot(contains("data-clear")));
    expect('role="combobox"'.allMatches(multiple), hasLength(1));
    expect(bc.combobox(objectFormat: true).toHtml(), contains('value="null"'));
  });

  test("sidebar renders closed state, slots, groups and nested submenus", () {
    final html = bc
        .sidebar(
          id: "navigation",
          open: false,
          side: "right",
          header: text("Workspace"),
          footer: text("Signed in"),
          menu: const [
            bc.Item(
              type: bc.ItemType.group,
              label: "Workspace",
              items: [
                bc.Item(label: "Overview", url: "/", current: true),
                bc.Item(
                  type: bc.ItemType.submenu,
                  label: "Settings",
                  open: true,
                  items: [bc.Item(label: "Team", url: "/team")],
                ),
              ],
            ),
          ],
        )
        .toHtml();
    expect(element(html, "navigation"), contains('data-side="right" aria-hidden="true" inert'));
    expect(html, contains('data-initial-open="false"'));
    expect(html, contains('aria-current="page"'));
    expect(html, contains('<details id="submenu-navigation-content-1-2" open'));
    expect(html, contains('aria-controls="submenu-navigation-content-1-2-content"'));
    expect(html, contains('href="/team"'));
    expect(html, contains("Workspace"));
    expect(html, contains("Signed in"));
    expect(() => bc.sidebar(side: "middle"), throwsArgumentError);
    expect(
      () => bc.dropdownMenu(
        trigger: text("Menu"),
        items: const [bc.Item(type: bc.ItemType.submenu)],
      ),
      throwsArgumentError,
    );
  });

  test("tabs wire panels, hide inactive content and skip disabled defaults", () {
    final sets = [
      bc.TabSet(tab: text("Unavailable"), panel: text("Disabled panel"), tabAttrs: {"disabled": ""}),
      bc.TabSet(tab: text("Account"), panel: text("Account panel")),
      bc.TabSet(tab: text("Billing"), panel: text("Billing panel")),
    ];
    final html = bc.tabs(id: "settings", tabsets: sets, tablistAttrs: {"aria-orientation": "vertical", "data-variant": "line"}).toHtml();
    expect(html, contains('aria-orientation="vertical" data-variant="line"'));
    expect(element(html, "settings-tab-1"), contains('aria-selected="false" tabindex="-1"'));
    expect(element(html, "settings-tab-2"), contains('aria-controls="settings-panel-2" aria-selected="true" tabindex="0"'));
    expect(element(html, "settings-panel-2"), isNot(contains("hidden")));
    expect(element(html, "settings-panel-3"), contains("hidden"));
    expect(element(bc.tabs(id: "settings", tabsets: sets, defaultTabIndex: 3).toHtml(), "settings-tab-3"), contains('aria-selected="true"'));
    expect(element(bc.tabs(id: "settings", tabsets: sets, defaultTabIndex: 99).toHtml(), "settings-tab-2"), contains('aria-selected="true"'));
    expect(bc.tabs().toHtml(), contains('class="tabs"'));
    expect(
      bc
          .tabs(
            tabsets: [
              bc.TabSet(tab: text("Disabled"), tabAttrs: {"aria-disabled": "true"}),
            ],
          )
          .toHtml(),
      isNot(contains('tabindex="0"')),
    );
    expect(() => bc.tabs(tablistAttrs: {"aria-orientation": "diagonal"}), throwsArgumentError);
  });

  test("toaster and toasts preserve categories, durations, actions and escaping", () {
    for (final category in ["success", "error", "info", "warning"]) {
      final html = bc
          .toaster(
            toasts: [
              bc.toast(
                category: category,
                title: "Saved <&>",
                description: "Changes saved",
                duration: -1,
                action: const bc.ToastAction(label: "View", href: "/changes?x=1&y=2"),
                cancel: const bc.ToastAction(label: "Dismiss", onclick: "console.log('dismiss')"),
              ),
            ],
            attrs: {"hx-swap-oob": "beforeend"},
          )
          .toHtml();
      expect(html, contains('id="toaster"'));
      expect(html, contains('hx-swap-oob="beforeend"'));
      expect(html, contains('role="${category == "error" ? "alert" : "status"}"'));
      expect(html, contains('data-category="$category" data-duration="-1"'));
      expect(html, contains('href="/changes?x=1&amp;y=2"'));
      expect(html, contains("data-toast-action"));
      expect(html, contains('data-variant="outline" data-toast-cancel'));
      expect(html, contains("Saved &lt;&amp;&gt;"));
    }
    final minimal = bc.toast(icon: text("Custom icon")).toHtml();
    expect(minimal, contains("Custom icon"));
    expect(minimal, isNot(contains("<footer")));
    expect(minimal, isNot(contains("<h2")));
    expect(minimal, isNot(contains("data-duration")));
    expect(() => bc.toast(category: "unknown"), throwsArgumentError);
    expect(
      bc
          .toast(
            action: const bc.ToastAction(label: "Confirm"),
            cancel: const bc.ToastAction(label: "Cancel", href: "/cancel"),
          )
          .toHtml(),
      contains('data-variant="outline" data-toast-cancel'),
    );
  });

  test("generated IDs are unique and malformed attributes/unsafe URLs fail", () {
    final a = bc.popover(trigger: text("Open")).toHtml();
    final b = bc.popover(trigger: text("Open")).toHtml();
    expect(RegExp('id="([^"]+)"').firstMatch(a)!.group(1), isNot(RegExp('id="([^"]+)"').firstMatch(b)!.group(1)));
    for (final name in ["x onclick", 'x"', "CLASS"]) {
      expect(() => bc.toast(attrs: {name: "bad"}), throwsArgumentError);
    }
    for (final url in ["javascript:alert(1)", "JaVaScRiPt:alert(1)", "java\nscript:alert(1)", "data:text/html,bad", " javascript:alert(1)"]) {
      expect(
        () => bc.dropdownMenu(
          trigger: text("Open"),
          items: [bc.Item(url: url)],
        ),
        throwsArgumentError,
      );
      expect(
        () => bc.toast(
          action: bc.ToastAction(label: "Open", href: url),
        ),
        throwsArgumentError,
      );
    }
    expect(() => bc.popover(id: "bad id", trigger: text("Open")), throwsArgumentError);
    expect(() => bc.popover(id: "", trigger: text("Open")), throwsArgumentError);
    expect(() => bc.toast(attrs: {"formaction": "javascript:alert(1)"}), throwsArgumentError);
  });
}
