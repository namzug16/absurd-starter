import "package:absurd_starter/src/ui/basecoat/helpers.dart";
import "package:htmleez/htmleez.dart";

class Tabset {
  final Object? tab;
  final Object? panel;
  final List<HTML> tabAttrs;
  final List<HTML> panelAttrs;

  const Tabset({
    required this.tab,
    required this.panel,
    this.tabAttrs = const [],
    this.panelAttrs = const [],
  });
}

HTML tabs({
  required String id,
  List<Tabset> tabsets = const [],
  int defaultTabIndex = 1,
  String? mainExtraClasses,
  String? tablistExtraClasses,
  List<HTML>? mainAttrs,
  List<HTML>? tablistAttrs,
}) {
  final selectedIndex = tabsets.isEmpty ? 0 : defaultTabIndex.clamp(1, tabsets.length);

  return div([
    $id(id),
    $classes(["tabs", ?mainExtraClasses]),
    ...?mainAttrs,
    nav([
      $role("tablist"),
      $aria.orientation("horizontal"),
      $classes([?tablistExtraClasses]),
      ...?tablistAttrs,
      for (var i = 0; i < tabsets.length; i++)
        button([
          $type("button"),
          $role("tab"),
          $id("$id-tab-${i + 1}"),
          $("aria-controls")("$id-panel-${i + 1}"),
          $aria.selected((i + 1 == selectedIndex).toString()),
          $("tabindex")(i + 1 == selectedIndex ? "0" : "-1"),
          ...tabsets[i].tabAttrs,
          BasecoatHelpers.normalizeComponent(tabsets[i].tab),
        ]),
    ]),
    for (var i = 0; i < tabsets.length; i++)
      div([
        $role("tabpanel"),
        $id("$id-panel-${i + 1}"),
        $aria.labelledby("$id-tab-${i + 1}"),
        $("tabindex")("-1"),
        $aria.selected((i + 1 == selectedIndex).toString()),
        if (i + 1 != selectedIndex) $("hidden")(""),
        ...tabsets[i].panelAttrs,
        BasecoatHelpers.normalizeComponent(tabsets[i].panel),
      ]),
  ]);
}
