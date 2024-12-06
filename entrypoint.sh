#!/bin/bash

echo "Generating ffi.json"
/c2ffi/build/bin/c2ffi -i ./SDL/include -o ./GenerateBindings/assets/ffi.json ./GenerateBindings/assets/ffi.h

echo "Generating SDL3.Legacy.cs"
/GenerateBindings/bin/Release/net8.0/publish/GenerateBindings ./SDL >&2
echo "Generating SDL3.Core.cs"
/GenerateBindings/bin/Release/net8.0/publish/GenerateBindings ./SDL --core >&2