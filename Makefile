
docker: submodules
	docker build -t sdl3cs_image .
	docker rm sdl3cs
	docker run --name sdl3cs sdl3cs_image
	docker cp sdl3cs:/GenerateBindings/assets/ffi.json ./GenerateBindings/assets/ffi.json
	docker cp sdl3cs:/SDL3/SDL3.Core.cs ./SDL3/SDL3.Core.cs
	docker cp sdl3cs:/SDL3/SDL3.Legacy.cs ./SDL3/SDL3.Legacy.cs
	docker rm sdl3cs
	docker rmi sdl3cs_image

submodules:
	git submodule update --init
	cd SDL && git pull origin main

.PHONY: docker submodules