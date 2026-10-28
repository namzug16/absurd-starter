import "dart:convert";

import "package:absurd_starter/generated/html.dart";

enum ItemType { item, group, separator, submenu }

class Item {
  const Item({this.label = "", this.value, this.url, this.icon, this.content, this.items = const [], this.type = ItemType.item, this.attrs = const {}, this.disabled = false, this.current = false, this.open = false, this.keywords});

  final String label;
  final String? value;
  final String? url;
  final Fragment? icon;
  final Fragment? content;
  final List<Item> items;
  final ItemType type;
  final Map<String, String> attrs;
  final bool disabled;
  final bool current;
  final bool open;
  final String? keywords;
}

class TabSet {
  const TabSet({required this.tab, this.panel, this.tabAttrs = const {}, this.panelAttrs = const {}});

  /// Escaped text (`String`) or markup (`Fragment`).
  final Object tab;
  final Object? panel;
  final Map<String, String> tabAttrs;
  final Map<String, String> panelAttrs;
}

class ToastAction {
  const ToastAction({required this.label, this.href, this.onclick});

  final String label;
  final String? href;
  final String? onclick;
}

int _nextId = 0;

String _id(String? id, String prefix) {
  final result = id ?? "bc-$prefix-${++_nextId}";
  if (result.isEmpty || RegExp(r"\s").hasMatch(result)) {
    throw ArgumentError.value(id, "id", "Must be nonempty without whitespace");
  }
  return result;
}

String _url(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null || RegExp(r"[\x00-\x20\x7f]").hasMatch(url) || (uri.hasScheme && !const {"http", "https", "mailto", "tel"}.contains(uri.scheme.toLowerCase()))) {
    throw ArgumentError.value(url, "url", "Expected a relative, HTTP(S), mailto or tel URL");
  }
  return url;
}

// Attribute maps are developer-authored: event handlers and hx-* values are executable behavior, not user data.
Map<String, String> _attrs(Map<String, String> attrs, {String? className, List<String> reserved = const []}) {
  final result = <String, String>{};
  for (final entry in attrs.entries) {
    if (!RegExp(r"^[a-z_:][a-z0-9_.:-]*$").hasMatch(entry.key)) {
      throw ArgumentError.value(entry.key, "attribute", "Expected a lowercase HTML attribute name");
    }
    if (reserved.contains(entry.key)) continue;
    result[entry.key] = const {"href", "src", "action", "formaction"}.contains(entry.key) ? _url(entry.value) : entry.value;
  }
  if (className != null) result["class"] = [className, ?result["class"]].join(" ");
  return result;
}

const _rootReserved = ["id"];
const _triggerReserved = ["id", "type", "aria-controls", "aria-expanded", "aria-haspopup"];
const _popoverReserved = ["id", "data-popover", "aria-hidden"];
const _listboxReserved = ["id", "role", "aria-orientation", "aria-labelledby", "aria-multiselectable"];
const _searchReserved = ["type", "role", "placeholder", "autocomplete", "autocorrect", "spellcheck", "aria-autocomplete", "aria-expanded", "aria-controls"];
const _groupReserved = ["role", "aria-labelledby"];

// Records the templates iterate. Templates cannot recurse, so menus nest one level: groups hold plain items.
typedef _Option = ({String id, String value, String label, bool selected, Object content, Map<String, String> attrs});
typedef _ListboxEntry = ({bool isOption, bool isGroup, bool isSeparator, String id, String value, String label, bool selected, Object content, Map<String, String> attrs, List<_Option> options});
typedef _MenuItem = ({bool isLink, String id, String href, String role, Object? icon, Object content, Map<String, String> attrs});
typedef _MenuEntry = ({bool isItem, bool isGroup, bool isSeparator, bool isLink, String id, String href, String role, String label, Object? icon, Object content, Map<String, String> attrs, List<_MenuItem> items});
typedef _SidebarLink = ({String href, bool current, Object? icon, Object content, Map<String, String> attrs});
typedef _SidebarItem = ({bool isSubmenu, String id, String href, bool current, bool open, Object? icon, Object content, Map<String, String> attrs, List<_SidebarLink> items});
typedef _SidebarEntry = ({bool isGroup, bool isSeparator, String id, String label, bool hasLabel, Map<String, String> attrs, List<_SidebarItem> items});

Fragment popover({String? id, required Object trigger, Object? body, Map<String, String> mainAttrs = const {}, Map<String, String> triggerAttrs = const {}, Map<String, String> popoverAttrs = const {}}) => Html.basecoat.popover(
  id: _id(id, "popover"),
  trigger: trigger,
  body: body,
  mainAttrs: _attrs(mainAttrs, className: "popover", reserved: _rootReserved),
  triggerAttrs: _attrs(triggerAttrs, reserved: _triggerReserved),
  popoverAttrs: _attrs(popoverAttrs, reserved: _popoverReserved),
);

Fragment dropdownMenu({String? id, required Object trigger, List<Item> items = const [], Object? body, Map<String, String> mainAttrs = const {}, Map<String, String> triggerAttrs = const {}, Map<String, String> popoverAttrs = const {}, Map<String, String> menuAttrs = const {}}) {
  id = _id(id, "dropdown-menu");
  return Html.basecoat.dropdownMenu(
    id: id,
    trigger: trigger,
    items: _menu(items, "$id-items", dropdown: true),
    body: items.isEmpty ? body : null,
    mainAttrs: _attrs(mainAttrs, className: "dropdown-menu", reserved: _rootReserved),
    triggerAttrs: _attrs(triggerAttrs, reserved: _triggerReserved),
    popoverAttrs: _attrs(popoverAttrs, reserved: _popoverReserved),
    menuAttrs: _attrs(menuAttrs, reserved: ["id", "role", "aria-labelledby"]),
  );
}

Fragment dialog({
  String? id,
  Object? trigger,
  String? title,
  String? description,
  Object? body,
  Object? footer,
  bool open = false,
  bool closeButton = true,
  bool closeOnOverlayClick = true,
  Map<String, String> dialogAttrs = const {},
  Map<String, String> triggerAttrs = const {},
  Map<String, String> headerAttrs = const {},
  Map<String, String> bodyAttrs = const {},
  Map<String, String> footerAttrs = const {},
}) {
  final hasTitle = title != null && title.isNotEmpty;
  final hasDescription = description != null && description.isNotEmpty;
  return Html.basecoat.dialog(
    id: _id(id, "dialog"),
    trigger: trigger,
    title: title,
    description: description,
    body: body,
    footer: footer,
    hasTrigger: trigger != null,
    hasTitle: hasTitle,
    hasDescription: hasDescription,
    hasHeader: hasTitle || hasDescription,
    hasBody: body != null,
    hasFooter: footer != null,
    open: open,
    closeButton: closeButton,
    closeOnOverlayClick: closeOnOverlayClick,
    dialogAttrs: _attrs(dialogAttrs, className: "dialog", reserved: ["id", "open", "onclick", if (hasTitle) "aria-labelledby", if (hasDescription) "aria-describedby"]),
    triggerAttrs: _attrs(triggerAttrs, reserved: ["type", "onclick", "data-dialog-id"]),
    headerAttrs: _attrs(headerAttrs),
    bodyAttrs: _attrs(bodyAttrs),
    footerAttrs: _attrs(footerAttrs),
  );
}

Fragment command({String? id, List<Item> items = const [], Object? body, String placeholder = "Type a command or search...", String emptyText = "No results found.", Map<String, String> mainAttrs = const {}, Map<String, String> inputAttrs = const {}, Map<String, String> menuAttrs = const {}}) {
  id = _id(id, "command");
  return Html.basecoat.command(
    id: id,
    placeholder: placeholder,
    emptyText: emptyText,
    items: _menu(items, "$id-items"),
    body: items.isEmpty ? body : null,
    mainAttrs: {
      "id": id,
      ..._attrs({"aria-label": "Command menu", ...mainAttrs}, className: "command", reserved: _rootReserved),
    },
    inputAttrs: _attrs(inputAttrs, reserved: ["id", ..._searchReserved]),
    menuAttrs: _attrs(menuAttrs, reserved: ["id", "role", "aria-orientation", "data-empty"]),
  );
}

Fragment commandDialog({
  String? id,
  List<Item> items = const [],
  Object? body,
  String placeholder = "Type a command or search...",
  String emptyText = "No results found.",
  bool open = false,
  Map<String, String> dialogAttrs = const {},
  Map<String, String> inputAttrs = const {},
  Map<String, String> menuAttrs = const {},
}) {
  id = _id(id, "command-dialog");
  return Html.basecoat.commandDialog(
    id: id,
    open: open,
    placeholder: placeholder,
    emptyText: emptyText,
    items: _menu(items, "$id-items"),
    body: items.isEmpty ? body : null,
    dialogAttrs: _attrs({"aria-label": "Command menu", ...dialogAttrs}, className: "command-dialog", reserved: ["id", "open", "onclick"]),
    commandAttrs: const {"class": "command"},
    inputAttrs: _attrs(inputAttrs, reserved: ["id", ..._searchReserved]),
    menuAttrs: _attrs(menuAttrs, reserved: ["id", "role", "aria-orientation", "data-empty"]),
  );
}

Iterable<Item> _options(List<Item> items) sync* {
  for (final item in items) {
    if (item.type == ItemType.group) {
      yield* _options(item.items);
    } else if (item.type == ItemType.item) {
      yield item;
    }
  }
}

Fragment select({
  String? id,
  String? name,
  List<Item> items = const [],
  List<String> selected = const [],
  Object? body,
  String? placeholder,
  String? selectedLabel,
  bool multiple = false,
  bool closeOnSelect = false,
  bool objectFormat = false,
  Map<String, String> mainAttrs = const {},
  Map<String, String> triggerAttrs = const {},
  Map<String, String> popoverAttrs = const {},
  Map<String, String> listboxAttrs = const {},
  Map<String, String> inputAttrs = const {},
}) {
  id = _id(id, "select");
  final options = _options(items).toList();
  var chosen = options.where((item) => selected.contains(item.value ?? item.label)).toList();
  if (!multiple) {
    if (chosen.isEmpty && selected.isEmpty && placeholder == null) {
      chosen = options.where((item) => !item.disabled && item.attrs["aria-disabled"] != "true").take(1).toList();
    } else {
      chosen = chosen.take(1).toList();
    }
  }
  final values = items.isEmpty ? (multiple ? selected : selected.take(1)).toList() : chosen.map((item) => item.value ?? item.label).toList();
  final labels = items.isEmpty ? values.map((value) => selectedLabel ?? value).toList() : chosen.map((item) => item.attrs["data-label"] ?? item.label).toList();
  final payload = [
    for (var i = 0; i < values.length; i++) {"value": values[i], "label": labels[i]},
  ];
  final value = objectFormat ? jsonEncode(multiple ? payload : payload.firstOrNull) : (multiple ? jsonEncode(values) : values.firstOrNull ?? "");
  return Html.basecoat.select(
    id: id,
    name: name ?? "$id-value",
    label: selectedLabel ?? (labels.isEmpty ? placeholder ?? "" : labels.join(", ")),
    value: value,
    multiple: multiple,
    objectFormat: objectFormat,
    placeholder: placeholder,
    hasPlaceholder: placeholder != null,
    closeOnSelect: multiple && closeOnSelect,
    items: _listbox(items, "$id-items", values),
    body: items.isEmpty ? body : null,
    mainAttrs: _attrs(mainAttrs, className: "select", reserved: ["id", "data-format", "data-placeholder", "data-close-on-select"]),
    triggerAttrs: _attrs(triggerAttrs, reserved: _triggerReserved),
    popoverAttrs: _attrs(popoverAttrs, reserved: _popoverReserved),
    listboxAttrs: _attrs(listboxAttrs, reserved: _listboxReserved),
    inputAttrs: _attrs(inputAttrs, reserved: ["type", "name", "value"]),
  );
}

Fragment combobox({
  String? id,
  String? name,
  List<Item> items = const [],
  List<({String value, String label})> selected = const [],
  Object? body,
  String placeholder = "",
  bool multiple = false,
  bool clear = false,
  bool autoHighlight = false,
  bool closeOnSelect = false,
  bool objectFormat = false,
  Map<String, String> mainAttrs = const {},
  Map<String, String> inputAttrs = const {},
  Map<String, String> popoverAttrs = const {},
  Map<String, String> listboxAttrs = const {},
  Map<String, String> hiddenInputAttrs = const {},
}) {
  id = _id(id, "combobox");
  final entries = (multiple ? selected : selected.take(1)).toList();
  // shortcut: absent multiple-option labels need objectFormat; add label hydration if value-only remote chips are needed.
  final payload = [
    for (final entry in entries) {"value": entry.value, "label": entry.label},
  ];
  final values = entries.map((entry) => entry.value).toList();
  final value = objectFormat ? jsonEncode(multiple ? payload : payload.firstOrNull) : (multiple ? jsonEncode(values) : values.firstOrNull ?? "");
  final showClear = clear && !multiple;
  return Html.basecoat.combobox(
    id: id,
    name: name,
    hasName: name != null,
    value: value,
    multiple: multiple,
    clear: showClear,
    plain: !multiple && !clear,
    objectFormat: objectFormat,
    autoHighlight: autoHighlight,
    closeOnSelect: multiple && closeOnSelect,
    placeholder: placeholder,
    inputValue: multiple ? "" : entries.firstOrNull?.label ?? "",
    inputAttrs: _attrs(showClear ? ({...inputAttrs}..remove("class")) : inputAttrs, reserved: ["value", ..._searchReserved]),
    groupAttrs: _attrs({if (inputAttrs.containsKey("class")) "class": inputAttrs["class"]!}, className: "input-group"),
    items: _listbox(items, "$id-items", values),
    body: items.isEmpty ? body : null,
    mainAttrs: _attrs(mainAttrs, className: "combobox", reserved: ["id", "data-format", "data-auto-highlight", "data-close-on-select"]),
    popoverAttrs: _attrs(popoverAttrs, reserved: _popoverReserved),
    listboxAttrs: _attrs(listboxAttrs, reserved: _listboxReserved),
    hiddenInputAttrs: _attrs(hiddenInputAttrs, reserved: ["type", "name", "value"]),
  );
}

Fragment sidebar({
  String? id,
  String label = "Sidebar navigation",
  String side = "left",
  bool open = true,
  Object? header,
  Object? footer,
  List<Item> menu = const [],
  Object? body,
  Map<String, String> mainAttrs = const {},
  Map<String, String> headerAttrs = const {},
  Map<String, String> contentAttrs = const {},
  Map<String, String> footerAttrs = const {},
}) {
  if (side != "left" && side != "right") throw ArgumentError.value(side, "side", "Expected left or right");
  id = _id(id, "sidebar");
  return Html.basecoat.sidebar(
    id: id,
    label: label,
    side: side,
    hidden: (!open).toString(),
    closed: !open,
    header: header,
    footer: footer,
    hasHeader: header != null,
    hasFooter: footer != null,
    items: _sidebar(menu, "$id-content"),
    body: menu.isEmpty ? body : null,
    mainAttrs: _attrs({"data-initial-open": open.toString(), ...mainAttrs}, className: "sidebar", reserved: ["id", "data-side", "aria-hidden", "inert"]),
    headerAttrs: _attrs(headerAttrs),
    contentAttrs: _attrs(contentAttrs),
    footerAttrs: _attrs(footerAttrs),
  );
}

Fragment tabs({String? id, List<TabSet> tabsets = const [], int defaultTabIndex = 1, Map<String, String> mainAttrs = const {}, Map<String, String> tablistAttrs = const {}}) {
  id = _id(id, "tabs");
  final orientation = tablistAttrs["aria-orientation"] ?? "horizontal";
  if (orientation != "horizontal" && orientation != "vertical") throw ArgumentError.value(orientation, "aria-orientation");
  bool disabled(TabSet tab) => tab.tabAttrs.containsKey("disabled") || tab.tabAttrs["aria-disabled"] == "true";
  var active = defaultTabIndex - 1;
  if (active < 0 || active >= tabsets.length || disabled(tabsets[active])) active = tabsets.indexWhere((tab) => !disabled(tab));
  return Html.basecoat.tabs(
    id: id,
    orientation: orientation,
    tabs: [
      for (final (i, tab) in tabsets.indexed)
        (
          index: i + 1,
          selected: (i == active).toString(),
          tabindex: i == active ? "0" : "-1",
          hidden: i != active,
          hasPanel: tab.panel != null,
          tab: tab.tab,
          panel: tab.panel,
          tabAttrs: _attrs(tab.tabAttrs, reserved: ["id", "type", "role", "aria-controls", "aria-selected", "tabindex"]),
          panelAttrs: _attrs(tab.panelAttrs, reserved: ["id", "role", "aria-labelledby", "aria-selected", "tabindex", "hidden"]),
        ),
    ],
    mainAttrs: _attrs(mainAttrs, className: "tabs", reserved: _rootReserved),
    tablistAttrs: _attrs(tablistAttrs, reserved: ["role", "aria-orientation"]),
  );
}

Fragment toaster({String id = "toaster", List<Fragment> toasts = const [], Fragment? body, Map<String, String> attrs = const {}}) => Html.basecoat.toaster(
  id: _id(id, "toaster"),
  toasts: toasts,
  body: body,
  attrs: _attrs(attrs, className: "toaster", reserved: _rootReserved),
);

Fragment toast({String category = "success", String title = "", String description = "", int? duration, Object? icon, ToastAction? action, ToastAction? cancel, Map<String, String> attrs = const {}}) {
  final iconName = switch (category) {
    "success" => "circle-check",
    "error" => "circle-x",
    "info" => "info",
    "warning" => "triangle-alert",
    _ => throw ArgumentError.value(category, "category"),
  };
  return Html.basecoat.toast(
    category: category,
    role: category == "error" ? "alert" : "status",
    duration: duration,
    hasDuration: duration != null,
    title: title,
    description: description,
    hasTitle: title.isNotEmpty,
    hasDescription: description.isNotEmpty,
    iconName: iconName,
    icon: icon,
    hasIcon: icon != null,
    actions: [
      if (action != null) _toastAction(action, false),
      if (cancel != null) _toastAction(cancel, true),
    ],
    attrs: _attrs(attrs, className: "toast", reserved: ["role", "aria-atomic", "aria-hidden", "data-category", "data-duration"]),
  );
}

({String label, bool isLink, String href, bool cancel, String onclick, bool hasOnclick}) _toastAction(ToastAction action, bool cancel) =>
    (label: action.label, isLink: action.href != null, href: action.href == null ? "" : _url(action.href!), cancel: cancel, onclick: action.onclick ?? "", hasOnclick: action.onclick != null);

Map<String, String> _itemAttrs(Item item) => {...item.attrs, if (item.disabled) "aria-disabled": "true", if (item.keywords != null) "data-keywords": item.keywords!};

Item _leaf(Item item, String where) {
  if (item.type != ItemType.item) throw ArgumentError.value(item.type, "type", "Only plain items are allowed in $where");
  return item;
}

_Option _option(Item item, String id, List<String> selected) {
  final value = item.value ?? item.label;
  return (
    id: id,
    value: value,
    label: item.attrs["data-label"] ?? item.label,
    selected: selected.contains(value),
    content: item.content ?? item.label,
    attrs: _attrs(_itemAttrs(item), reserved: ["id", "role", "data-value", "data-label", "aria-selected"]),
  );
}

List<_ListboxEntry> _listbox(List<Item> items, String prefix, List<String> selected) => [
  for (final (i, item) in items.indexed)
    switch (item.type) {
      ItemType.item => switch (_option(item, "$prefix-${i + 1}", selected)) {
        final o => (isOption: true, isGroup: false, isSeparator: false, id: o.id, value: o.value, label: o.label, selected: o.selected, content: o.content, attrs: o.attrs, options: const <_Option>[]),
      },
      ItemType.separator => (isOption: false, isGroup: false, isSeparator: true, id: "", value: "", label: "", selected: false, content: "", attrs: const <String, String>{}, options: const <_Option>[]),
      ItemType.group => (
        isOption: false,
        isGroup: true,
        isSeparator: false,
        id: "group-label-$prefix-${i + 1}",
        value: "",
        label: item.label,
        selected: false,
        content: "",
        attrs: _attrs(_itemAttrs(item), reserved: _groupReserved),
        options: [for (final (j, child) in item.items.indexed) _option(_leaf(child, "groups"), "$prefix-${i + 1}-${j + 1}", selected)],
      ),
      ItemType.submenu => throw ArgumentError("Submenus are supported only by sidebar"),
    },
];

_MenuItem _menuItem(Item item, String id, bool dropdown) {
  final attrs = _itemAttrs(item);
  final role = dropdown ? attrs["role"] ?? "menuitem" : "menuitem";
  if (!const {"menuitem", "menuitemcheckbox", "menuitemradio"}.contains(role)) throw ArgumentError.value(role, "role", "Expected a menu item role");
  return (
    isLink: item.url != null,
    id: id,
    href: item.url == null ? "" : _url(item.url!),
    role: role,
    icon: item.icon,
    content: item.content ?? item.label,
    attrs: _attrs(attrs, reserved: ["id", "role", "href"]),
  );
}

List<_MenuEntry> _menu(List<Item> items, String prefix, {bool dropdown = false}) => [
  for (final (i, item) in items.indexed)
    switch (item.type) {
      ItemType.item => switch (_menuItem(item, "$prefix-${i + 1}", dropdown)) {
        final m => (isItem: true, isGroup: false, isSeparator: false, isLink: m.isLink, id: m.id, href: m.href, role: m.role, label: "", icon: m.icon, content: m.content, attrs: m.attrs, items: const <_MenuItem>[]),
      },
      ItemType.separator => (isItem: false, isGroup: false, isSeparator: true, isLink: false, id: "", href: "", role: "", label: "", icon: null, content: "", attrs: const <String, String>{}, items: const <_MenuItem>[]),
      ItemType.group => (
        isItem: false,
        isGroup: true,
        isSeparator: false,
        isLink: false,
        id: "group-label-$prefix-${i + 1}",
        href: "",
        role: "",
        label: item.label,
        icon: null,
        content: "",
        attrs: _attrs(_itemAttrs(item), reserved: _groupReserved),
        items: [for (final (j, child) in item.items.indexed) _menuItem(_leaf(child, "groups"), "$prefix-${i + 1}-${j + 1}", dropdown)],
      ),
      ItemType.submenu => throw ArgumentError("Submenus are supported only by sidebar"),
    },
];

_SidebarLink _sidebarLink(Item item) => (href: _url(item.url ?? "#"), current: item.current, icon: item.icon, content: item.content ?? item.label, attrs: _attrs(_itemAttrs(item), reserved: ["href", "aria-current"]));

_SidebarItem _sidebarItem(Item item, String id) => switch (item.type) {
  ItemType.item => switch (_sidebarLink(item)) {
    final l => (isSubmenu: false, id: id, href: l.href, current: l.current, open: false, icon: l.icon, content: l.content, attrs: l.attrs, items: const <_SidebarLink>[]),
  },
  ItemType.submenu => (
    isSubmenu: true,
    id: id,
    href: "",
    current: false,
    open: item.open,
    icon: item.icon,
    content: item.content ?? item.label,
    attrs: _attrs(_itemAttrs(item), reserved: ["id", "open"]),
    items: [for (final child in item.items) _sidebarLink(_leaf(child, "sidebar submenus"))],
  ),
  _ => throw ArgumentError.value(item.type, "type", "Sidebar groups hold links and submenus"),
};

List<_SidebarEntry> _sidebar(List<Item> items, String prefix) => [
  for (final (i, item) in items.indexed)
    switch (item.type) {
      ItemType.separator => (isGroup: false, isSeparator: true, id: "", label: "", hasLabel: false, attrs: const <String, String>{}, items: const <_SidebarItem>[]),
      ItemType.group => (
        isGroup: true,
        isSeparator: false,
        id: "group-label-$prefix-${i + 1}",
        label: item.label,
        hasLabel: item.label.isNotEmpty,
        attrs: _attrs(_itemAttrs(item), reserved: _groupReserved),
        items: [for (final (j, child) in item.items.indexed) _sidebarItem(child, "$prefix-${i + 1}-${j + 1}")],
      ),
      _ => throw ArgumentError.value(item.type, "type", "Sidebar menu entries must be groups or separators"),
    },
];
