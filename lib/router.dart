import "package:absurd_starter/config.dart";
import "package:absurd_starter/src/handlers/page_handlers.dart";
import "package:netto/netto.dart";

enum Pages {
  home("/"),
  ui("/ui"),
  health("/health");

  final String path;

  const Pages(this.path);
}

void router(Netto app) {
  app
    ..use(logger())
    ..static("/", "public")
    ..get(Pages.home.path, handleHomePage)
    ..get(Pages.health.path, handleHealth)
    ..post("/api/counter/increment", handleCounterIncrement);

  if (Config.dev) {
    app.get(Pages.ui.path, handleUiPage);
  }
}
