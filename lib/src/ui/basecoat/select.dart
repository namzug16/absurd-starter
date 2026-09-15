import "dart:convert";

import "package:absurd_starter/src/ui/basecoat/helpers.dart";
import "package:absurd_starter/src/ui/lucide.dart";
import "package:htmleez/htmleez.dart";
import "package:htmleez/htmleez.dart" as tags;

enum SelectItemType {
  item,
  group,
  separator,
}

class SelectItem {
  final SelectItemType type;
  final String? id;
  final String value;
  final Object? label;
  final List<SelectItem> items;
  final List<HTML> attrs;

  const SelectItem({
    this.type = SelectItemType.item,
    this.id,
    this.value = "",
    this.label,
    this.items = const [],
    this.attrs = const [],
  });
}

class _SelectOptionsResult {
  final SelectItem? firstOption;
  final List<SelectItem> selectedOptions;

  const _SelectOptionsResult({
    required this.firstOption,
    required this.selectedOptions,
  });
}

HTML select({
  required String id,
  List<String> selected = const [],
  String? name,
  required List<SelectItem> items,
  bool multiple = false,
  String? placeholder,
  bool closeOnSelect = false,
  String format = "value",
  String searchPlaceholder = "Search entries...",
  bool isCombobox = false,
  HTML? content,

  String? mainExtraClasses,
  String? triggerExtraClasses,
  String? popoverExtraClasses,
  String? listboxExtraClasses,

  List<HTML>? mainAttrs,
  List<HTML>? triggerAttrs,
  List<HTML>? popoverAttrs,
  List<HTML>? listboxAttrs,
  List<HTML>? inputAttrs,
}) {
  final effectiveSearchPlaceholder = searchPlaceholder.isEmpty ? "Search entries..." : searchPlaceholder;
  final selectedSet = selected.toSet();

  final options = _collectSelectOptions(items, selectedSet);
  final selectedOptions = options.selectedOptions;
  final defaultOption = selectedOptions.isNotEmpty ? selectedOptions.first : null;

  final defaultLabel = multiple ? (selectedOptions.isNotEmpty ? selectedOptions.map(_optionLabelText).join(", ") : (placeholder ?? "")) : (defaultOption != null ? _optionLabelText(defaultOption) : (placeholder ?? ""));

  final hiddenName = (name != null && name.isNotEmpty) ? name : "$id-value";
  final hiddenValue = multiple ? jsonEncode(selected) : (defaultOption != null ? defaultOption.value : "");

  final listContent = items.isNotEmpty ? _renderSelectItems(items, selectedSet, "$id-items") : (content ?? "".t);

  return div([
    $("id")(id),
    $classes(["select", ?mainExtraClasses]),
    if (placeholder != null && placeholder.isNotEmpty) $("data-placeholder")(placeholder),
    if (multiple && closeOnSelect) $("data-close-on-select")("true"),
    if (format == "object") $("data-format")("object"),
    ...?mainAttrs,
    button([
      $("type")("button"),
      $classes(["btn", ?triggerExtraClasses]),
      $("data-variant")("outline"),
      $("id")("$id-trigger"),
      $("aria-haspopup")("listbox"),
      $("aria-expanded")("false"),
      $("aria-controls")("$id-listbox"),
      ...?triggerAttrs,
      span([
        $("class")("truncate"),
        defaultLabel.t,
      ]),
      if (isCombobox) Lucide.chevronsUpDown([$("class")("text-muted-foreground opacity-50 shrink-0")]),
      if (!isCombobox) Lucide.chevronDown([$("class")("text-muted-foreground opacity-50 shrink-0")]),
    ]),
    div([
      $("id")("$id-popover"),
      $("data-popover")(""),
      $("aria-hidden")("true"),
      $classes([?popoverExtraClasses]),
      ...?popoverAttrs,
      if (isCombobox)
        tags.header([
          Lucide.search(),
          input([
            $("type")("text"),
            $("value")(""),
            $("placeholder")(effectiveSearchPlaceholder),
            $("autocomplete")("off"),
            $("autocorrect")("off"),
            $("spellcheck")("false"),
            $("aria-autocomplete")("list"),
            $("role")("combobox"),
            $("aria-expanded")("false"),
            $("aria-controls")("$id-listbox"),
            $("aria-labelledby")("$id-trigger"),
          ]),
        ]),
      div([
        $("role")("listbox"),
        $("id")("$id-listbox"),
        $("aria-orientation")("vertical"),
        $("aria-labelledby")("$id-trigger"),
        if (multiple) $("aria-multiselectable")("true"),
        $classes([?listboxExtraClasses]),
        ...?listboxAttrs,
        listContent,
      ]),
    ]),
    input([
      $("type")("hidden"),
      $("name")(hiddenName),
      $("value")(hiddenValue),
      ...?inputAttrs,
    ]),
  ]);
}

_SelectOptionsResult _collectSelectOptions(List<SelectItem> items, Set<String> selectedSet) {
  SelectItem? firstOption;
  final selectedOptions = <SelectItem>[];

  for (final item in items) {
    if (item.type == SelectItemType.group) {
      final groupResult = _collectSelectOptions(item.items, selectedSet);
      firstOption ??= groupResult.firstOption;
      selectedOptions.addAll(groupResult.selectedOptions);
      continue;
    }

    if (item.type == SelectItemType.separator) {
      continue;
    }

    firstOption ??= item;
    if (_isSelected(selectedSet, item.value)) {
      selectedOptions.add(item);
    }
  }

  return _SelectOptionsResult(firstOption: firstOption, selectedOptions: selectedOptions);
}

HTML _renderSelectItems(List<SelectItem> items, Set<String> selectedSet, String parentIdPrefix) {
  final entries = <HTML>[];

  for (var i = 0; i < items.length; i++) {
    final item = items[i];
    final itemId = "$parentIdPrefix-${i + 1}";

    switch (item.type) {
      case SelectItemType.group:
        final groupLabelId = item.id ?? "group-label-$itemId";
        final groupItems = item.items.isNotEmpty ? _renderSelectItems(item.items, selectedSet, itemId) : HTML.fragment([]);

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
            groupItems,
          ]),
        );
        break;
      case SelectItemType.separator:
        entries.add(hr([$("role")("separator")]));
        break;
      case SelectItemType.item:
        entries.add(
          div([
            $("id")(itemId),
            $("role")("option"),
            if (item.value.isNotEmpty) $("data-value")(item.value),
            if (_optionLabelText(item).isNotEmpty) $("data-label")(_optionLabelText(item)),
            if (_isSelected(selectedSet, item.value)) $("aria-selected")("true"),
            ...item.attrs,
            BasecoatHelpers.normalizeComponent(item.label),
          ]),
        );
        break;
    }
  }

  return HTML.fragment(entries);
}

String _optionLabelText(SelectItem item) {
  if (item.label == null) {
    return "";
  }

  if (item.label is String) {
    return item.label! as String;
  }

  return item.label.toString();
}

bool _isSelected(Set<String> selectedSet, String value) => selectedSet.contains(value);
