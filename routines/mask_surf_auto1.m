function[]=mask_surf_auto1(root,bounds,method,thresh)
if(nargin==0)
    txt1=['Usage: ' 'mask_surf_auto1 <root> <bounds> <method> <thresh>'];
    txt15=['       e.g. mask_surf_auto study2 0-92,30-200,30-170 all 50'];
    txt2=['       method is "all", "coating", "blur" or "normfilter"'];    
    disp(txt1);
    disp(txt15);
    disp(txt2);
    return;
end

%iman=strcat(root,'.img');
im4dfp=strcat(root,'.4dfp.img');
impts=strcat(root,'_pts.4dfp.img');
imgfc=strcat(root,'_gfc.4dfp.img');


%avw=avw_img_read(iman);
%I0=avw.img;
avw=avw_img_read(im4dfp);
I3=avw.img;
I0=I3;
pixdim=double(avw.hdr.dime.pixdim(2:4));
avw=avw_img_read(impts);
I2=avw.img;

if exist(imgfc,'file')
    avw=avw_img_read(imgfc);
    I1=avw.img;
else
    I1=I3;
end

if(sum(size(I0)~=size(I1))>0 || sum(size(I0)~=size(I2))>0)
    display 'ANALYZE AND 4DFP VOLUMES ARE NOT ALIGNED';
    return;
end;
if (isempty(thresh) || thresh == -1)
    thresh=select_threshold(I1);
end
%[x0 x1 x2 x3 d]=ROI_coord(I2);
[x0,xmin,xmax,d]=ROI_coord(I2);
b=(xmin==xmax);
c=(isnan(x0)+isnan(xmin)+isnan(xmax));

if(sum(b)>0 || sum(c)>0)
    display 'RESULTING ROI IS TOO SMALL FOR DEFACING';
    return;
end;
%original image
V0=I3(xmin(1):xmax(1),xmin(2):xmax(2),xmin(3):xmax(3));
%gfc image
V1=I1(xmin(1):xmax(1),xmin(2):xmax(2),xmin(3):xmax(3));
if(d(1)>0) inv=0; else inv=1; end;
if(d(2)==1) ver='x';
elseif(d(2)==2) ver='y';
else ver='z';
end;
[Rb Rc Rnf]=mask_surf(V0,V1,pixdim,root,ver,thresh,inv,'large',method);
if (~isempty(Rb))
    Vb=I3;
    Vb(xmin(1):xmax(1),xmin(2):xmax(2),xmin(3):xmax(3))=Rb;
    avw.img=Vb;
    save_vol(uint16(Vb),avw,[root '_full_blur']);
end;
if (~isempty(Rc))
    Vc=I3;
    Vc(xmin(1):xmax(1),xmin(2):xmax(2),xmin(3):xmax(3))=Rc;
    avw.img=Vc;
    save_vol(uint16(Vc),avw,[root '_full_coating']);
end;
if (~isempty(Rnf))
    Vnf=I3;
    Vnf(xmin(1):xmax(1),xmin(2):xmax(2),xmin(3):xmax(3))=Rnf;
    avw.img=Vnf;
    save_vol(uint16(Vnf),avw,[root '_full_nf']);
end;


function[x0,xmin,xmax,d]=ROI_coord(I2)
Ip0=(I2==1);
Ip1=(I2==2);
Ip2=(I2==3);
Ip3=(I2==4);
[x00 x00]=getROI2D(Ip0);
[x10 x11]=getROI2D(Ip1);
[x20 x21]=getROI2D(Ip2);
[x30 x31]=getROI2D(Ip3);
%v1=x1-x0; %v1=v1/norm(v1,'fro');
v20=x11-x00;
v21=x10-x00;
v2=v21;
if(norm(v20,'fro')>norm(v21,'fro')) v2=v20; end;
v2=v2/norm(v2,'fro');
%v3=x3-x0; %v3=v3/norm(v3,'fro');
e1=[1 0 0];
e2=[0 1 0];
e3=[0 0 1];
d=[dot(v2,e1) dot(v2,e2) dot(v2,e3)];
x0=x00;
xmin=min([x10; x11; x20; x21; x30; x31]);
xmax=max([x10; x11; x20; x21; x30; x31]);
[val j]=max(abs(d));
val=d(j);
d=[val j];

function[mn, mx]=getROI2D(V)
sz=size(V);
xmin=inf;
ymin=inf;
zmin=inf;
xmax=-inf;
ymax=-inf;
zmax=-inf;
for z=1:sz(3)
    [row,col]=find(V(:,:,z));
    if (any(row))
        xmin=min(xmin,min(row));
        ymin=min(ymin,min(col));
        zmin=min(zmin,z);
        xmax=max(xmax,max(row));
        ymax=max(ymax,max(col));
        zmax=max(zmax,z);
    end;    
end;
mn=[xmin ymin zmin]; 
mx=[xmax ymax zmax];

