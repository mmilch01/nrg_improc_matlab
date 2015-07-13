function [H0,H,S]=test_curv()
[paths names nSessions]=sessions ('/data/cninds01/data2/WORK/misha/src');
for i=1:nSessions
    names(i)
    [H(i).or,H0(i).or,S(i).or]=getcurv([char(paths(i)) '/DEFACED/subvol'],[char(paths(i)) '/DEFACED/subvol_msk']);
    [H(i).bl,H0(i).blur,S(i).bl]=getcurv([char(paths(i)) '/DEFACED/subvol_blur'],[char(paths(i)) '/DEFACED/subvol_msk']);
    [H(i).ct,H0(i).ct,S(i).ct]=getcurv([char(paths(i)) '/DEFACED/subvol_coating'],[char(paths(i)) '/DEFACED/subvol_msk']);
    [H(i).nf,H0(i).nf,S(i).nf]=getcurv([char(paths(i)) '/DEFACED/subvol_normfilter'],[char(paths(i)) '/DEFACED/subvol_msk']);
end

function[H,H0,S]=getcurv(fileV,fileMask)l
avwV=avw_img_read(fileV);
V=avwV.img;
avwMsk=avw_img_read(fileMask);
Mask=avwMsk.img;
[H,H0,S]=avg_mean_curv(V,Mask,50);