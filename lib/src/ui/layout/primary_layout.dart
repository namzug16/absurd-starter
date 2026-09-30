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
  description: "A Dart starter using Relic, HTMX, hyperscript, Tailwind, Basecoat, and htmleez.",
);

HTML primaryLayout(HTML bodyContent, {PageSeo seo = defaultSeo}) => html([
  head([
    meta([$("charset")("UTF-8")]),
    meta([$("name")("viewport"), $("content")("width=device-width, initial-scale=1.0")]),
    title([seo.title.t]),
    meta([$("name")("description"), $("content")(seo.description)]),
    link([$("rel")("stylesheet"), $("href")("/index.css")]),
    script([
      $("src")("https://cdn.jsdelivr.net/npm/hyperscript.org@0.9.93/dist/_hyperscript.min.js"),
      $("integrity")("sha384-/6HsqTiz02YfFBUhzTwlH/yxe68DhfnkdHiWytM3nxAzs/yvG+3FZY0f4KLnNoov"),
      $("crossorigin")("anonymous"),
    ]),
    script([
      $("src")("https://cdn.jsdelivr.net/npm/htmx.org@4.0.0/dist/htmx.min.js"),
      $("integrity")("sha384-BvJpBiO8Kh31EqtJe5DRIeWrHWnCGkwytKs9NKFi86Hhw96dEqdEMzZDeK9iEGTc"),
      $("crossorigin")("anonymous"),
    ]),
    script([$("src")("/basecoat.all.min.js")]),
    script([$("src")("/index.js")]),
  ]),
  bodyContent,
]);
