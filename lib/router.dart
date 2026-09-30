import "dart:io";

import "package:absurd_starter/config.dart";
import "package:absurd_starter/src/handlers/page_handlers.dart";
import "package:relic/relic.dart";

enum Pages {
  home("/"),
  ui("/ui"),
  health("/health");

  final String path;

  const Pages(this.path);
}

void router(RelicApp app) {
  app
    ..use("/", logRequests())
    ..anyOf(
      {Method.get, Method.head},
      "/**",
      StaticHandler.directory(
        Directory("public"),
        cacheControl: (_, _) => null,
      ).asHandler,
    )
    ..get(Pages.home.path, handleHomePage)
    ..get(Pages.health.path, handleHealth)
    ..post("/api/counter/increment", handleCounterIncrement);

  if (Config.dev) {
    app.get(Pages.ui.path, handleUiPage);
  }
}
