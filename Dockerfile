# Check for latest version here: https://hub.docker.com/_/buildpack-deps?tab=tags&page=1&name=buster&ordering=last_updated
# This is just a snapshot of buildpack-deps:buster that was last updated on 2019-12-28.
FROM judge0/buildpack-deps:buster-2019-12-28

# Check for latest version here: https://gcc.gnu.org/releases.html, https://ftpmirror.gnu.org/gcc
ENV GCC_VERSIONS \
      8.3.0 \
      9.2.0 \
      12.1.0 \
      14.1.0

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
      if [ $VERSION = "9.2.0" ]; then \
        ENABLE_FORTRAN=",fortran"; \
      else \
        ENABLE_FORTRAN=""; \
      fi; \
      /tmp/gcc-$VERSION/configure \
        --disable-multilib \
        --enable-languages=c,c++$ENABLE_FORTRAN \
        --prefix=/usr/local/gcc-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install-strip && \
      rm -rf /tmp/*; \
    done

# Check for latest version here: https://www.python.org/downloads
ENV PYTHON_VERSIONS \
      3.8.1 \
      3.12.7 \
      2.7.17
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

# Check for latest version here: https://jdk.java.net
RUN set -xe && \
    curl -fSsL "https://download.java.net/java/GA/jdk13.0.1/cec27d702aa74d5a8630c65ae61e4305/9/GPL/openjdk-13.0.1_linux-x64_bin.tar.gz" -o /tmp/openjdk13.tar.gz && \
    mkdir /usr/local/openjdk13 && \
    tar -xf /tmp/openjdk13.tar.gz -C /usr/local/openjdk13 --strip-components=1 && \
    rm /tmp/openjdk13.tar.gz && \
    ln -s /usr/local/openjdk13/bin/javac /usr/local/bin/javac && \
    ln -s /usr/local/openjdk13/bin/java /usr/local/bin/java && \
    ln -s /usr/local/openjdk13/bin/jar /usr/local/bin/jar

# Check for latest version here: https://ftpmirror.gnu.org/bash
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

# Check for latest version here: https://www.mono-project.com/download/stable
ENV MONO_VERSIONS \
      6.6.0.161
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends cmake && \
    rm -rf /var/lib/apt/lists/* && \
    for VERSION in $MONO_VERSIONS; do \
      curl -fSsL "https://download.mono-project.com/sources/mono/mono-$VERSION.tar.xz" -o /tmp/mono-$VERSION.tar.xz && \
      mkdir /tmp/mono-$VERSION && \
      tar -xf /tmp/mono-$VERSION.tar.xz -C /tmp/mono-$VERSION --strip-components=1 && \
      rm /tmp/mono-$VERSION.tar.xz && \
      cd /tmp/mono-$VERSION && \
      ./configure \
        --prefix=/usr/local/mono-$VERSION && \
      make -j$(nproc) && \
      make -j$(proc) install && \
      rm -rf /tmp/*; \
    done

# Check for latest version here: https://nodejs.org/en
ENV NODE_VERSIONS \
      12.14.0
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
      1.40.0
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

# Check for latest version here: https://golang.org/dl
ENV GO_VERSIONS \
      1.13.5
RUN set -xe && \
    for VERSION in $GO_VERSIONS; do \
      curl -fSsL "https://storage.googleapis.com/golang/go$VERSION.linux-amd64.tar.gz" -o /tmp/go-$VERSION.tar.gz && \
      mkdir /usr/local/go-$VERSION && \
      tar -xf /tmp/go-$VERSION.tar.gz -C /usr/local/go-$VERSION --strip-components=1 && \
      rm -rf /tmp/*; \
    done

# Check for latest version here: https://sourceforge.net/projects/fbc/files/Binaries%20-%20Linux
ENV FBC_VERSIONS \
      1.07.1
RUN set -xe && \
    for VERSION in $FBC_VERSIONS; do \
      curl -fSsL "https://downloads.sourceforge.net/project/fbc/Binaries%20-%20Linux/FreeBASIC-$VERSION-linux-x86_64.tar.gz" -o /tmp/fbc-$VERSION.tar.gz && \
      mkdir /usr/local/fbc-$VERSION && \
      tar -xf /tmp/fbc-$VERSION.tar.gz -C /usr/local/fbc-$VERSION --strip-components=1 && \
      rm -rf /tmp/*; \
    done

# Check for latest version here: https://github.com/microsoft/TypeScript/releases
ENV TYPESCRIPT_VERSIONS \
      3.7.4
RUN set -xe && \
    curl -fSsL "https://deb.nodesource.com/setup_12.x" | bash - && \
    apt-get update && \
    apt-get install -y --no-install-recommends nodejs && \
    rm -rf /var/lib/apt/lists/* && \
    for VERSION in $TYPESCRIPT_VERSIONS; do \
      npm install -g typescript@$VERSION; \
    done

# Check for latest version here: https://kotlinlang.org
ENV KOTLIN_VERSIONS \
      1.3.70
RUN set -xe && \
    for VERSION in $KOTLIN_VERSIONS; do \
      curl -fSsL "https://github.com/JetBrains/kotlin/releases/download/v$VERSION/kotlin-compiler-$VERSION.zip" -o /tmp/kotlin-$VERSION.zip && \
      unzip -d /usr/local/kotlin-$VERSION /tmp/kotlin-$VERSION.zip && \
      mv /usr/local/kotlin-$VERSION/kotlinc/* /usr/local/kotlin-$VERSION/ && \
      rm -rf /usr/local/kotlin-$VERSION/kotlinc && \
      rm -rf /tmp/*; \
    done

RUN set -xe && \
    mkdir -p /usr/local/include/catch2 && \
    wget https://raw.githubusercontent.com/catchorg/Catch2/refs/tags/v2.13.8/single_include/catch2/catch.hpp -P /usr/local/include/catch2

# Check for latest version here: https://hub.docker.com/_/mono
# I currently use this to add support for Visual Basic.Net but this can be also
# used to support C# language which has been already supported but with manual
# installation of Mono (see above).
ENV MONO_VERSION 6.6.0.161
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends gnupg dirmngr && \
    rm -rf /var/lib/apt/lists/* && \
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    gpg --batch --export --armor 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF > /etc/apt/trusted.gpg.d/mono.gpg.asc && \
    gpgconf --kill all && \
    rm -rf "$GNUPGHOME" && \
    apt-key list | grep Xamarin && \
    apt-get purge -y --auto-remove gnupg dirmngr && \
    echo "deb http://download.mono-project.com/repo/debian stable-stretch/snapshots/$MONO_VERSION main" > /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends mono-vbnc && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# Check for latest version here: https://packages.debian.org/buster/clang-7
# Used for additional compilers for C, C++ and used for Objective-C.
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends clang-7 gnustep-devel && \
    rm -rf /var/lib/apt/lists/*

# Check for latest version here: https://packages.debian.org/buster/sqlite3
# Used for support of SQLite.
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends sqlite3 && \
    rm -rf /var/lib/apt/lists/*

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

LABEL maintainer="edugatorlabs <csinfraweb@gmail.com>"
LABEL version="0.0.1"
