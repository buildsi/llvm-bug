FROM ghcr.io/autamus/cmake:3.21.2

# docker build -t llvm-project .

ARG LLVM_DIR=./llvm-project
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y build-essential python3 python3-dev python3-pip gringo git

WORKDIR /opt
RUN git clone --depth 1 https://github.com/spack/spack && \
    pip3 install --upgrade pip && \
    pip3 install botocore boto3

RUN apt-get install -y software-properties-common && \
    add-apt-repository 'deb http://mirrors.kernel.org/ubuntu hirsute main universe' && \
    apt-get update && \
    apt-get install -y gcc-11 g++-11 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 70 --slave /usr/bin/g++ g++ /usr/bin/g++-7 --slave /usr/bin/gcov gcov /usr/bin/gcov-7 --slave /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-7 --slave /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-7 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 110 --slave /usr/bin/g++ g++ /usr/bin/g++-11 --slave /usr/bin/gcov gcov /usr/bin/gcov-11 --slave /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-11 --slave /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-11;

RUN spack install diffutils
RUN spack install ncurses
WORKDIR /code
COPY ${LLVM_DIR} /code
RUN spack dev-build llvm@main build_type=Release
