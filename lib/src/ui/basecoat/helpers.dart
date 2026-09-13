import "package:htmleez/htmleez.dart";

class BasecoatHelpers {
  static HTML normalizeComponent(Object? component) {
    if (component == null) {
      return "".t;
    }

    if (component is HTML) {
      return component;
    }

    if (component is List<HTML>) {
      return HTML.fragment(component);
    }

    return component.toString().t;
  }
}
