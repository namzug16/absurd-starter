import "package:absurd_starter/src/ui/pages/home_page.dart";
import "package:absurd_starter/src/ui/pages/ui_page.dart";
import "package:absurd_starter/src/utils/htmx.dart";
import "package:netto/netto.dart";

void handleHomePage(Ctx ctx) {
  ctx.response.htmlPage(pageHome());
}

void handleUiPage(Ctx ctx) {
  ctx.response.htmlPage(pageUi());
}

void handleHealth(Ctx ctx) {
  ctx.response.string("ok");
}

Future<void> handleCounterIncrement(Ctx ctx) async {
  final rawCount = (await ctx.request.body.formValue("count")) ?? "0";
  final count = int.tryParse(rawCount) ?? 0;

  await Future<void>.delayed(const Duration(seconds: 3));

  ctx.response.htmlFragments([
    counterFragment(count + 1),
  ]);
}
