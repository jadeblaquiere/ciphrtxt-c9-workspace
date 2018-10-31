#!/bin/env sh
# Copyright (c) 2016, Joseph deBlaquiere <jadeblaquiere@yahoo.com>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# * Neither the name of ciphrtxt nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# setup.sh from ctclient

case "$OSTYPE" in
  linux*)
    LINUX_FLAVOR=`cat /etc/issue | cut -d " " -f 1 | head -1`
    if [ "$LINUX_FLAVOR" = "Ubuntu" ]
    then
        echo "Configuring build for Ubuntu"
        sudo apt-get update
        sudo apt-get -y install check
        sudo apt-get -y install python3-pip 
        # the following are needed for building examples (core library only depends on GMP)
        #####
        # alternatively git clone git@gitlab.com:gnutls/libtasn1.git
        sudo apt-get -y install libtasn1-6-dev libtasn1-bin
        # alternatively brew install popt
        sudo apt-get -y install libpopt-dev
        # alternatively https://github.com/transmission/libb64.git
        sudo apt-get -y install libb64-dev
    else
        echo "Unimplemented Linux Variant"
        exit 1
    fi
    ;;
  darwin*)
    echo "Configuring build for Mac OSX"
    brew update
    brew install check
    brew install libtasn1
    brew install popt
    brew install python3
    brew upgrade python3
    mkdir libb64-build
    cd libb64-build
    git clone https://github.com/transmission/libb64.git
    cd libb64
    make clean
    make
    sudo mkdir -p -m 755 /usr/local/include/b64
    sudo install -m 644 -o root -g admin include/b64/cdecode.h /usr/local/include/b64/cdecode.h
    sudo install -m 644 -o root -g admin include/b64/cencode.h /usr/local/include/b64/cencode.h
    sudo install -m 644 -o root -g admin include/b64/decode.h /usr/local/include/b64/decode.h
    sudo install -m 644 -o root -g admin include/b64/encode.h /usr/local/include/b64/encode.h
    sudo install -m 644 -o root -g admin src/libb64.a /usr/local/lib/libb64.a
    cd ../..
    ;;
  *)
    echo "Unknown OSTYPE = $OSTYPE"
    exit 1
    ;;
esac

# need to build libsodium from source - expect v1.0.16
# alternatively https://github.com/jedisct1/libsodium.git
mkdir sodium-build
cd sodium-build
wget http://archive.ubuntu.com/ubuntu/pool/main/libs/libsodium/libsodium_1.0.16.orig.tar.gz
tar xvf libsodium_1.0.16.orig.tar.gz
cd libsodium-1.0.16
autoreconf --install
case "$OSTYPE" in
  linux*)
    ./configure --prefix=/usr
    ;;
  darwin*)
    ./configure
    ;;
esac
make
sudo make install
cd ../..
#####

git clone https://github.com/jadeblaquiere/ecclib.git
cd ecclib
autoreconf --install
case "$OSTYPE" in
  linux*)
    ./configure --prefix=/usr
    ;;
  darwin*)
    ./configure
    ;;
esac
make
sudo make install
cd ..

git clone https://github.com/jadeblaquiere/pbc.git
cd pbc
autoreconf --install
case "$OSTYPE" in
  linux*)
    ./configure --prefix=/usr --enable-safe-clean
    ;;
  darwin*)
    ./configure --enable-safe-clean
    ;;
esac
make
sudo make install
cd ..

git clone https://github.com/jadeblaquiere/fspke.git
cd fspke
autoreconf --install
case "$OSTYPE" in
  linux*)
    ./configure --prefix=/usr
    ;;
  darwin*)
    ./configure
    ;;
esac
make
sudo make install
cd ..

sudo add-apt-repository -y ppa:ondrej/nginx-mainline
sudo apt-get update
sudo apt-get install -y openssl libssl1.1 libssl-dev

git clone https://github.com/jadeblaquiere/libdill.git
cd libdill
autoreconf --install
case "$OSTYPE" in
  linux*)
    ./configure --prefix=/usr --enable-tls
    ;;
  darwin*)
    ./configure --enable-tls
    ;;
esac
make
sudo make install
cd ..

git clone https://github.com/jadeblaquiere/ctclient.git
cd ctclient
autoreconf --install
case "$OSTYPE" in
  linux*)
    ./configure --prefix=/usr
    ;;
  darwin*)
    ./configure
    ;;
esac
make
sudo make install
cd ..

# need golang 1.10 for cttd
sudo add-apt-repository -y ppa:jonathonf/golang
sudo apt-get update
sudo apt-get install -y golang-1.10

export PATH=~/workspace/bin:$PATH
export PATH=/usr/lib/go-1.10/bin:$PATH
echo "export PATH=~/workspace/bin:\$PATH" >> ~/.profile
echo "export PATH=/usr/lib/go-1.10/bin:\$PATH" >> ~/.profile
export GOROOT=/usr/lib/go-1.10
echo "export GOROOT=/usr/lib/go-1.10" >> ~/.profile

go get github.com/jadeblaquiere/ctclient/ctgo
go get github.com/jadeblaquiere/cttd

# need protoc v3 and protoc-gen-go for cttwallet
sudo add-apt-repository -y ppa:maarten-fonville/protobuf
sudo apt-get update

sudo apt-get install -y protobuf-compiler
go get github.com/golang/protobuf/protoc-gen-go

# regenerate protobuf generated interface
pushd src/github.com/jadeblaquiere
git clone https://github.com/jadeblaquiere/cttwallet.git
cd cttwallet/rpc
sh regen.sh
popd

go get github.com/jadeblaquiere/cttwallet
