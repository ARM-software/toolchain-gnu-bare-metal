ARG BASE_ARCH
FROM ${BASE_ARCH}ubuntu:14.04

RUN set -x \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
# Install base distro packages
    apt sudo time gawk make perl python-cheetah git scons ruby ruby-nokogiri \
    openssh-client libx11-dev \
    rsync debootstrap schroot subversion \
# Install GCC specific packages
    libgmp-dev libmpfr-dev libmpc-dev libisl-dev \
    autoconf autogen automake build-essential bison dejagnu flex gawk gettext \
    less libncurses5-dev libtool texinfo texlive tcl zlib1g-dev \
# Install documentation specific packages
    xsltproc dblatex latex-xcolor docbook-xsl-ns docbook-xsl-doc-html \
    docbook-xsl-doc-pdf doxygen graphviz libxml2-utils \
# Install pip's dependency: setuptools
    python python-dev python-distribute python-pip python-virtualenv \
# Install user packages
    vim emacs htop mc aptitude \
# Compression tools
    p7zip-full lbzip2 xz-utils \
# Install GCC 4.9
    software-properties-common python-software-properties \
    && add-apt-repository -y ppa:ubuntu-toolchain-r/test \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y gcc-4.9 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 50 \
    && apt-get install --no-install-recommends --no-install-suggests -y g++-4.9 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 50 \
# Update package information (must be issued before apt-file search command is issues) 
    && apt-file update \
# Cleanup to make image more compact
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Update shared lib cache /etc/ld.so.cache with ldconfig
RUN /sbin/ldconfig

# Enable support for XML style sheets used to build documentation for e.g. libstdc++v3
#RUN xmlcatalog  --noout --add rewriteSystem "http://ocbook.sourceforge.net/release/xsl-ns/current/" \
#    "file:///usr/share/xml/docbook/stylesheet/docbook-xsl-ns/" /etc/xml/catalog
