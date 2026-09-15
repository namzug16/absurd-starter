import "package:absurd_starter/src/ui/basecoat/helpers.dart";
import "package:absurd_starter/src/ui/lucide.dart";
import "package:htmleez/htmleez.dart";
import "package:htmleez/htmleez.dart" as tags;

enum CommandItemType {
  item,
  group,
  separator,
}

class CommandItem {
  final CommandItemType type;
  final String? id;
  final Object? label;
  final HTML? icon;
  final String? url;
  final String? filter;
  final String? keywords;
  final String? shortcut;
  final List<CommandItem> items;
  final List<HTML> attrs;

  const CommandItem({
    this.type = CommandItemType.item,
    this.id,
    this.label,
    this.icon,
    this.url,
    this.filter,
    this.keywords,
    this.shortcut,
    this.items = const [],
    this.attrs = const [],
  });
}

HTML command({
  required String id,
  List<CommandItem> items = const [],
  String placeholder = "Type a command or search...",
  String emptyText = "No results found.",
  HTML? content,
  String? mainExtraClasses,
  String? menuExtraClasses,
  List<HTML>? mainAttrs,
  List<HTML>? inputAttrs,
  List<HTML>? menuAttrs,
}) {
  final menuContent = items.isNotEmpty ? _renderCommandItems(items, "$id-items") : (content ?? "".t);

  return div([
    $("id")(id),
    $classes(["command", ?mainExtraClasses]),
    ...?mainAttrs,
    tags.header([
      Lucide.search(),
      input([
        $("type")("text"),
        $("id")("$id-input"),
        $("placeholder")(placeholder),
        $("autocomplete")("off"),
        $("autocorrect")("off"),
        $("spellcheck")("false"),
        $("aria-autocomplete")("list"),
        $("role")("combobox"),
        $("aria-expanded")("true"),
        $("aria-controls")("$id-menu"),
        ...?inputAttrs,
      ]),
    ]),
    div([
      $("role")("menu"),
      $("id")("$id-menu"),
      $("aria-orientation")("vertical"),
      if (emptyText.isNotEmpty) $("data-empty")(emptyText),
      $classes([?menuExtraClasses]),
      ...?menuAttrs,
      menuContent,
    ]),
  ]);
}

HTML commandDialog({
  required String id,
  List<CommandItem> items = const [],
  String placeholder = "Type a command or search...",
  String emptyText = "No results found.",
  HTML? content,
  bool open = false,
  List<HTML>? dialogAttrs,
  List<HTML>? inputAttrs,
  List<HTML>? menuAttrs,
}) {
  return tags.dialog([
    $("id")(id),
    $("class")("command-dialog"),
    $("aria-label")("Command menu"),
    if (open) $("open")(""),
    $("onclick")("if (event.target === this) this.close()"),
    ...?dialogAttrs,
    command(
      id: "$id-command",
      items: items,
      placeholder: placeholder,
      emptyText: emptyText,
      content: content,
      inputAttrs: inputAttrs,
      menuAttrs: menuAttrs,
    ),
  ]);
}

HTML _renderCommandItems(List<CommandItem> items, String parentIdPrefix) {
  final entries = <HTML>[];

  for (var i = 0; i < items.length; i++) {
    final item = items[i];
    final itemId = "$parentIdPrefix-${i + 1}";

    switch (item.type) {
      case CommandItemType.group:
        final groupLabelId = item.id ?? "group-label-$itemId";
        entries.add(
          div([
            $("role")("group"),
            $("aria-labelledby")(groupLabelId),
            ...item.attrs,
            span([
              $("role")("heading"),
              $("id")(groupLabelId),
              BasecoatHelpers.normalizeComponent(item.label),
            ]),
            _renderCommandItems(item.items, itemId),
          ]),
        );
        break;
      case CommandItemType.separator:
        entries.add(hr([$("role")("separator")]));
        break;
      case CommandItemType.item:
        final children = <HTML>[
          ...item.attrs,
          if (item.filter != null && item.filter!.isNotEmpty) $("data-filter")(item.filter),
          if (item.keywords != null && item.keywords!.isNotEmpty) $("data-keywords")(item.keywords),
          BasecoatHelpers.normalizeComponent(item.icon),
          span([BasecoatHelpers.normalizeComponent(item.label)]),
          if (item.shortcut != null && item.shortcut!.isNotEmpty)
            span([
              $("data-shortcut")(""),
              item.shortcut!.t,
            ]),
        ];

        if (item.url != null && item.url!.isNotEmpty) {
          entries.add(
            a([
              $("id")(item.id ?? itemId),
              $("role")("menuitem"),
              $("href")(item.url),
              ...children,
            ]),
          );
        } else {
          entries.add(
            div([
              $("id")(item.id ?? itemId),
              $("role")("menuitem"),
              ...children,
            ]),
          );
        }
        break;
    }
  }

  return HTML.fragment(entries);
}
