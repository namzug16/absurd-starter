import "dart:convert";

import "package:absurd_starter/src/ui/basecoat/helpers.dart";
import "package:absurd_starter/src/ui/basecoat/select.dart";
import "package:absurd_starter/src/ui/lucide.dart";
import "package:htmleez/htmleez.dart";

HTML combobox({
  required String id,
  Object? selected,
  String? name,
  required List<SelectItem> items,
  bool multiple = false,
  String? placeholder,
  bool closeOnSelect = false,
  bool clear = false,
  bool autoHighlight = false,
  String format = "value",
  String emptyText = "No items found.",
  HTML? content,
  String? mainExtraClasses,
  String? listboxExtraClasses,
  List<HTML>? mainAttrs,
  List<HTML>? inputAttrs,
  List<HTML>? popoverAttrs,
  List<HTML>? listboxAttrs,
  List<HTML>? hiddenInputAttrs,
}) {
  final selectedValues = _selectedValues(selected);
  final hiddenValue = multiple ? jsonEncode(selectedValues) : (selectedValues.isNotEmpty ? selectedValues.first : "");
  final listContent = items.isNotEmpty ? _renderComboboxItems(items, selectedValues.toSet(), "$id-items") : (content ?? "".t);

  return div([
    $id(id),
    $classes(["combobox", ?mainExtraClasses]),
    if (autoHighlight) $("data-auto-highlight")("true"),
    if (multiple && closeOnSelect) $("data-close-on-select")("true"),
    if (format == "object") $("data-format")("object"),
    ...?mainAttrs,
    if (clear)
      div([
        $class("input-group"),
        input([
          $type("text"),
          $role("combobox"),
          if (placeholder != null) $placeholder(placeholder),
          $("autocomplete")("off"),
          $("autocorrect")("off"),
          $("spellcheck")("false"),
          $("aria-autocomplete")("list"),
          $("aria-expanded")("false"),
          $("aria-controls")("$id-listbox"),
          ...?inputAttrs,
        ]),
        span([
          $role("group"),
          $("data-align")("inline-end"),
          button([
            $type("button"),
            $("data-clear")(""),
            $aria.label("Clear selection"),
            Lucide.x([$class("size-4"), Attribute("aria-hidden")("true")]),
          ]),
          button([
            $type("button"),
            $class("btn"),
            $("data-variant")("ghost"),
            $("data-size")("icon-xs"),
            $aria.label("Open suggestions"),
            $("aria-haspopup")("listbox"),
            $("aria-expanded")("false"),
            $("aria-controls")("$id-listbox"),
            Lucide.chevronDown([Attribute("aria-hidden")("true")]),
          ]),
        ]),
      ])
    else ...[
      input([
        $type("text"),
        $role("combobox"),
        if (placeholder != null) $placeholder(placeholder),
        $("autocomplete")("off"),
        $("autocorrect")("off"),
        $("spellcheck")("false"),
        $("aria-autocomplete")("list"),
        $("aria-expanded")("false"),
        $("aria-controls")("$id-listbox"),
        ...?inputAttrs,
      ]),
      Lucide.chevronDown([$class("combobox-trigger-icon"), Attribute("aria-hidden")("true")]),
    ],
    div([
      $id("$id-popover"),
      $("data-popover")(""),
      $("aria-hidden")("true"),
      ...?popoverAttrs,
      div([
        $role("listbox"),
        $id("$id-listbox"),
        $("aria-orientation")("vertical"),
        if (multiple) $("aria-multiselectable")("true"),
        if (emptyText.isNotEmpty) $("data-empty")(emptyText),
        $classes([?listboxExtraClasses]),
        ...?listboxAttrs,
        listContent,
      ]),
    ]),
    input([
      $type("hidden"),
      if (name != null && name.isNotEmpty) $name(name),
      $value(hiddenValue),
      ...?hiddenInputAttrs,
    ]),
  ]);
}

List<String> _selectedValues(Object? selected) {
  if (selected == null) return const [];
  if (selected is String) return selected.isEmpty ? const [] : [selected];
  if (selected is Iterable) return selected.map((value) => value.toString()).where((value) => value.isNotEmpty).toList();
  if (selected is Map && selected["value"] != null) return [selected["value"].toString()];
  return [selected.toString()];
}

HTML _renderComboboxItems(List<SelectItem> items, Set<String> selectedSet, String parentIdPrefix) {
  final entries = <HTML>[];

  for (var i = 0; i < items.length; i++) {
    final item = items[i];
    final itemId = "$parentIdPrefix-${i + 1}";

    switch (item.type) {
      case SelectItemType.group:
        final groupLabelId = item.id ?? "group-label-$itemId";
        entries.add(
          div([
            $role("group"),
            $aria.labelledby(groupLabelId),
            ...item.attrs,
            div([
              $role("heading"),
              $id(groupLabelId),
              BasecoatHelpers.normalizeComponent(item.label),
            ]),
            _renderComboboxItems(item.items, selectedSet, itemId),
          ]),
        );
        break;
      case SelectItemType.separator:
        entries.add(hr([$role("separator")]));
        break;
      case SelectItemType.item:
        final label = _labelText(item.label);
        entries.add(
          div([
            $id(itemId),
            $role("option"),
            if (item.value.isNotEmpty) $("data-value")(item.value),
            if (label.isNotEmpty) $("data-label")(label),
            if (selectedSet.contains(item.value)) $aria.selected("true"),
            ...item.attrs,
            BasecoatHelpers.normalizeComponent(item.label),
          ]),
        );
        break;
    }
  }

  return HTML.fragment(entries);
}

String _labelText(Object? label) => label == null ? "" : label.toString();
