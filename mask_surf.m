% Comments: mmilch@wustl.edu
% Copyright (c) 2012, Washington University in Saint Louis
% All rights reserved.
% Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
% Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
% Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
% Neither the name of the Washington University in Saint Louis nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

% mask surface of the volume.
%
% [parameter] V: input volume
% [parameter] pixdim: vector with pixel sizes along x,y,z
% [parameter] root: root filename for intermediate saves
% [parameter] vertical: can be 'x', 'y', or 'z'. denotes the anterior-posterior direction.
% [parameter] bg_thresh: integer threshold between object and background for generating
% isosurface.
% [parameter] inverse: direction of casting rays to generate
% surface is from low to high coordinate (default is from high to low
% coordinate of vertical axis).
% [parameter] grid_step: =1, default. <1, decrease % grid step. >1,
% increase % grid step.
% [parameter] method: 'blur','normfliter','coat','all'

function[Rb Rc Rnf] = mask_surf(Vorig,Vgfc, pixdim, root, vertical, bg_thresh, inverse, grid_step, method, opt)

disp (['[mask_surf] bg_thresh: ' num2str(bg_thresh)]);
%read original volume.
%pause on
%avw=avw_img_read(root);
%V=avw.img;
[V newdim]=reorient(Vorig,vertical,1,inverse,pixdim);
[Vgfc tmp]=reorient(Vgfc,vertical,1,inverse,pixdim);

%get binary mask
Mask=(Vgfc>=bg_thresh);

%these are the default settings for 1 mm anisotropic voxel.
[thickness, step] = calc_step(newdim, grid_step);
disp(['thickness: ' num2str(thickness) ', step: ' num2str(step)]);

nm=max(1,round(4/norm(pixdim)));
disp(['nm: ' num2str(nm)]);
%morphologically close.
se=strel('disk',nm);
Mask=imopen(Mask,se);
Mask=imclose(Mask,se);

if(opt>0)
saveVol(Mask,[root '_mask']);
end;
%sz=size(V);

%calculate the volume mesh.
[faces, vertices, faces_b, vertices_b, faces_t,vertices_t,...
lower_surf,upper_surf,orig_surf]=RectangularMesh(Mask,thickness,step,0.5,1.0,nm,opt);

%save mesh volume.
if (opt>1)
layer=fill_layer(size(Mask), step, lower_surf,upper_surf,orig_surf);
saveVol(layer,[root '_orig_layer']);
end;

%display generated mesh.
%test_rect_mesh(faces, vertices, faces_b, vertices_b, faces_t,vertices_t);

%pause

tic
Rb=[];
Rc=[];
Rnf=[];
Vmask=[];

if(strcmp(method,'coating')~=0 || strcmp(method,'all')~=0)
Vmask=maskVol(V,lower_surf,orig_surf,upper_surf,step);
if(opt>1)
saveVol(Vmask,[root '_coatingMask']);
end;
stats=get_seg_stats(V,Vmask,[1 2]);
m=stats(1,1);
Vrev=uint16(m*Vmask+(1-Vmask).*V);
if(opt>0)
saveVol(Vrev,[root '_coating']);
end;
%return to original orientation.
Vrev=reorient(Vrev,vertical,-1,inverse,newdim);
Rc=Vrev;
end;
if(strcmp(method, 'blur')~=0 || strcmp(method,'all')~=0)
Vmask=maskVol(V,lower_surf,orig_surf,upper_surf,step);
if(opt>1)
saveVol(Vmask,[root '_blurMask']);
end;
Vbl=blur3(V,2*thickness);
Vrev=uint16(Vmask.*Vbl+(1-Vmask).*V);
if(opt>0)
saveVol(Vrev,[root '_blur']);
end;
%return to the original orientation.
Vrev=reorient(Vrev,vertical,-1,inverse,newdim);
Rb=Vrev;
end;
if(strcmp(method, 'normfilter')~=0 || strcmp(method,'all')~=0)
%project forward.
Vres=projectVol(V,V,orig_surf,lower_surf,upper_surf,thickness,step,'direct',opt);
if(opt>0)
saveVol(Vres,[root '_face']);
end;
%mask volume.
V1=blur3_thin(Vres,thickness);
if(opt>0)
saveVol(uint16(V1),[root '_face_blur']);
end;
%project backward.
[Vrev,Vmask]=projectVol(V1,V,orig_surf,lower_surf,upper_surf,thickness,step,'reverse',opt);
%return to original orientation.
if(opt>0)
saveVol(uint16(Vrev),[root '_normfilter']);
end;
Vrev=reorient(Vrev,vertical,-1,inverse,newdim);
% saveVol(uint16(Vrev),[root '_normfilter']);
Rnf=Vrev;
end;
if(isempty(Vmask)) display ('invalid method requested, exiting'); exit; end;
%Vmask=reorient(Vmask,vertical,-1,inverse);
if(opt>0)
saveVol(Vmask,[root '_layer']);
end;
toc

% this function is obsolete.
% use Mask=(V>=bg_thresh) instead.
function[Mask]=get_mask(V,bg_thresh)
Mask=zeros(size(V));
sz=size(V);
for z=1:sz(3)
for y=1:sz(2)
for x=1:sz(1)
if(V(x,y,z)>=bg_thresh)
Mask(x,y,z)=1;
end;
end;
end;
end;
function[thickness,step]=calc_step(pixdim,grid_step)
%factor=grid_step;
%pd=pixdim;
%if(grid_step<0.8)
% pd=ones(3)*max(pd(:));
%elseif(grid_step>1.2)
% pd=ones(3,1)*min(pd(:));
%end
%if(pd(1)<=0 || pd(2)<=0 || pd(3)<=0) return; end;
%diag=sqrt(sum(pd.*pd));
%step=double(max(4,round((factor*10*sqrt(3))/diag)));
thickness=round(grid_step*5.0/pixdim(3));
step=round(grid_step*24.0/(pixdim(1)+pixdim(2)));
%thickness=double(max(2,round((factor*6*sqrt(3))/diag)));

function[res newdim]=reorient(V, vertical, dir, inverse, pixdim)
if(strcmp(vertical,'x'))
transp=[3 2 1];
elseif(strcmp(vertical,'y'))
transp=[1 3 2];
else
transp=[1 2 3];
end;
newdim=[pixdim(transp(1)) pixdim(transp(2)) pixdim(transp(3))];


if(dir==1) %forward
res=redim(V,transp);
if(inverse==1)
res=reflect(res,3);
end;
else %back
res=redim(V,transp);
if(inverse==1)
if(strcmp(vertical,'x'))
res=reflect(res,1);
elseif(strcmp(vertical,'y'))
res=reflect(res,2);
else
res=reflect(res,3);
end
end
end;
