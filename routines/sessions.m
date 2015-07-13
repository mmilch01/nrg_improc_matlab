function [paths names nSessions]=sessions(data_dir)
str=dir([data_dir]);
nSessions=size(str);
nSessions=nSessions(1)-2;
paths=cellstr(char(65*ones(nSessions,2)));
names=cellstr(char(65*ones(nSessions,2)));
sd=size(data_dir);
if(data_dir(sd)~='/')
    data_dir=strcat(data_dir,'/');
end;
cur_dir=cd();
for i=1:nSessions
    paths(i)=cellstr(strcat(data_dir,'/',str(i+2).name));
    names(i)=cellstr(str(i+2).name);
end
cd(cur_dir);
