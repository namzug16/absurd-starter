import "package:absurd_starter/src/ui/basecoat/helpers.dart";
import "package:htmleez/htmleez.dart";

enum DropdownMenuItemType {
  item,
  group,
  separator,
}

class DropdownMenuItem {
  final DropdownMenuItemType type;
  final String? id;
  final Object? label;
  final HTML? icon;
  final String? url;
  final List<DropdownMenuItem> items;
  final List<HTML> attrs;

  const DropdownMenuItem({
    this.type = DropdownMenuItemType.item,
    this.id,
    this.label,
    this.icon,
    this.url,
    this.items = const [],
    this.attrs = const [],
  });
}

HTML dropdownMenu({
  required String id,
  required Object? trigger,
  required List<DropdownMenuItem> items,
  HTML? content,

  String? mainExtraClasses,
  String? triggerExtraClasses,
  String? popoverExtraClasses,
  String? menuExtraClasses,

  List<HTML>? mainAttrs,
  List<HTML>? triggerAttrs,
  List<HTML>? popoverAttrs,
  List<HTML>? menuAttrs,
}) {
  final menuContent = items.isNotEmpty ? _renderDropdownItems(items, "$id-items") : (content ?? "".t);

  return div([
    $("id")(id),
    $classes(["dropdown-menu", ?mainExtraClasses]),
    ...?mainAttrs,
    button([
      $("type")("button"),
      $("id")("$id-trigger"),
      $("aria-haspopup")("menu"),
      $("aria-controls")("$id-menu"),
      $("aria-expanded")("false"),
      $classes([?triggerExtraClasses]),
      ...?triggerAttrs,
      BasecoatHelpers.normalizeComponent(trigger),
    ]),
    div([
      $("id")("$id-popover"),
      $("data-popover")(""),
      $("aria-hidden")("true"),
      $classes([?popoverExtraClasses]),
      ...?popoverAttrs,
      div([
        $("role")("menu"),
        $("id")("$id-menu"),
        $("aria-labelledby")("$id-trigger"),
        $classes([?menuExtraClasses]),
        ...?menuAttrs,
        menuContent,
      ]),
    ]),
  ]);
}

HTML _renderDropdownItems(List<DropdownMenuItem> items, String parentIdPrefix) {
  final entries = <HTML>[];

  for (var i = 0; i < items.length; i++) {
    final item = items[i];
    final itemId = "$parentIdPrefix-${i + 1}";

    switch (item.type) {
      case DropdownMenuItemType.group:
        final groupLabelId = item.id ?? "group-label-$itemId";
        final groupItems = item.items.isNotEmpty ? _renderDropdownItems(item.items, itemId) : HTML.fragment([]);

        entries.add(
          div([
            $("role")("group"),
            $("aria-labelledby")(groupLabelId),
            ...item.attrs,
            div([
              $("role")("heading"),
              $("id")(groupLabelId),
              BasecoatHelpers.normalizeComponent(item.label),
            ]),
            groupItems,
          ]),
        );
        break;
      case DropdownMenuItemType.separator:
        entries.add(hr([$("role")("separator")]));
        break;
      case DropdownMenuItemType.item:
        if (item.url != null && item.url!.isNotEmpty) {
          entries.add(
            a([
              $("id")(itemId),
              $("role")("menuitem"),
              $("href")(item.url),
              ...item.attrs,
              BasecoatHelpers.normalizeComponent(item.icon),
              BasecoatHelpers.normalizeComponent(item.label),
            ]),
          );
          break;
        }

        entries.add(
          div([
            $("id")(itemId),
            $("role")("menuitem"),
            ...item.attrs,
            BasecoatHelpers.normalizeComponent(item.icon),
            BasecoatHelpers.normalizeComponent(item.label),
          ]),
        );
        break;
    }
  }

  return HTML.fragment(entries);
}
