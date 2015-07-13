% make a gif snapshot of an Analyze volume.
%
function [] = snap2D (infile, outfile)
avw=avw_img_read(infile,0);
V=avw.img;
%pixdim=double(avw.hdr.dime.pixdim(2:4));
f=figure('Visible','off','OuterPosition',[0,0,1280,900]);
Vs=permute(V(:,:,:,1),[2 1 3]);
%Vs=V;
Vs=flipdim(Vs,1);
dispvol(Vs,[],12);
saveas(f,outfile,'png');
close(f);
