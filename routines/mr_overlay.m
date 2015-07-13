% orig: original image
% over: overlay image
% slice: input slice.
% ncoef: normalization coefficient.

function mr_overlay(orig,over,out,slice,ncoef,range)

if ~exist('ncoef', 'var') || isempty(ncoef), ncoef = 1; end

orig_avw=avw_img_read(orig);
origv=orig_avw.img;
over_avw=avw_img_read(over);
overv=over_avw.img;

origv=int16(permute(origv,[2 1 3]));
%origv=flipdim(origv,1);
overv=permute(overv,[2 1 3]);
%overv=flipdim(overv,1);

o=origv(:,:,slice);
ov=overv(:,:,slice)/ncoef;

t0=prctile(ov(:),95);
t1=prctile(ov(:),1);
if ~exist('range', 'var')
    range=[t1 t0];
end

r=150;
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 200 150]/r);

%subplot (2,2,1);
f=figure('visible','off');
imshow(o,[],'InitialMag', 200);
statmask(ov,0,gray(256),range,'hidden');
print(gcf,'-dpng', sprintf('-r%d',r), 'im1.png');
close(f);
%colormap gray;
%freezeColors
%cbfreeze(colorbar);


%subplot (2,2,2);
f=figure('visible','off');
imshow(o,[],'InitialMag', 200);
statmask(ov,1,jet(256),range);
print(gcf,'-dpng', sprintf('-r%d',r), 'im2.png');
close(f);
%freezeColors
%cbfreeze(colorbar);

%subplot (2,2,3);
f=figure('visible','off');
imshow(o,[],'InitialMag', 200);
statmask(ov,.2,jet(256),range);
print(gcf,'-dpng', sprintf('-r%d',r), 'im3.png');
close(f);
%freezeColors
%cbfreeze(colorbar);

concatImageFiles2D('fileNames',{'im1.png','im2.png','im3.png'},'subVcols',3, ...
    'outFile', strcat(out,'.png'));
%im=imread('out.png');
%imshow(im);

