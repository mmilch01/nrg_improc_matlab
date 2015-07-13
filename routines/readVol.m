function [out_vol] = readVol(fname)
[path,name,ext]=fileparts(fname);
cur_dir=pwd;
cd([path]);
out_vol=analyze75read(fname);
cd([cur_dir]);
