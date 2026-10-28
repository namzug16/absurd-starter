import "package:absurd_starter/generated/html.dart";
import "package:absurd_starter/src/ui/layout/primary_layout.dart";

Fragment pageHome() => primaryLayout(
  Html.pages.home(
    counter: counterFragment(0),
    features: const [
      (icon: "server", title: "Relic", description: "Modern Dart server with typed requests, routing, middleware, static files, and WebSockets."),
      (icon: "refresh-cw", title: "HTMX", description: "Return fragments from Dart and keep UI state boring."),
      (icon: "palette", title: "Basecoat", description: "Tailwind-friendly components and design tokens."),
    ],
    stack: const [
      (name: "HTMX", version: "4.0.0", href: "https://four.htmx.org"),
      (name: "Tailwind CSS", version: "+4", href: "https://tailwindcss.com"),
      (name: "Basecoat", version: "1.0.2", href: "https://www.npmjs.com/package/basecoat-css"),
      (name: "Lucide", version: "1.33.0", href: "https://lucide.dev"),
      (name: "Relic", version: "2.0.0-rc.2", href: "https://pub.dev/packages/relic"),
    ],
  ),
);

Fragment counterFragment(int count) => Html.counter(count: count);
