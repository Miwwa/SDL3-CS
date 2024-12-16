
docker: submodules
	docker build -t sdl3-gen .
	docker run --rm -v .:/app -w /app --env-file ./.env --name sdl3-cs sdl3-gen

submodules:
	git submodule update --init
	git submodule update --remote SDL

.PHONY: docker submodules