#!/bin/bash
# Copyright (c) 2011-2019, ARM Limited
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Arm nor the names of its contributors may be used
#       to endorse or promote products derived from this software without
#       specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

set -e
set -x
set -u
set -o pipefail

umask 022

exec < /dev/null

script_path=`cd $(dirname $0) && pwd -P`
. $script_path/build-common.sh

# This file contains the sequence of commands used to install all the sources
# needed to build the GNU Tools Arm Embedded toolchain.
usage ()
{
cat<<EOF
Usage: $0 [--skip_steps=...]

This script will install sources needed to build the GNU Tools Arm Embedded toolchain.

OPTIONS:
  --skip_steps=STEPS    specify which build steps you want to skip.  Concatenate
                        them with comma for skipping more than one steps.
                        Available step is: mingw32.

EOF
}

if [ $# -gt 2 ] ; then
    usage
fi

skip_steps=
skip_mingw32=no

for ac_arg; do
    case $ac_arg in
        --skip_steps=*)
            skip_steps=`echo $ac_arg | sed -e "s/--skip_steps=//g" -e "s/,/ /g"`
            ;;
        *)
            usage
	    exit 1
            ;;
    esac
done

if [ "x$skip_steps" != "x" ]; then
        for ss in $skip_steps; do
                case $ss in
                    mingw32)
                      skip_mingw32=yes
                      ;;
                    *)
                      echo "Unknown build steps: $ss" 1>&2
                      usage
                      exit 1
                      ;;
                esac
        done
fi

extract_source ()
{
    archive=$*
    case $archive in
        *.tar.*)
            tar xf $archive;;
        *.msi)
            mkdir -p ${archive%.msi}
	    7za x -y -o${archive%.msi} $archive;;
        *.7z)
            mkdir -p ${archive%.7z}
            7z x -y -o${archive%.7z} $archive;;
    esac
}

# this function parse ini style file to find source info
parse_ini ()
{
    section=$1
    item=$2
    file=./source.spc
    cat $file | sed -nE "/^\s*\[$section\]/,/^\s*\[.*\]/p" \
              | grep -E "^\s*$item=" \
              | sed "s/.*=//"
}

checkout_source ()
{
    prj=$1
    type=$(parse_ini $prj type)
    url=$(parse_ini $prj url)
    version=$(parse_ini $prj version)
    case $type in
    git)
        git clone $url $prj
        pushd $prj
        if [ "x$prj" = "xgcc" ]; then
            # GCC git repo needs to fetch vendor branch before checkout
            # ignore false return as this might not always apply
            ./contrib/gcc-git-customization.sh < /dev/null || true
            ./contrib/git-fetch-vendor.sh ARM || true
        fi
        git checkout $version
        popd
        ;;
    svn)
        svn co -q $url@$version $prj
        ;;
    *)
        error Do not know how to deal with $type
    esac
}

cd $SRCDIR
for prereq in $PREREQS; do
    eval [ -d \$$prereq ] && continue
    if [ -z "${WIN_PREREQS%%*${prereq}*}" -a $skip_mingw32 = yes ]; then
	continue
    fi
    eval prereq_pack="\$${prereq}_PACK"
    if [ ! -f $prereq_pack ]; then
        eval prereq_url="\$${prereq}_URL"
        $WGET $prereq_url
    fi
    extract_source $prereq_pack
done

for prj in $BINUTILS $GCC $NEWLIB $GDB $SAMPLES \
           $INSTALLATION $BUILD_MANUAL; do
    if [ ! -x $prj ] && [ ! -f $prj ]; then
        prj_pack=$prj.tar.bz2
        if [ -f $prj_pack ]; then
            # source package is available, just extract it
            extract_source $prj_pack
        else
            # source package is not available, checkout from source repo
            checkout_source $prj
        fi
    fi
    #double check if sources are ready
    if [ ! -x $prj ] && [ ! -f $prj ]; then
       error Cannot get $prj. Will not be able to build.
       exit 1
    fi
done
