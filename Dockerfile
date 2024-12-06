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

# Build c2ffi
RUN mkdir -p /c2ffi
COPY /c2ffi /c2ffi
WORKDIR /c2ffi
RUN rm -rf build && mkdir -p build && cd build && \
    cmake -DBUILD_CONFIG=Release .. && make

# Build GenerateBindings project
RUN mkdir -p /GenerateBindings
COPY /GenerateBindings /GenerateBindings
WORKDIR /GenerateBindings
RUN dotnet publish GenerateBindings.csproj -c Release

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]