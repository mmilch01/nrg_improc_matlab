function[]=mask_surf_auto_4dfp(root,exmask,method,thresh,grain,optimization)
if(nargin==0)
    txt1=['Usage: ' 'mask_surf_auto <Analyze root> <method> <optimization>'];
    txt15=['       e.g. mask_surf_auto study2 all'];
    txt2=['       method is "all", "coating", "blur" or "normfilter"'];    
    txt3=['       optimization: 0 for highest speed, less output; 1 - intermediate; 2 - slowest, most output.'];
    disp(txt1);
    disp(txt15);
    disp(txt2);
    return;
end
disp (['mask_surf_auto(' root ', ' method ', ' num2str(thresh) ', ' num2str(grain) ', ' num2str(optimization) ');']);
%return
%iman=strcat(root,'.img');
im=strcat(root,'.4dfp.img');
impts=strcat(root,'_pts.4dfp.img');
imgfc=strcat(root,'_gfc.4dfp.img');
imgexm=strcat(exmask,'.4dfp.img');


fcoord=strcat(root,'_bounds.txt');

%avw=avw_img_read(iman);
%I0=avw.img;


avw=avw_img_read(im);
I3=avw.img;
I0=I3;
pixdim=double(avw.hdr.dime.pixdim(2:4));
disp(['pixdim: ' num2str(pixdim)]);

snapshot(I0, [root '_orig']);
if exist (impts,'file')
    avw=avw_img_read(impts);
    I2=avw.img;
end
if exist (imgexm,'file')
    avw=avw_img_read(imgexm);
    ImExm=avw.img;
end


if exist (fcoord,'file')
    [axis inv x0 x1 y0 y1 z0 z1] = textread(fcoord,'%d %d %d %d %d %d %d %d',1);
end
dims=size(I0);
if(sum(size(I0)~=size(I2))>0)
    display 'ANALYZE AND 4DFP VOLUMES ARE NOT ALIGNED';
    disp 'size(I0):'
    size(I0) 
%    disp 'size(I1):'
%    size(I1)
    disp 'size(I2):'
    size(I2)
    return;
end;

if ~exist ('optimization','var')
    opt=0;  %highest speed
else 
    opt=optimization;
end; 

if ~exist('thresh','var')
    thresh=-1;%select_threshold(I1);
%elseif (thresh == -1)
%    thresh=select_threshold(I1);        
end
%[x0 x1 x2 x3 d]=ROI_coord(I2);
[x0,xmin,xmax,d]=ROI_coord(I2);
b=(xmin==xmax);
c=(isnan(x0)+isnan(xmin)+isnan(xmax));

if(sum(b)>0 || sum(c)>0)
    display 'RESULTING ROI IS TOO SMALL FOR DEFACING';
    return;
end;
%xmin=[39 1 147];
%xmax=[195 110 320];
%thresh=20;

if(d(1)>0) inv=0; else inv=1; end;
if(d(2)==1)
    ver='x';
    if (inv==1) xmin(1)=1; else xmax(1)=dims(1); end;
elseif(d(2)==2) 
    ver='y';
    if (inv==1) xmin(2)=1; else xmax(2)=dims(2); end;
else
    ver='z';
    if (inv==1) xmin(3)=1; else xmax(3)=dims(3); end;
end;

%increase the ROI to compensate for partial segment effect.
nm=round(6*pixdim);
xmin=max(xmin-nm,ones(1,3));
xmax=min(xmax+nm,dims);

disp(['ROI: min ' num2str(xmin) '; max ' num2str(xmax)]);

%original image
V0=I3(xmin(1):xmax(1),xmin(2):xmax(2),xmin(3):xmax(3));
%gfc image
V1=V0;
%V1=I1(xmin(1):xmax(1),xmin(2):xmax(2),xmin(3):xmax(3));

if exist ('ImExm','var')
    Vexm=ImExm;
else    
    Vexm=I3*0;
end;
Vexm=Vexm(xmin(1):xmax(1),xmin(2):xmax(2),xmin(3):xmax(3));

if ~exist('thresh','var')
    thresh=select_threshold(V1);
elseif (thresh == -1)
    thresh=select_threshold(V1);
end

disp(['Threshold: ' num2str(thresh)]);
snapshot3D(I0,pixdim,ver,inv,[root '_orig_surf']);

if ~exist('grain','var')
    grain=1.0;
end
disp(['Grid size coefficient: ' num2str(grain)]);

[Rb Rc Rnf]=mask_surf(V0,V1,Vexm,pixdim,root,ver,thresh,inv,grain,method,opt);
if (~isempty(Rb))
    Vb=I3;
    Vb(xmin(1):xmax(1),xmin(2):xmax(2),xmin(3):xmax(3))=Rb;
    avw.img=Vb;
    save_vol(uint16(Vb),avw,[root '_full_blur']);
%    clear avw I0 ImExm Rnf V0 V1 Vexm Rb Rc Rnf
    snapshot(Vb(:,:,:,1),[root '_blur.png']);
    snapshot3D(Vb(:,:,:,1),pixdim,ver,inv,[root '_blur_surf']);    
end;
if (~isempty(Rc))
    Vc=I3;
    Vc(xmin(1):xmax(1),xmin(2):xmax(2),xmin(3):xmax(3))=Rc;
    avw.img=Vc;
    save_vol(uint16(Vc),avw,[root '_full_coating']);
%    clear avw I0 ImExm Rnf V0 V1 Vexm Rc Rb Rnf
    snapshot(Vc(:,:,:,1),[root '_coating.png']);    
    snapshot3D(Vc(:,:,:,1),pixdim,ver,inv,[root '_coating_surf']);    
end;
if (~isempty(Rnf))
    Vnf=I3;
    Vnf(xmin(1):xmax(1),xmin(2):xmax(2),xmin(3):xmax(3))=Rnf;
    avw.img=Vnf;
    save_vol(uint16(Vnf),avw,[root '_full_normfilter']);
%    clear avw I0 ImExm Rnf V0 V1 Vexm Rb Rc
    snapshot(Vnf(:,:,:,1),[root '_normfilter']);
    snapshot3D(Vnf(:,:,:,1),pixdim,ver,inv,[root '_normfilter_surf']);
end;


function[x0,xmin,xmax,d]=ROI_coord(I2)
Ip0=(I2==1);
Ip1=(I2==2);
Ip2=(I2==3);
Ip3=(I2==4);
[~, x00]=getROI2D(Ip0);
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
[~, j]=max(abs(d));
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

function[] = snapshot(V,name)
%f=figure('Visible','off','OuterPosition',[0,0,1024,768]);
f=figure('Visible','off','OuterPosition',[0,0,1024,768]);
dispvol(V,[],12);
%print('-dpng', name);
sv(f,name);
close(f);

function[] = snapshot3D(V,pixdim,ver,inv,name)
%memory;
[Vr newdim]=reorient(V,ver,1,inv,pixdim);
thresh=select_threshold(V);
%f=figure('Visible','off','OuterPosition',[0,0,1024,768]);
%f=figure;
I=dispvol3D(Vr,newdim,thresh);
imwrite(I,[name '.png'],'png');
%sv(f,name);
%print('-dpng',name);
%close(f);

function sv(f, name)
%im=frame2im(getframe(f));
%imwrite(im,[name '.png'],'png');
%export_fig(name);
%opengl software;
saveas(f,name,'png');
%set(gcf,'Renderer','zbuffer');
%print('-dpng',name);
%hardcopy(gcf, '-Dopengl', '-r300');

function[res newdim]=reorient(V, vertical, dir, inverse, pixdim)
is4d=(size(V,4)>1);
if(strcmp(vertical,'x'))
   transp=[3 2 1];
elseif(strcmp(vertical,'y'))
   transp=[1 3 2];
else 
   transp=[1 2 3];
end;
newdim=[pixdim(transp(1)) pixdim(transp(2)) pixdim(transp(3))];
if (is4d)
    transp=[transp 4];
end;

if(dir==1) %forward
    res=permute(V,transp);
    if(inverse==1)
        res=reflect(res,3);
    end;
else %back
    res=permute(V,transp);
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
