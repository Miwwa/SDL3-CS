FROM ubuntu:noble
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y
RUN apt install -y wget software-properties-common

# install dotnet
RUN apt install -y dotnet-sdk-8.0

# install llvm 18 and cmake
RUN wget -qO- https://apt.llvm.org/llvm.sh | bash -s -- 18
RUN apt install -y libclang-18-dev libclang-cpp18-dev cmake
ENV CC="/usr/bin/clang-18" \
    CXX="/usr/bin/clang++-18"

# Copy the source into the Docker container
RUN mkdir -p /c2ffi
RUN mkdir -p /SDL/include
RUN mkdir -p /SDL3
RUN mkdir -p /GenerateBindings

COPY /c2ffi /c2ffi
COPY /SDL/include /SDL/include
COPY /SDL3 /SDL3
COPY /GenerateBindings /GenerateBindings

# Build c2ffi
WORKDIR /
RUN cd ./c2ffi && \
    rm -rf build && mkdir -p build && cd build && \
    cmake -DBUILD_CONFIG=Release .. && make

# Generate ffi.json from sdl headers
RUN /c2ffi/build/bin/c2ffi -i /SDL/include -o /GenerateBindings/assets/ffi.json /GenerateBindings/assets/ffi.h

WORKDIR /GenerateBindings
RUN dotnet publish GenerateBindings.csproj -c Release
RUN /GenerateBindings/bin/Release/net8.0/publish/GenerateBindings /SDL
RUN /GenerateBindings/bin/Release/net8.0/publish/GenerateBindings /SDL --core