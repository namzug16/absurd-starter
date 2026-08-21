import "package:absurd_starter/src/ui/basecoat/helpers.dart";
import "package:htmdart/htmdart.dart";
import "package:htmdart/htmdart.dart" as tags;

class SidebarItem {
  final SidebarMenuType type;
  final String? id;
  final Object? label;
  final HTML? icon;
  final String? url;
  final bool current;
  final bool open;
  final List<SidebarItem> items;
  final List<HTML> attrs;

  const SidebarItem({
    this.type = .item,
    this.id,
    this.label,
    this.icon,
    this.url,
    this.current = false,
    this.open = false,
    this.items = const [],
    this.attrs = const [],
  });
}

enum SidebarMenuType {
  item,
  group,
  separator,
  submenu,
}

HTML sidebar({
  required String id,
  required String label,
  bool? open,
  String side = "left",
  Object? header,
  Object? footer,
  required List<SidebarItem> menu,
  HTML? content,

  String? mainExtraClasses,
  String? headerExtraClasses,
  String? contentExtraClasses,
  String? footerExtraClasses,

  List<HTML>? mainAttrs,
  List<HTML>? headerAttrs,
  List<HTML>? contentAttrs,
  List<HTML>? footerAttrs,
}) {
  final isOpen = open ?? true;
  label = label.isEmpty ? "Sidebar navigation" : label;
  side = side.isEmpty ? "left" : side;

  final contentNodes = menu.isNotEmpty
      ? _content(
          menu,
          id.isNotEmpty ? "$id-content" : "content",
        )
      : [content ?? "".t];

  return aside([
    if (id.isNotEmpty) $id(id),
    $classes(["sidebar", ?mainExtraClasses]),
    $("data-side")(side),
    $aria.hidden((!isOpen).toString()),
    if (!isOpen) $("inert")(""),
    ...?mainAttrs,
    nav([
      $aria.label(label),
      if (header != null)
        tags.header([
          $classes([?headerExtraClasses]),
          ...?headerAttrs,
          BasecoatHelpers.normalizeComponent(header),
        ]),
      section([
        $classes([?contentExtraClasses]),
        ...?contentAttrs,
        ...contentNodes,
      ]),
      if (footer != null)
        tags.footer([
          $classes([?footerExtraClasses]),
          ...?footerAttrs,
          BasecoatHelpers.normalizeComponent(footer),
        ]),
    ]),
  ]);
}

List<HTML> _content(List<SidebarItem> items, String parentIdPrefix) {
  final entries = <HTML>[];

  for (var i = 0; i < items.length; i++) {
    final item = items[i];
    final itemId = "$parentIdPrefix-${i + 1}";

    switch (item.type) {
      case SidebarMenuType.group:
        entries.add(_group(item, itemId));
        break;
      case SidebarMenuType.separator:
        entries.add(_separator());
        break;
      case SidebarMenuType.submenu:
        entries.add(_submenu(item, itemId));
        break;
      case SidebarMenuType.item:
        entries.add(_item(item));
        break;
    }
  }

  return entries;
}

HTML _group(SidebarItem item, String itemId) {
  final groupLabelId = item.id ?? "group-label-$itemId";
  final groupItems = item.items.isNotEmpty ? _content(item.items, itemId) : const <HTML>[];

  return div([
    $role("group"),
    if (_hasSidebarLabel(item.label)) $aria.labelledby(groupLabelId),
    ...item.attrs,
    if (_hasSidebarLabel(item.label))
      h3([
        $id(groupLabelId),
        BasecoatHelpers.normalizeComponent(item.label),
      ]),
    ul([
      ...groupItems,
    ]),
  ]);
}

HTML _separator() {
  return hr([$role("separator")]);
}

HTML _submenu(SidebarItem item, String itemId) {
  final submenuId = "submenu-$itemId";
  final submenuContentId = "$submenuId-content";
  final submenuItems = item.items.isNotEmpty ? _content(item.items, itemId) : const <HTML>[];

  return li([
    details([
      $id(submenuId),
      if (item.open) $open(""),
      ...item.attrs,
      summary([
        $aria.controls(submenuContentId),
        BasecoatHelpers.normalizeComponent(item.icon),
        BasecoatHelpers.normalizeComponent(item.label),
      ]),
      ul([
        $id(submenuContentId),
        ...submenuItems,
      ]),
    ]),
  ]);
}

HTML _item(SidebarItem item) {
  return li([
    a([
      if (item.url != null) $href(item.url),
      if (item.current) $aria.current("page"),
      ...item.attrs,
      BasecoatHelpers.normalizeComponent(item.icon),
      span([
        BasecoatHelpers.normalizeComponent(item.label),
      ]),
    ]),
  ]);
}

bool _hasSidebarLabel(Object? label) {
  if (label == null) {
    return false;
  }

  if (label is String) {
    return label.isNotEmpty;
  }

  return true;
}
