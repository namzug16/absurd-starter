import "dart:convert";
import "dart:io";

import "package:htmleez/htmleez.dart";
import "package:relic/relic.dart";

extension HxRequestExtensions on Request {
  bool get isHx => headers["hx-request"]?.firstOrNull == "true";

  String? get hxBoosted => headers["hx-boosted"]?.firstOrNull;

  String? get hxCurrentURL => headers["hx-current-url"]?.firstOrNull;

  String? get hxHistoryRestoreRequest => headers["hx-history-restore-request"]?.firstOrNull;

  String? get hxPrompt => headers["hx-prompt"]?.firstOrNull;

  String? get hxTarget => headers["hx-target"]?.firstOrNull;

  String? get hxRequestType => headers["hx-request-type"]?.firstOrNull;

  String? get hxSource => headers["hx-source"]?.firstOrNull;
}

Response htmlPage(HTML page, {int status = HttpStatus.ok, Encoding enc = utf8}) => Response(
  status,
  body: Body.fromString(page.toHtml(), encoding: enc, mimeType: MimeType.html),
);

Response htmlFragments(List<HTML> fragments, {int status = HttpStatus.ok, Encoding enc = utf8}) => Response(
  status,
  body: Body.fromString(fragments.toHtml(), encoding: enc, mimeType: MimeType.html),
);

Response htmlFragmentsOob(List<HTML> fragments, {int status = HttpStatus.ok, Encoding enc = utf8}) => Response(
  status,
  body: Body.fromString(fragments.map((fragment) => fragment.add($("hx-swap-oob")("true"))).toList().toHtml(), encoding: enc, mimeType: MimeType.html),
);
