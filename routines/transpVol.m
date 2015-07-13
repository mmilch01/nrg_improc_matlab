function []=transpVol(path,perm)
v0=readVol(path);
v0prime=permute(v0,perm);
%saveVol(v0prime,strcat(path,'perm'));
saveVol(v0prime,path);