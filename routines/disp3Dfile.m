function[] = disp3Dfile(file,angles)
avw=avw_img_read(file);
V=avw.img;
pixdim=double(avw.hdr.dime.pixdim(2:4));
t=select_threshold(V);
figure;
Z=dispvol3D(V,pixdim,t,angles);
imshow(Z,[0,1]);