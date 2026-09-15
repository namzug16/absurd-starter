import "dart:convert";
import "dart:io";

import "package:htmleez/htmleez.dart";
import "package:netto/netto.dart";

extension HxRequestExtensions on Ctx {
  bool get isHx => request.headers["hx-request"]?.firstOrNull == "true";

  String? get hxBoosted => request.headers["hx-boosted"]?.firstOrNull;

  String? get hxCurrentURL => request.headers["hx-current-url"]?.firstOrNull;

  String? get hxHistoryRestoreRequest => request.headers["hx-history-restore-request"]?.firstOrNull;

  String? get hxPrompt => request.headers["hx-prompt"]?.firstOrNull;

  String? get hxTarget => request.headers["hx-target"]?.firstOrNull;

  String? get hxRequestType => request.headers["hx-request-type"]?.firstOrNull;

  String? get hxSource => request.headers["hx-source"]?.firstOrNull;
}

extension HxCtxResponse on CtxResponse {
  void htmlPage(HTML page, {int status = HttpStatus.ok, Encoding enc = utf8}) => this.html(page.toHtml(), status: status, enc: enc);

  void htmlFragments(List<HTML> fragments, {int status = HttpStatus.ok, Encoding enc = utf8}) => this.html(fragments.toHtml(), status: status, enc: enc);

  void htmlFragmentsOob(List<HTML> fragments, {int status = HttpStatus.ok, Encoding enc = utf8}) => this.html(fragments.map((fragment) => fragment.add($("hx-swap-oob")("true"))).toList().toHtml(), status: status, enc: enc);
}
