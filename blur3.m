% Comments: mmilch@wustl.edu
% Copyright (c) 2012, Neuroinformatics Research Group
% All rights reserved.
% Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
% Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
% Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
% Neither the name of the Washington University in St. Louis nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

function [B] = blur3(A,k_size)
if(rem(k_size,2)~=0)
k_size=k_size-1;
end;
sz=size(A);
%szx=sz(1)+2*k_size;
%szy=sz(2)+2*k_size;
%szz=sz(3)+2*k_size;
%B1=zeros(szx,szy,szz);
%B1(k_size+1:szx-k_size,k_size+1:szy-k_size,k_size+1:szz-k_size)=A;

filter=(1.0/(k_size*k_size*k_size))*double(ones(k_size,k_size,k_size));
fA=fftn(A);
ff=fftn(filter,size(A));
%B=sh(ifftn(fA.*ff),k_size/2);
B=ifftn(fA.*ff);
B=sh(B,k_size/2);

%B=zeros(sz(1),sz(2),sz(3));
%B=B1(k_size+1:szx-k_size,k_size+1:szy-k_size,k_size+1:szz-k_size);
return;
function [C]=sh(B,s)
sz=size(B);
C=double(zeros(sz));
for z=1:sz(3)
for y=1:sz(2)
for x=1:sz(1)
C(x,y,z)=B(mod(x+s,sz(1))+1,mod(y+s,sz(2))+1,mod(z+s,sz(3))+1);
end;
end;
end;
return;
