path='/data/cninds01/data2/WORK/misha/surf_mask/clinicmr_subvol/'
%path='D:/data/';
%first, read volume mask.
%avw=avw_img_read([path 'clinicmr_msk']);
%basename='cadaver';
%maskname='cadaver_mask';
basename='clinicmr';
maskname=[];%'clinicmr_subvol';
imtype='MR';

avw=avw_img_read([path basename]);
if(~isempty(maskname))
    avw_mask=avw_img_read([path maskname]);
else
    avw_mask=avw;
end;

%Mask=redim(avw.img,[3 1 2]);
%V=reflect(V,1);
thickness=7;
step=10;
%imshow(Mask(:,:,90),[0 1]);

if(strcmp(imtype,'CT')~=0) 
    thresh=1;
    V=redim(avw.img,[3 1 2]);
    Mask=redim(avw_mask.img,[3 1 2]);
elseif(strcmp(imtype,'MR')~=0)
    thresh=25;
    V=redim(avw.img,[3 1 2]);
    V=reflect(V,1);
    Mask=V;
else thresh=25;
end;

[faces, vertices, faces_b, vertices_b, faces_t,vertices_t,...
    lower_surf,upper_surf,orig_surf]=RectangularMesh(Mask,thickness,step,thresh);

%display generated mesh.
test_rect_mesh(faces, vertices, faces_b, vertices_b, faces_t,vertices_t);

%save generated mesh.
mat2dxf([path basename 'mesh_face'],vertices',faces');
mat2dxf([path basename 'mesh_t'],vertices_t',faces_t');
mat2dxf([path basename 'mesh_b'],vertices_b',faces_b');

%simplified masking
Vbl=blur3(V,2*thickness);
save_vol(uint16(Vbl),avw,[path basename '_Vbl']);

Vmask=maskVol(V,lower_surf,orig_surf,upper_surf,step);
save_vol(uint16(255*Vmask),avw,[path basename '_Vmask']);
Vres=Vbl.*Vmask+(1-Vmask).*V;
save_vol(uint16(Vres),avw,[path basename '_Vres']);

%end of simplified masking.


Vres=projectVol(V,V,orig_surf,lower_surf,upper_surf,thickness,step,'direct');
save_vol(Vres,avw,[path basename '_face']);

%V1=Vres*0+max(max(max(Vres)));
V1=blur3_thin(Vres,thickness);
%V1=Vres;

save_vol(V1,avw,[path basename '_face_blur']);
%V1=Vres;

Vrev=projectVol(V1,V,orig_surf,lower_surf,upper_surf,thickness,step,'reverse');
save_vol(uint16(Vrev),avw,[path basename '_defaced']);

%V1res=reflect(Vres,3);
%V1res=redim(V1res,[2,3,1]);