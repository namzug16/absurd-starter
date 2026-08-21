import "package:absurd_starter/src/ui/lucide.dart";
import "package:htmdart/htmdart.dart";

enum ToastType {
  success,
  error,
  info,
  warning;

  HTML get icon => switch (this) {
    ToastType.success => Lucide.circleCheck([Attribute("aria-hidden")("true")]),
    ToastType.error => Lucide.circleAlert([Attribute("aria-hidden")("true")]),
    ToastType.info => Lucide.info([Attribute("aria-hidden")("true")]),
    ToastType.warning => Lucide.triangleAlert([Attribute("aria-hidden")("true")]),
  };
}

HTML toaster() {
  return div([
    $id("toaster"),
    $class("toaster"),
  ]);
}

class ToastAction {
  final String label;
  final String? onClick;
  final String? href;
  final List<HTML> attrs;

  ToastAction({
    required this.label,
    this.onClick,
    this.href,
    this.attrs = const [],
  });
}

HTML toast(
  ToastType type, {
  required String title,
  required String description,
  ToastAction? action,
  ToastAction? cancel,
  String extraClasses = "",
  List<HTML> attrs = const [],
}) {
  final role = switch (type) {
    ToastType.error => "alert",
    _ => "status",
  };

  return div([
    $classes(["toast", extraClasses]),
    $("role")(role),
    $("aria-atomic")("true"),
    $("aria-hidden")("false"),
    $("data-category")(type.name),
    ...attrs,
    div([
      $class("toast-content"),
      type.icon,
      section([
        if (title != "") title.h2(),
        if (description != "") description.p(),
      ]),
      if (action != null || cancel != null)
        footer([
          if (action != null)
            if (action.href != null)
              a([
                $href(action.href),
                $class("btn-sm"),
                $("data-toast-action")(""),
                ...action.attrs,
                action.label.t,
              ])
            else
              button([
                $type("button"),
                $class("btn"),
                $("data-toast-action")(""),
                if (action.onClick != null) $("onclick")(action.onClick),
                ...action.attrs,
                action.label.t,
              ]),
          if (cancel != null)
            button([
              $type("button"),
              $class("btn-sm-outline"),
              $("data-toast-cancel")(""),
              if (cancel.onClick != "") $("onclick")(cancel.onClick),
              ...cancel.attrs,
              cancel.label.t,
            ]),
        ]),
    ]),
  ]);
}

HTML toastHtmx(
  ToastType type, {
  required String title,
  required String description,
  ToastAction? action,
  ToastAction? cancel,
  String extraClasses = "",
  List<HTML> attrs = const [],
}) => div([
  $id("toaster"),
  $hx.swapOob("beforeend"),
  toast(
    type,
    title: title,
    description: description,
    action: action,
    cancel: cancel,
    attrs: attrs,
  ),
]);
