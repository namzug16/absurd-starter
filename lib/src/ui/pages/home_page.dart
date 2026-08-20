import "package:absurd_starter/src/ui/components/hyperscript.dart";
import "package:absurd_starter/src/ui/layout/primary_layout.dart";
import "package:absurd_starter/src/ui/lucide.dart";
import "package:htmdart/htmdart.dart";

HTML pageHome() => primaryLayout(
  body([
    $class("min-h-screen bg-background text-foreground antialiased"),
    div([
      $class("mx-auto flex min-h-screen w-full max-w-5xl flex-col justify-center gap-10 px-6 py-12"),
      section([
        $class("grid gap-8 lg:grid-cols-[1.2fr_0.8fr] lg:items-center"),
        div([
          $class("space-y-6"),
          div([
            $class("inline-flex items-center gap-2 rounded-full border bg-card px-3 py-1 text-sm text-muted-foreground shadow-sm"),
            Lucide.sparkles([$class("size-4")]),
            "Dart server-driven UI starter".t,
          ]),
          h1([
            $class("text-5xl font-black tracking-tight sm:text-6xl"),
            "Ship small, sharp web apps with Dart.".t,
          ]),
          p([
            $class("max-w-2xl text-lg leading-8 text-muted-foreground"),
            "Absurd Starter wires Netto, HTMX, hyperscript, Tailwind, Basecoat, htmdart, and Lucide into a minimal production-shaped template.".t,
          ]),
          div([
            $class("flex flex-wrap gap-3"),
            a([
              $href("https://pub.dev/packages/netto"),
              $target("_blank"),
              $rel("noreferrer"),
              $class("btn"),
              "Netto".t,
            ]),
            a([
              $href("https://htmx.org"),
              $target("_blank"),
              $rel("noreferrer"),
              $class("btn-outline"),
              "HTMX".t,
            ]),
          ]),
        ]),
        div([
          $class("rounded-2xl border bg-card p-5 shadow-sm"),
          div([
            $class("mb-4 flex items-center gap-2 text-sm font-medium text-muted-foreground"),
            Lucide.zap([$class("size-4")]),
            "HTMX fragment demo".t,
          ]),
          div([
            $id("counter-result"),
            $class("mb-4 rounded-xl bg-muted p-5 text-center"),
            p([$class("text-sm text-muted-foreground"), "Counter".t]),
            p([$class("text-4xl font-bold"), "0".t]),
          ]),
          form([
            $id("counter-form"),
            $hx.post("/api/counter/increment"),
            $hx.target("#counter-result"),
            $hx.swap("outerHTML"),
            $_disableFieldsetsOnHtmxRequest(),
            fieldset([
              $class("flex gap-3"),
              input([
                $type("hidden"),
                $name("count"),
                $value("0"),
              ]),
              button([
                $type("submit"),
                $class("w-full btn-primary group"),
                Lucide.loaderCircle([$class("loader group-disabled:animate-spin group-enabled:hidden")]),
                Lucide.plus([$class("size-4 group-disabled:hidden")]),
                "Increment".t,
              ]),
            ]),
          ]),
        ]),
      ]),
      section([
        $class("grid gap-4 sm:grid-cols-3"),
        _featureCard(Lucide.server, "Netto", "Small HTTP server with simple route wiring."),
        _featureCard(Lucide.refreshCw, "HTMX", "Return fragments from Dart and keep UI state boring."),
        _featureCard(Lucide.palette, "Basecoat", "Tailwind-friendly components and design tokens."),
      ]),
    ]),
  ]),
);

HTML counterFragment(int count) => div([
  $id("counter-result"),
  $class("mb-4 rounded-xl bg-muted p-5 text-center"),
  p([$class("text-sm text-muted-foreground"), "Counter".t]),
  p([$class("text-4xl font-bold"), count.toString().t]),
  input([$type("hidden"), $name("count"), $value(count.toString()), $("form")("counter-form")]),
]);

HTML _featureCard(HTML Function([List<HTML>]) icon, String title, String description) => article([
  $class("rounded-2xl border bg-card p-5 shadow-sm"),
  icon([$class("mb-4 size-5 text-primary")]),
  h2([$class("font-semibold"), title.t]),
  p([$class("mt-2 text-sm leading-6 text-muted-foreground"), description.t]),
]);
