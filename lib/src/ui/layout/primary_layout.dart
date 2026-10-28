import "package:absurd_starter/generated/html.dart";

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
  description: "A Dart starter using Relic, HTMX, Tailwind, Basecoat, and Absurd Templates.",
);

Fragment primaryLayout(Fragment bodyContent, {PageSeo seo = defaultSeo}) => Html.layout.primary(title: seo.title, description: seo.description, content: bodyContent);
