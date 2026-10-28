.PHONY: help start templates css lucide basecoat dev prod

help:
	@printf "Available commands:\n"
	@printf "  make start     rebuild CSS and templates, then run the development server\n"
	@printf "  make dev       generate templates and run the development server (with /ui)\n"
	@printf "  make prod      generate templates and run the production-like server\n"
	@printf "  make templates generate lib/generated/html.dart with abs\n"
	@printf "  make css       rebuild public/index.css\n"
	@printf "  make basecoat  download Basecoat CSS bundles and JS\n"
	@printf "  make lucide    download pinned Lucide browser JS\n"

start: css
	$(MAKE) dev

templates:
	abs

css:
	npx @tailwindcss/cli -i ./input.css -o ./public/index.css --minify

lucide:
	@mkdir -p public/js
	@set -eu; \
	temp=$$(mktemp public/js/lucide.min.js.XXXXXX); \
	trap 'rm -f "$$temp"' EXIT; \
	curl --fail --location https://unpkg.com/lucide@1.33.0/dist/umd/lucide.min.js --output "$$temp"; \
	mv "$$temp" public/js/lucide.min.js

basecoat:
	dart run bin/download_basecoat.dart

dev: templates
	DEV=true dart run bin/server.dart

prod: templates
	dart run bin/server.dart

.DEFAULT_GOAL := help
