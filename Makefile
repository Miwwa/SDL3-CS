
SDL_REPO="https://github.com/libsdl-org/SDL"
SDL_WIN_X64=SDL-VC-x64

docker: submodules
	docker build -t sdl3-gen .
	docker run --rm -v .:/app -w /app --name sdl3-cs sdl3-gen 

submodules:
	git submodule update --init
	cd SDL && git pull origin main

native:
	mkdir -p ./native/win-x64
	mkdir -p ./native/osx-arm64
	rm -rf ./downloads
	@SDL_COMMIT=$$(git ls-tree HEAD SDL --object-only); \
	echo "SDL_COMMIT=$$SDL_COMMIT"; \
	JOB_ID=$$(gh run list -c $$SDL_COMMIT --json databaseId --jq '.[] | .databaseId' -R ${SDL_REPO}); \
	echo "JOB_ID=$$JOB_ID"; \
	gh run download $$JOB_ID -n ${SDL_WIN_X64} --dir=./downloads -R ${SDL_REPO}; \
	cd ./downloads/dist && unzip $$(find -type f -name "*Windows-VC*")
	cp $$(find ./downloads/dist -type d -name "*Windows-VC*")/bin/SDL3.dll ./native/win-x64/SDL3.dll
	cp $$(find ./downloads/dist -type d -name "*Windows-VC*")/lib/SDL3.lib ./native/win-x64/SDL3.lib
	


.PHONY: docker submodules native