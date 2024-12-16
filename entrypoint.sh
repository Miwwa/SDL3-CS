#!/bin/bash

echo "Generating ffi.json"
/c2ffi/build/bin/c2ffi -i ./SDL/include -o ./GenerateBindings/assets/ffi.json ./GenerateBindings/assets/ffi.h

echo "Building dotnet project..."
if ! dotnet publish ./GenerateBindings/GenerateBindings.csproj -c Release; then
  echo "Error occurred while building GenerateBindings.csproj, exiting script."
  exit 1
fi

echo "Generating SDL3.Legacy.cs"
if ! ./GenerateBindings/bin/Release/net8.0/publish/GenerateBindings ./SDL; then
    echo "Error occurred while generating SDL3.Legacy.cs, exiting script."
    exit 1
fi
echo "Generating SDL3.Core.cs"
if ! ./GenerateBindings/bin/Release/net8.0/publish/GenerateBindings ./SDL --core; then
    echo "Error occurred while generating SDL3.Core.cs, exiting script."
    exit 1
fi

# download and copy native libs
SDL_REPO="https://github.com/libsdl-org/SDL"
SDL_WIN_X64=SDL-VC-x64
SDL_OSX_ARM64=SDL-macos-arm64-gnu

echo "Download native libs..."

git config --global --add safe.directory /app
SDL_COMMIT=$(git ls-tree HEAD SDL --object-only)
echo "SDL_COMMIT=$SDL_COMMIT"
RUN_ID=$(gh run list -c "$SDL_COMMIT" --json databaseId --jq '.[] | .databaseId' -R $SDL_REPO)
echo "RUN_ID=$RUN_ID"

rm -rf ./downloads
gh run download "$RUN_ID" \
  -n $SDL_WIN_X64 \
  -n $SDL_OSX_ARM64 \
  --dir=./downloads \
  -R $SDL_REPO

ROOT_PATH=$(realpath ./)
NATIVE_PATH=$(realpath ./native)
DOWNLOADS_PATH=$(realpath ./downloads)

echo "Copy sdl lib for win-x64"
cd "$DOWNLOADS_PATH/$SDL_WIN_X64/dist" || exit
unzip "$(find . -type f -name "*Windows-VC*")"
mkdir -p "$NATIVE_PATH/win-x64"
cp "$(find . -type d -name "*Windows-VC*")/bin/SDL3.dll" "$NATIVE_PATH/win-x64/SDL3.dll"
cp "$(find . -type d -name "*Windows-VC*")/lib/SDL3.lib" "$NATIVE_PATH/win-x64/SDL3.lib"

echo "Copy sdl lib for osx-arm64"
cd "$DOWNLOADS_PATH/$SDL_OSX_ARM64/dist" || exit
tar -xzf "$(find . -type f -name "*-macOS.tar.gz")"
mkdir -p "$NATIVE_PATH/osx-arm64"
cp "$(find . -type d -name "*-macOS")/lib/libSDL3.0.dylib" "$NATIVE_PATH/osx-arm64/libSDL3.0.dylib"
cp "$(find . -type d -name "*-macOS")/lib/libSDL3.a"       "$NATIVE_PATH/osx-arm64/libSDL3.a"


echo "Cleanup..."
cd "$ROOT_PATH" || exit
rm -rf "$DOWNLOADS_PATH"
