import "package:absurd_starter/generated/html.dart";

/// Opens when inserted by HTMX and removes itself after closing.
Fragment temporaryDialog({
  required String id,
  required String title,
  String? description,
  required Fragment body,
  Fragment? footer,
  String? dialogExtraClasses,
  String? dialogContentExtraClasses,
  bool closeButton = true,
  bool closeOnOverlayClick = true,
}) => Html.temporaryDialog(
  id: id,
  title: title,
  description: description,
  hasDescription: description != null && description.isNotEmpty,
  body: body,
  footer: footer,
  hasFooter: footer != null,
  dialogClasses: ["dialog", ?dialogExtraClasses].join(" "),
  contentClasses: dialogContentExtraClasses ?? "",
  closeButton: closeButton,
  overlayClick: closeOnOverlayClick ? "if (event.target === this) this.close()" : "",
);
