// ignore_for_file: non_constant_identifier_names

import "package:htmleez/htmleez.dart";

HTML $_disableFieldsetsOnHtmxRequest() => raw$("_")("on htmx:before:request toggle @disabled on <fieldset/> in me until htmx:finally:request");
