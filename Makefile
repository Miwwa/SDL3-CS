
docker: submodules
	docker build -t sdl3cs .
	docker run --name sdl3cs sdl3cs
	docker cp sdl3cs:/SDL3/SDL3.Core.cs ./SDL3/SDL3.Core.cs
	docker cp sdl3cs:/SDL3/SDL3.Legacy.cs ./SDL3/SDL3.Legacy.cs
	docker image prune -f
	docker container prune -f

submodules:
	cd SDL && git pull origin main
	git submodule update --init

.PHONY: docker submodules