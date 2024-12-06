
docker: submodules
	docker build -t sdl3-gen .
	docker run --rm -v .:/app -w /app --name sdl3-cs -it sdl3-gen 

submodules:
	git submodule update --init
	cd SDL && git pull origin main

.PHONY: docker submodules