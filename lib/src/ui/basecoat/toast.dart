import "package:absurd_starter/src/ui/lucide.dart";
import "package:htmleez/htmleez.dart";

enum ToastType {
  success,
  error,
  info,
  warning;

  HTML get icon => switch (this) {
    ToastType.success => Lucide.circleCheck([$("aria-hidden")("true")]),
    ToastType.error => Lucide.circleAlert([$("aria-hidden")("true")]),
    ToastType.info => Lucide.info([$("aria-hidden")("true")]),
    ToastType.warning => Lucide.triangleAlert([$("aria-hidden")("true")]),
  };
}

HTML toaster({
  String id = "toaster",
  List<HTML> toasts = const [],
  List<HTML> attrs = const [],
}) {
  return div([
    $("id")(id),
    $("class")("toaster"),
    ...attrs,
    ...toasts,
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
  int? duration,
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
    if (duration != null) $("data-duration")(duration.toString()),
    ...attrs,
    div([
      $("class")("toast-content"),
      type.icon,
      section([
        if (title != "") h2([title.t]),
        if (description != "") p([description.t]),
      ]),
      if (action != null || cancel != null)
        footer([
          if (action != null)
            if (action.href != null)
              a([
                $("href")(action.href),
                $("class")("btn"),
                $("data-size")("sm"),
                $("data-toast-action")(""),
                ...action.attrs,
                action.label.t,
              ])
            else
              button([
                $("type")("button"),
                $("class")("btn"),
                $("data-size")("sm"),
                $("data-toast-action")(""),
                if (action.onClick != null) $("onclick")(action.onClick),
                ...action.attrs,
                action.label.t,
              ]),
          if (cancel != null)
            button([
              $("type")("button"),
              $("class")("btn"),
              $("data-variant")("outline"),
              $("data-size")("sm"),
              $("data-toast-cancel")(""),
              if (cancel.onClick != null && cancel.onClick!.isNotEmpty) $("onclick")(cancel.onClick),
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
  int? duration,
  String extraClasses = "",
  List<HTML> attrs = const [],
}) => div([
  $("id")("toaster"),
  $("hx-swap-oob")("beforeend"),
  toast(
    type,
    title: title,
    description: description,
    action: action,
    cancel: cancel,
    duration: duration,
    extraClasses: extraClasses,
    attrs: attrs,
  ),
]);
