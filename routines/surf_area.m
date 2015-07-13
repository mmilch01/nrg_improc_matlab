function[surf vol compactness] = surf_area(image,outfile)

avw=avw_img_read(image);
vd=avw.hdr.dime.pixdim(2:4);

vox_sz=vd(1)*vd(2)*vd(3);
vol=sum(avw.img(:)>0)*vox_sz;
%this line is for the batch offscreen figure saving.
%opengl software;

%subplot(1,2,1);
%Ds=smooth3(resample3D(V,pixdim,1));

%dsz=0.8;
%Ds=smooth3(resample3D(V,pixdim,dsz));
[f,v]=isosurface(smooth3(avw.img),0.5);

%render the volume.
%Z=render(iso.vertices,iso.faces,[180 -80 0]);
%Z=render(iso.vertices,iso.faces,[90 -45 -90]);
%Z=render(iso.vertices,iso.faces,[135 180 0]);
surf=0;
for i=1:size(f,1)
    v1=(v(f(i,2),:)-v(f(i,1),:)).*vd;
    v2=(v(f(i,3),:)-v(f(i,1),:)).*vd;
    s1=abs(0.5*dot(v1,v2));
    surf=surf+s1;
end
compactness=surf^1.5/vol;
%imshow(Z,[0,1]);

if exist('outfile','var')
    fid=fopen(outfile,'w');
    fprintf(fid, 'surf=%f\ncompactness=%f\n',surf,compactness);
    fclose(fid);
end

return;
