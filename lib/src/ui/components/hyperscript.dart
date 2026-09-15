// ignore_for_file: non_constant_identifier_names

import "package:htmleez/htmleez.dart";

HTML $disableFieldsetsAndShowLoadersOnHtmxRequest() => raw$("_")("on htmx:before:request toggle @disabled on <fieldset/> in me toggle .hidden on .loader in me until htmx:finally:request");

HTML $_disableFieldsetsOnHtmxRequest() => raw$("_")("on htmx:before:request toggle @disabled on <fieldset/> in me until htmx:finally:request");

HTML $_toggleLoaderOnHtmxRequest() => raw$("_")("on htmx:before:request from the closest <form/> toggle .hidden on .loader in me until htmx:finally:request from the closest <form/>");

HTML $_toggleDisabledOnHtmxRequest() => raw$("_")("on htmx:before:request toggle @disabled on me until htmx:finally:request");
