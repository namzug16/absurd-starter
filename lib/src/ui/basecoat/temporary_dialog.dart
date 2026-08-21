import "package:absurd_starter/src/ui/lucide.dart";
import "package:htmdart/htmdart.dart";
import "package:htmdart/htmdart.dart" as tags;

HTML temporaryDialog({
  required String id,
  required String title,
  String? description,
  required HTML body,
  HTML? footer,
  String? dialogExtraClasses,
  String? dialogContentExtraClasses,
  List<HTML>? dialogAttrs,
  List<HTML>? headerAttrs,
  List<HTML>? bodyAttrs,
  List<HTML>? footerAttrs,
  bool closeButton = true,
  bool closeOnOverlayClick = true,
}) {
  final hasDescription = description != null && description.isNotEmpty;

  return tags.dialog([
    $id(id),
    $classes(["dialog", ?dialogExtraClasses]),
    $aria.labelledby("$id-title"),
    if (hasDescription) $aria.describedby("$id-description"),
    $_("init js document.getElementById('$id').showModal() end on close remove me"),
    if (closeOnOverlayClick) $("onclick")("if (event.target === this) this.close()"),
    ...?dialogAttrs,
    div([
      $classes([?dialogContentExtraClasses]),
      tags.header([
        ...?headerAttrs,
        h2([
          $id("$id-title"),
          title.t,
        ]),
        if (hasDescription)
          p([
            $id("$id-description"),
            description.t,
          ]),
      ]),
      section([
        ...?bodyAttrs,
        body,
      ]),
      if (footer != null)
        tags.footer([
          ...?footerAttrs,
          footer,
        ]),
      if (closeButton)
        button([
          $type("button"),
          $class("btn"),
          $("data-variant")("ghost"),
          $("data-size")("icon-sm"),
          $aria.label("Close dialog"),
          $("onclick")("this.closest('dialog').close()"),
          Lucide.x([Attribute("aria-hidden")("true")]),
        ]),
    ]),
  ]);
}
