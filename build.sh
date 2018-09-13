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

# need golang 1.10 for cttd
sudo add-apt-repository ppa:jonathonf/golang
sudo apt-get update
sudo apt-get install golang-1.10

export PATH=~/workspace/bin:$PATH
export PATH=/usr/lib/go-1.10/bin:$PATH
echo "export PATH=~/workspace/bin:\$PATH" >> ~/.profile
echo "export PATH=/usr/lib/go-1.10/bin:\$PATH" >> ~/.profile
export GOROOT=/usr/lib/go-1.10
echo "export GOROOT=/usr/lib/go-1.10" >> ~/.profile

go get github.com/jadeblaquiere/cttd

# need protoc v3 and protoc-gen-go for cttwallet
sudo add-apt-repository ppa:maarten-fonville/protobuf
sudo apt-get update

sudo apt-get install protobuf-compiler
go get github.com/golang/protobuf/protoc-gen-go

# regenerate protobuf generated interface
pushd src/github.com/jadeblaquiere
git clone https://github.com/jadeblaquiere/cttwallet.git
cd cttwallet/rpc
sh regen.sh
popd

go get github.com/jadeblaquiere/cttwallet
