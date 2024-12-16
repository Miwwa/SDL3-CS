FROM ubuntu:noble
ENV DEBIAN_FRONTEND=noninteractive

# add Github CLI apt source 
RUN (type -p wget >/dev/null || (apt update && apt-get install -y wget)) \
    	&& mkdir -p -m 755 /etc/apt/keyrings \
            && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
            && cat $out | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    	&& chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    	&& apt update -y;

RUN apt install -y software-properties-common gh unzip dotnet-sdk-8.0

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

ARG CACHE=3
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]