FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

ENV USER docker

RUN apt-get update && apt-get upgrade -y

RUN apt-get -f install -y \
    apt-src \
    autoconf \
    autogen \
    bison \
    dejagnu \
    flex \
    flip \
    gawk \
    git-core \
    subversion \
    gperf \
    gzip \
    libgmp3-dev \
    libmpfr-dev \
    nsis \
    openssh-client \
    p7zip-full \
    perl \
    python-dev \
    libisl-dev \
    scons \
    tcl \
    texinfo \
    tofrodos \
    wget \
    zip \
    texlive \
    texlive-extra-utils \
    libncurses5-dev

# Seperate mingw-w64 installation as it may need a different version
# than system default
RUN apt-get install -y  \
    gcc-mingw-w64-i686 \
    g++-mingw-w64-i686 \
    binutils-mingw-w64-i686

RUN cd /usr/share/nsis/Include; wget http://nsis.sourceforge.net/mediawiki/images/a/ad/EnvVarUpdate.7z; 7za e EnvVarUpdate.7z

CMD ["/bin/bash"]
