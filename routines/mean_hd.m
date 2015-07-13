function [mean_dist,hausd] = mean_hd(img1,img2,thresh,outfile)
avw1=avw_img_read(strcat(img1,'.img'),0);
avw2=avw_img_read(strcat(img2,'.img'),0);
A=avw1.img;
B=avw2.img;
%mask of A.
A1=(A>thresh);
%mask of B.
B1=(B>thresh);
[gAX,gAY,gAZ]=gradient(double(A1));
[gBX,gBY,gBZ]=gradient(double(B1));

%gA and gB are edge images of A and B.
gA=(sqrt(gAX.*gAX+gAY.*gAY+gAZ.*gAZ)>0.5);
gB=(sqrt(gBX.*gBX+gBY.*gBY+gBZ.*gBZ)>0.5);

%DA and DB are distance transforms of gA and gB.
DA=bwdist(gA);DA=DA(:);
DB=bwdist(gB);DB=DB(:);

%median distance.
med_A=median(DA(find(gB(:))));
med_B=median(DB(find(gA(:))));

%mean distance.
mean_distA=sum(DA.*gB(:))/sum(gA(:));
mean_distB=sum(DB.*gA(:))/sum(gB(:));

mean_dist=(mean_distA+mean_distB)/2;
hausd=max([max(DA.*gB(:)) max(DB.*gA(:))]);
if exist('outfile','var')
    fid=fopen(outfile,'w');
    fprintf(fid, 'mean_dist=%f\nmA=%f\nmB=%f\nhausd=%f\n',mean_dist,med_A,med_B,hausd);
    fclose(fid);
end