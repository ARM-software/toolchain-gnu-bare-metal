FROM ubuntu:14.04

COPY sources.list /etc/apt/sources.list

COPY xenial.list /etc/apt/sources.list.d/xenial.list

RUN echo 'APT::Default-Release "trusty";' > /etc/apt/apt.conf.d/00default

ENV DEBIAN_FRONTEND=noninteractive

ENV USER docker

RUN apt-get update && apt-get -f upgrade -y

RUN apt-get install -y -t xenial gcc-mingw-w64-i686 g++-mingw-w64-i686 binutils-mingw-w64-i686

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
    libgmp3-dev/xenial \
    libmpfr-dev/xenial \
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

RUN cd /usr/share/nsis/Include; wget http://nsis.sourceforge.net/mediawiki/images/a/ad/EnvVarUpdate.7z; 7za e EnvVarUpdate.7z

CMD ["/bin/bash"]
