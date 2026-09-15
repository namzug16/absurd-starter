import "package:absurd_starter/config.dart";
import "package:htmleez/htmleez.dart";

class PageSeo {
  const PageSeo({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

const defaultSeo = PageSeo(
  title: "Absurd Starter",
  description: "A Dart starter using Netto, HTMX, hyperscript, Tailwind, Basecoat, and htmleez.",
);

HTML primaryLayout(HTML bodyContent, {PageSeo seo = defaultSeo}) => html([
  head([
    meta([$("charset")("UTF-8")]),
    meta([$("name")("viewport"), $("content")("width=device-width, initial-scale=1.0")]),
    title([seo.title.t]),
    meta([$("name")("description"), $("content")(seo.description)]),
    link([$("rel")("stylesheet"), $("href")("/index.css")]),
    script([$("src")("https://unpkg.com/hyperscript.org@0.9.14")]),
    script([
      $("src")("https://cdn.jsdelivr.net/npm/htmx.org@4.0.0/dist/htmx.min.js"),
      $("integrity")("sha384-BvJpBiO8Kh31EqtJe5DRIeWrHWnCGkwytKs9NKFi86Hhw96dEqdEMzZDeK9iEGTc"),
      $("crossorigin")("anonymous"),
    ]),
    script([$("src")("/basecoat.all.min.js")]),
    script([$("src")("/index.js")]),
    if (Config.dev)
      Raw(r"""
<script>
  const source = new EventSource('/__dev/reload');

  function reloadWhenServerIsReady() {
    fetch(window.location.href, { cache: 'no-store', credentials: 'same-origin' })
      .then(() => window.location.reload())
      .catch(() => setTimeout(reloadWhenServerIsReady, 150));
  }

  source.onmessage = function (event) {
    if (event.data === 'reload') {
      source.close();
      setTimeout(reloadWhenServerIsReady, 150);
    }
  };
</script>
"""),
  ]),
  bodyContent,
]);
