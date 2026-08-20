import "dart:convert";
import "dart:io";

import "package:htmdart/htmdart.dart";
import "package:netto/netto.dart";

extension HxRequestExtensions on Ctx {
  bool get isHx => request.headers[HX.request.toLowerCase()]?.firstOrNull == "true";

  String? get hxBoosted => request.headers[HX.boosted.toLowerCase()]?.firstOrNull;

  String? get hxCurrentURL => request.headers[HX.currentURL.toLowerCase()]?.firstOrNull;

  String? get hxHistoryRestoreRequest => request.headers[HX.historyRestoreRequest.toLowerCase()]?.firstOrNull;

  String? get hxPrompt => request.headers[HX.prompt.toLowerCase()]?.firstOrNull;

  String? get hxTarget => request.headers[HX.target.toLowerCase()]?.firstOrNull;

  String? get hxTriggerName => request.headers[HX.triggerName.toLowerCase()]?.firstOrNull;

  String? get hxTrigger => request.headers[HX.trigger.toLowerCase()]?.firstOrNull;
}

extension HxCtxResponse on CtxResponse {
  void htmlPage(HTML page, {int status = HttpStatus.ok, Encoding enc = utf8}) => this.html(page.toHtml(), status: status, enc: enc);

  void htmlFragments(List<HTML> fragments, {int status = HttpStatus.ok, Encoding enc = utf8}) => this.html(fragments.toHtml(), status: status, enc: enc);

  void htmlFragmentsOob(List<HTML> fragments, {int status = HttpStatus.ok, Encoding enc = utf8}) => this.html(fragments.map((fragment) => fragment.add($hx.swapOob.yes)).toList().toHtml(), status: status, enc: enc);
}
