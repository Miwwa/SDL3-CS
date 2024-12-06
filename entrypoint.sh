#!/bin/bash

echo "Generating ffi.json"
/c2ffi/build/bin/c2ffi -i ./SDL/include -o ./GenerateBindings/assets/ffi.json ./GenerateBindings/assets/ffi.h

echo "Generating SDL3.Legacy.cs"
if ! /GenerateBindings/bin/Release/net8.0/publish/GenerateBindings ./SDL; then
    echo "Error occurred while generating SDL3.Legacy.cs, exiting script."
    exit 1
fi
echo "Generating SDL3.Core.cs"
if ! /GenerateBindings/bin/Release/net8.0/publish/GenerateBindings ./SDL --core; then
    echo "Error occurred while generating SDL3.Core.cs, exiting script."
    exit 1
fi