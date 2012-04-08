% Comments: mmilch@wustl.edu
% Copyright (c) 2012, Neuroinformatics Research Group
% All rights reserved.
% Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
% Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
% Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
% Neither the name of the Washington University in St. Louis nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


hold on;
for i=1:6
if(t(i).deg==0) continue;end;
ver=[t(i).origin;t(i).origin+t(i).v1;...
t(i).origin+t(i).v2;t(i).origin+t(i).v3;x];
draw_shape(ver);
end;


ver=[tetr.origin;tetr.origin+tetr.v1;tetr.origin+tetr.v2;tetr.origin+...
tetr.v3;x];
