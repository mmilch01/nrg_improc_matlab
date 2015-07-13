data_dir='/data/cninds01/data2/WORK/misha/src';
[paths names nSessions]=sessions(data_dir)
ind=zeros(nSessions,1);
for i=1:nSessions
%    cd ([data_dir]);
    session_name=char(names(i))
    session_path=char(paths(i));
    avw=avw_img_read(strcat(session_path,'/ANALYZE/',session_name,'_t88_111.4dint'));
    A=avw.img;
%   figure('name',[session_name]);
    res=ext_var(A);
    [a ind(i)]=max(res);
end
