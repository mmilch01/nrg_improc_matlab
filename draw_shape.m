% Comments: mmilch@wustl.edu
% Copyright (c) 2012, Neuroinformatics Research Group
% All rights reserved.
% Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
% Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
% Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
% Neither the name of the Washington University in St. Louis nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


function[]=draw_shape(pts)
type='tetr';
%if(type=='tetr')
vertices=pts;
faces=zeros(3,5);
faces(:,1)=[1,2,3];
faces(:,2)=[1,2,4];
faces(:,3)=[2,3,4];
faces(:,4)=[1,3,4];
faces(:,5)=[1,1,5];
faces=faces';
%else 
% return;
%end;
face_color=[0 0 0];
edge_color=[0 0 0];
line_style='-';
alpha=0;

patch('vertices',vertices,'faces',faces,...
'facecolor',face_color,...
'edgecolor',edge_color,...
'CData',[NaN NaN NaN],...
'LineStyle',line_style,...
'FaceAlpha',alpha,...
'FaceLighting','flat');
%colormap rgb;%gray(256);
%lighting flat;
%camproj('perspective');
axis square;
axis tight;
axis off;
daspect([1 1 1]);
view([-1 0.7 0.5]);
