import "package:absurd_starter/generated/html.dart";
import "package:absurd_starter/src/ui/components/temporary_dialog.dart";
import "package:test/test.dart";

void main() {
  test("layout escapes SEO and composes fragments without escaping markup", () {
    final html = Html.layout.primary(
      title: "<script> & title",
      description: '" onload="alert(1)',
      body: Html.counter(count: "7"),
    ).toHtml();

    expect(html, startsWith("<!DOCTYPE html>"));
    expect(html, contains("&lt;script&gt; &amp; title"));
    expect(html, contains('content="&quot; onload=&quot;alert(1)"'));
    expect(html, contains('<div id="counter-result"'));
    expect(html, isNot(contains("&lt;div")));
    expect(html, contains('src="/js/lucide.min.js"'));
    expect(html.indexOf("/js/lucide.min.js"), lessThan(html.indexOf("/index.js")));
  });

  test("home uses template icon placeholders and a single counter input", () {
    final html = Html.pages.home().toHtml();
    expect(html, contains('data-lucide="plus"'));
    expect(html, contains('hx-post="/api/counter/increment"'));
    expect(html, contains("hx-on:htmx:finally:request="));
    expect('name="count"'.allMatches(html), hasLength(1));
    expect(html, contains('value="0" form="counter-form"'));
  });

  test("counter is a fragment without document or script wrappers", () {
    final html = Html.counter(count: "3").toHtml();
    expect(html, contains('value="3" form="counter-form"'));
    expect(html, isNot(contains("<!DOCTYPE")));
    expect(html, isNot(contains("<script")));
  });

  test("temporary dialogs preserve escaping, content and lifecycle marker", () {
    final html = temporaryDialog(
      id: "details",
      title: "<Details>",
      description: "A & B",
      body: Html.counter(count: "2"),
      footer: Html.counter(count: "4"),
    ).toHtml();
    expect(html, contains("data-temporary-dialog"));
    expect(html, contains('aria-describedby="details-description"'));
    expect(html, contains("&lt;Details&gt;"));
    expect(html, contains("A &amp; B"));
    expect(html, contains("<footer>"));
    expect(html, contains('aria-label="Close dialog"'));
    expect(html, isNot(contains("<script")));
  });

  test("optional temporary dialog sections can be disabled", () {
    final html = temporaryDialog(
      id: "details",
      title: "Details",
      body: Html.counter(count: "0"),
      closeButton: false,
      closeOnOverlayClick: false,
    ).toHtml();
    expect(html, isNot(contains("<footer>")));
    expect(html, isNot(contains('id="details-description"')));
    expect(html, isNot(contains('aria-label="Close dialog"')));
    expect(html, isNot(contains("event.target")));
  });
}
