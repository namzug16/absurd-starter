// ignore_for_file: non_constant_identifier_names

import "package:htmleez/htmleez.dart";

RawAttribute $_() => RawAttribute("_");

HTML $disableFieldsetsAndShowLoadersOnHtmxRequest() => $_()("on htmx:beforeSend toggle @disabled on <fieldset/> in me toggle .hidden on .loader in me until htmx:afterOnLoad");

HTML $_disableFieldsetsOnHtmxRequest() => $_()("on htmx:beforeSend toggle @disabled on <fieldset/> in me until htmx:afterOnLoad");

HTML $_toggleLoaderOnHtmxRequest() => $_()("on htmx:beforeSend from the closest <form/> toggle .hidden on .loader in me until htmx:afterOnLoad from the closest <form/>");

HTML $_toggleDisabledOnHtmxRequest() => $_()("on htmx:beforeSend toggle @disabled on me until htmx:afterOnLoad");
