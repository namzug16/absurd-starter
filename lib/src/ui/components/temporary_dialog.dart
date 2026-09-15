import "package:absurd_starter/src/ui/lucide.dart";
import "package:htmleez/htmleez.dart";
import "package:htmleez/htmleez.dart" as tags;

/// Renders a self-contained modal dialog intended for temporary HTMX/service
/// responses.
///
/// This is not a Basecoat primitive. It lives in `components` because it wraps
/// the native `<dialog>` element with the behavior we need when a service
/// returns a dialog fragment directly: the dialog opens itself as soon as it is
/// inserted into the DOM, and removes itself after it is closed.
///
/// Use this for short-lived dialogs that are returned as HTML fragments. Do not
/// use it for persistent page structure, because the root `<dialog>` node is
/// intentionally deleted on close.
///
/// Typical usage is a trigger that asks the server for a dialog without swapping
/// the trigger itself:
///
/// ```dart
/// button([
///   $("type")("button"),
///   $("hx-get")("/items/$itemId/details-dialog"),
///   $("hx-swap")("none"),
///   "Details".t,
/// ]);
/// ```
///
/// The handler returns the dialog as an out-of-band fragment appended to
/// `<body>`. Once appended, [temporaryDialog] opens itself. When the user closes
/// it, the dialog removes itself from the DOM.
///
/// ```dart
/// Future<void> itemDetailsDialogHandler(Ctx ctx) async {
///   final itemId = ctx.request.pathParameter("itemId");
///
///   ctx.response.htmlFragments([
///     div([
///       $("hx-swap-oob")("beforeend:body"),
///       temporaryDialog(
///         id: "item-details-dialog-$itemId",
///         title: "Item details",
///         body: div([
///           "Loaded from the server".t,
///         ]),
///       ),
///     ]),
///   ]);
/// }
/// ```
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
    $("id")(id),
    $classes(["dialog", ?dialogExtraClasses]),
    $("aria-labelledby")("$id-title"),
    if (hasDescription) $("aria-describedby")("$id-description"),
    $("_")("init js document.getElementById('$id').showModal() end on close remove me"),
    if (closeOnOverlayClick) $("onclick")("if (event.target === this) this.close()"),
    ...?dialogAttrs,
    div([
      $classes([?dialogContentExtraClasses]),
      tags.header([
        ...?headerAttrs,
        h2([
          $("id")("$id-title"),
          title.t,
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
  ]);
}
