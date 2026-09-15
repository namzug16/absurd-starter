import "package:absurd_starter/src/ui/basecoat/helpers.dart";
import "package:htmleez/htmleez.dart";

HTML popover({
  required String id,
  Object? trigger,
  required HTML content,

  List<HTML>? mainAttrs,
  List<HTML>? triggerAttrs,
  List<HTML>? popoverAttrs,

  String? mainExtraClasses,
  String? triggerExtraClasses,
  String? popoverExtraClasses,
}) {
  return div([
    $("id")(id),
    $classes(["popover ", ?mainExtraClasses]),
    ...?mainAttrs,
    button([
      $("id")("$id-trigger"),
      $("type")("button"),
      $("aria-expanded")("false"),
      $("aria-controls")("$id-popover"),
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
      content,
    ]),
  ]);
}
