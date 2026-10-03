import "package:htmleez/htmleez.dart";

List<HTML> $disableFieldsetsOnHtmxRequest() => [
  $("hx-on:htmx:before:request")("this.querySelectorAll('fieldset').forEach((fieldset) => fieldset.disabled = true)"),
  $("hx-on:htmx:finally:request")("this.querySelectorAll('fieldset').forEach((fieldset) => fieldset.disabled = false)"),
];
