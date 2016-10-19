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

# THE FOLLOWING VALUES SHOULD BE CHANGED FOR YOUR ENVIRONMENT!

MININGPUBKEY="CKxrrgp9r62FMwVZUGd2x3dnnhLzpYzQZk"
RPCUSERNAME="rpcuser"
RPCPASSWORD="rpcpass"
NAKPRIV="ca92102f1fde262153ceeeaff7f5e4e98077dfb2adfa829e69581d0115acb83c"


( cd ~/workspace/msgstore ; python3 ./app.py --rpcuser=$RPCUSERNAME --rpcpass=$RPCPASSWORD --exthost=$C9_HOSTNAME --extport=80 --listenport=$PORT --nakpriv=$NAKPRIV & )
sleep 5
~/workspace/bin/ctcd --nodnsseed --addpeer indigo.bounceme.net --txindex --rpcuser=$RPCUSERNAME --rpcpass=$RPCPASSWORD --headercacheport=$PORT --miningaddr $MININGPUBKEY &
wait
