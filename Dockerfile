# Check for latest version here: https://hub.docker.com/_/buildpack-deps?tab=tags&page=1&name=buster&ordering=last_updated
# This is just a snapshot of buildpack-deps:buster that was last updated on 2019-12-28.
FROM judge0/buildpack-deps:buster-2019-12-28

# Check for latest version here: https://gcc.gnu.org/releases.html, https://ftpmirror.gnu.org/gcc
# build image comes with gcc and g++ 8.3.0 by default
ENV GCC_VERSIONS \
      12.1.0

RUN set -xe && \
    for VERSION in $GCC_VERSIONS; do \
      curl -fSsL "https://ftpmirror.gnu.org/gcc/gcc-$VERSION/gcc-$VERSION.tar.gz" -o /tmp/gcc-$VERSION.tar.gz && \
      mkdir /tmp/gcc-$VERSION && \
      tar -xf /tmp/gcc-$VERSION.tar.gz -C /tmp/gcc-$VERSION --strip-components=1 && \
      rm /tmp/gcc-$VERSION.tar.gz && \
      cd /tmp/gcc-$VERSION && \
      ./contrib/download_prerequisites && \
      { rm *.tar.* || true; } && \
      tmpdir="$(mktemp -d)" && \
      cd "$tmpdir"; \
      /tmp/gcc-$VERSION/configure \
        --disable-multilib \
        --enable-languages=c,c++,fortran \
        --prefix=/usr/local/gcc-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install-strip && \
      rm -rf /tmp/*; \
    done

# Check for latest version here: https://www.ruby-lang.org/en/downloads
ENV RUBY_VERSIONS \
      2.7.0
RUN set -xe && \
    for VERSION in $RUBY_VERSIONS; do \
      curl -fSsL "https://cache.ruby-lang.org/pub/ruby/${VERSION%.*}/ruby-$VERSION.tar.gz" -o /tmp/ruby-$VERSION.tar.gz && \
      mkdir /tmp/ruby-$VERSION && \
      tar -xf /tmp/ruby-$VERSION.tar.gz -C /tmp/ruby-$VERSION --strip-components=1 && \
      rm /tmp/ruby-$VERSION.tar.gz && \
      cd /tmp/ruby-$VERSION && \
      ./configure \
        --disable-install-doc \
        --prefix=/usr/local/ruby-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

# Change default gcc / g++ after Ruby installation
# Ruby 2.7.0 needs gcc-8.0
RUN ln -sf /usr/local/gcc-12.1.0/bin/gcc /usr/bin/gcc && \
    ln -sf /usr/local/gcc-12.1.0/bin/g++ /usr/bin/g++

# Check for latest version here: https://www.python.org/downloads
# python3.11 is already installed
ENV PYTHON_VERSIONS \
      3.12.7
RUN set -xe && \
    for VERSION in $PYTHON_VERSIONS; do \
      curl -fSsL "https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tar.xz" -o /tmp/python-$VERSION.tar.xz && \
      mkdir /tmp/python-$VERSION && \
      tar -xf /tmp/python-$VERSION.tar.xz -C /tmp/python-$VERSION --strip-components=1 && \
      rm /tmp/python-$VERSION.tar.xz && \
      cd /tmp/python-$VERSION && \
      ./configure \
        --prefix=/usr/local/python-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

RUN ln -sf /usr/local/python-3.12.7/bin/python3 /usr/bin/python3 && \
    ln -sf /usr/local/python-3.12.7/bin/python3 /usr/bin/python

ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PYTHONWARNINGS=ignore
# Install pandas and numpy on python 3.12
RUN set -xe && \
    python3 -m ensurepip && \
    pip3 install --no-cache-dir pandas numpy

# Check for latest version here: https://jdk.java.net
RUN set -xe && \
    curl -fSsL "https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz" -o /tmp/openjdk21.tar.gz && \
    mkdir /usr/local/openjdk21 && \
    tar -xf /tmp/openjdk21.tar.gz -C /usr/local/openjdk21 --strip-components=1 && \
    rm /tmp/openjdk21.tar.gz && \
    ln -s /usr/local/openjdk21/bin/javac /usr/local/bin/javac && \
    ln -s /usr/local/openjdk21/bin/java /usr/local/bin/java && \
    ln -s /usr/local/openjdk21/bin/jar /usr/local/bin/jar

## Check for latest version here: https://ftpmirror.gnu.org/bash
ENV BASH_VERSIONS \
      5.0
RUN set -xe && \
    for VERSION in $BASH_VERSIONS; do \
      curl -fSsL "https://ftpmirror.gnu.org/bash/bash-$VERSION.tar.gz" -o /tmp/bash-$VERSION.tar.gz && \
      mkdir /tmp/bash-$VERSION && \
      tar -xf /tmp/bash-$VERSION.tar.gz -C /tmp/bash-$VERSION --strip-components=1 && \
      rm /tmp/bash-$VERSION.tar.gz && \
      cd /tmp/bash-$VERSION && \
      ./configure \
        --prefix=/usr/local/bash-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

# Check for latest version here: https://nodejs.org/en
ENV NODE_VERSIONS \
      22.12.0
RUN set -xe && \
    for VERSION in $NODE_VERSIONS; do \
      curl -fSsL "https://nodejs.org/dist/v$VERSION/node-v$VERSION.tar.gz" -o /tmp/node-$VERSION.tar.gz && \
      mkdir /tmp/node-$VERSION && \
      tar -xf /tmp/node-$VERSION.tar.gz -C /tmp/node-$VERSION --strip-components=1 && \
      rm /tmp/node-$VERSION.tar.gz && \
      cd /tmp/node-$VERSION && \
      ./configure \
        --prefix=/usr/local/node-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

# Check for latest version here: https://www.rust-lang.org
ENV RUST_VERSIONS \
      1.83.0
RUN set -xe && \
    for VERSION in $RUST_VERSIONS; do \
      curl -fSsL "https://static.rust-lang.org/dist/rust-$VERSION-x86_64-unknown-linux-gnu.tar.gz" -o /tmp/rust-$VERSION.tar.gz && \
      mkdir /tmp/rust-$VERSION && \
      tar -xf /tmp/rust-$VERSION.tar.gz -C /tmp/rust-$VERSION --strip-components=1 && \
      rm /tmp/rust-$VERSION.tar.gz && \
      cd /tmp/rust-$VERSION && \
      ./install.sh \
        --prefix=/usr/local/rust-$VERSION \
        --components=rustc,rust-std-x86_64-unknown-linux-gnu && \
      rm -rf /tmp/*; \
    done

## Check for latest version here: https://golang.org/dl
ENV GO_VERSIONS \
      1.13.5
RUN set -xe && \
    for VERSION in $GO_VERSIONS; do \
      curl -fSsL "https://storage.googleapis.com/golang/go$VERSION.linux-amd64.tar.gz" -o /tmp/go-$VERSION.tar.gz && \
      mkdir /usr/local/go-$VERSION && \
      tar -xf /tmp/go-$VERSION.tar.gz -C /usr/local/go-$VERSION --strip-components=1 && \
      rm -rf /tmp/*; \
    done

## Check for latest version here: https://github.com/microsoft/TypeScript/releases
#ENV TYPESCRIPT_VERSIONS \
#      3.7.4
#RUN set -xe && \
#    curl -fSsL "https://deb.nodesource.com/setup_12.x" | bash - && \
#    apt-get update && \
#    apt-get install -y --no-install-recommends nodejs && \
#    rm -rf /var/lib/apt/lists/* && \
#    for VERSION in $TYPESCRIPT_VERSIONS; do \
#      npm install -g typescript@$VERSION; \
#    done

RUN set -xe && \
    mkdir -p /usr/local/include/catch2 && \
    wget https://raw.githubusercontent.com/catchorg/Catch2/refs/tags/v2.13.8/single_include/catch2/catch.hpp -P /usr/local/include/catch2

RUN set -xe && \
    mkdir -p /usr/local/junit && \
    wget https://repo1.maven.org/maven2/junit/junit/4.13.2/junit-4.13.2.jar -P /usr/local/junit && \
    wget https://repo1.maven.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar -P /usr/local/junit

RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends locales && \
    rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends git libcap-dev && \
    rm -rf /var/lib/apt/lists/* && \
    git clone https://github.com/judge0/isolate.git /tmp/isolate && \
    cd /tmp/isolate && \
    git checkout ad39cc4d0fbb577fb545910095c9da5ef8fc9a1a && \
    make -j$(nproc) install && \
    rm -rf /tmp/*
ENV BOX_ROOT /var/local/lib/isolate

LABEL maintainer="edugatorlabs <edugatorlabs@gmail.com>"
LABEL version="0.0.1"