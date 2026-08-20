_: css dev

css:
	npx @tailwindcss/cli -i ./input.css -o ./public/index.css --minify

lucide:
	dart run bin/generate_lucide.dart

dev:
	DEV=true dart run --enable-vm-service bin/server.dart

prod:
	dart run bin/server.dart

.DEFAULT_GOAL := _
