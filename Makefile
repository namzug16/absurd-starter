.PHONY: help start css lucide basecoat dev prod

help:
	@printf "Available commands:\n"
	@printf "  make start     rebuild CSS, then run the development server\n"
	@printf "  make dev       run the development server\n"
	@printf "  make prod      run the production-like server\n"
	@printf "  make css       rebuild public/index.css\n"
	@printf "  make basecoat  download Basecoat CSS bundles and JS\n"
	@printf "  make lucide    regenerate Lucide Dart icon helpers\n"

start: css dev

css:
	npx @tailwindcss/cli -i ./input.css -o ./public/index.css --minify

lucide:
	dart run bin/generate_lucide.dart

basecoat:
	dart run bin/download_basecoat.dart

dev:
	DEV=true dart run --enable-vm-service bin/server.dart

prod:
	dart run bin/server.dart

.DEFAULT_GOAL := help
