import "package:absurd_starter/src/ui/basecoat/helpers.dart";
import "package:absurd_starter/src/ui/lucide.dart";
import "package:htmleez/htmleez.dart";
import "package:htmleez/htmleez.dart" as tags;

HTML dialog({
  required String id,
  String? dialogExtraClasses,
  Object? trigger,
  String? title,
  String? description,
  required HTML body,
  HTML? footer,
  String? contentExtraClasses,

  List<HTML>? dialogAttrs,
  List<HTML>? triggerAttrs,
  List<HTML>? headerAttrs,
  List<HTML>? bodyAttrs,
  List<HTML>? footerAttrs,

  bool open = false,
  bool closeButton = true,
  bool closeOnOverlayClick = true,
}) {
  final hasDescription = description != null && description.isNotEmpty;
  final hasHeader = (title != null && title.isNotEmpty) || hasDescription;

  return HTML.fragment([
    if (trigger != null)
      button([
        $("type")("button"),
        $("onclick")("document.getElementById('$id').showModal()"),
        ...?triggerAttrs,
        BasecoatHelpers.normalizeComponent(trigger),
      ]),
    tags.dialog([
      $("id")(id),
      $classes(["dialog", ?dialogExtraClasses]),
      if (title != null && title.isNotEmpty) $("aria-labelledby")("$id-title"),
      if (hasDescription) $("aria-describedby")("$id-description"),
      if (open) $("open")(""),
      if (closeOnOverlayClick) $("onclick")("if (event.target === this) this.close()"),
      ...?dialogAttrs,
      div([
        $classes([?contentExtraClasses]),
        if (hasHeader)
          tags.header([
            ...?headerAttrs,
            h2([
              $("id")("$id-title"),
              (title ?? "").t,
            ]),
            if (hasDescription)
              p([
                $("id")("$id-description"),
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
            $("type")("button"),
            $("class")("btn"),
            $("data-variant")("ghost"),
            $("data-size")("icon-sm"),
            $("aria-label")("Close dialog"),
            $("onclick")("this.closest('dialog').close()"),
            Lucide.x([Attribute("aria-hidden")("true")]),
          ]),
      ]),
    ]),
  ]);
}
