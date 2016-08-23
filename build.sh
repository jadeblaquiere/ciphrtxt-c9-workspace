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

#install ctcd
go get -u github.com/Masterminds/glide
(cd src/github.com/ ; mkdir jadeblaquiere )
go get github.com/jadeblaquiere/ctcd
(cd src/github.com/jadeblaquiere/ctcd ; ~/workspace/bin/glide install )
(cd src/github.com/jadeblaquiere/ctcd ; go install . ./cmd/... )

#install msgstore
git clone https://github.com/jadeblaquiere/msgstore.git
sudo apt-get update
sudo apt-get install -y libleveldb1 libleveldb-dev
sudo pip3 install tornado requests requests_futures plyvel pycrypto
sudo pip3 install git+https://github.com/jadeblaquiere/ecpy.git
sudo pip3 install git+https://github.com/jadeblaquiere/python-ctcoinlib.git
(cd msgstore ; mkdir messages)
(cd msgstore ; mkdir recv)
