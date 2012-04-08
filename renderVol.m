% Comments: mmilch@wustl.edu
% Copyright (c) 2012, Neuroinformatics Research Group
% All rights reserved.
% Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
% Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
% Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
% Neither the name of the Washington University in St. Louis nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


%avw=avw_img_read('/data/cninds01/data2/WORK/misha/src/RAW');
%avw=avw_img_read('/data/cninds01/data2/WORK/misha/src/BRAIN001');
avw=avw_img_read('/data/cninds01/data2/WORK/misha/src/clinicmr_msk');
A=avw.img;
%A=blur3(A,2);
[m,n,p]=size(A);
%fv=isosurface(A,X,Y,Z,200.0);
fv=isosurface(A,40.0);
p=patch(fv);
%p=patch(isosurface(A,200.0));
[faces vertex]=reducepatch(p,10000);
isonormals(A,p);
set(p,'FaceColor',[1 0.78 0.60],'EdgeColor','none');
daspect([1 1 1])
view([-1 0.7 0.5]); axis tight
camlight
