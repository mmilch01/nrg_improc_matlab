data_dir='/data/cninds01/data2/WORK/misha/src';
[paths names nSessions]=sessions(data_dir)

for i=1:nSessions
    session_name=char(names(i))
    session_path=char(paths(i))
    avw=avw_img_read(strcat(session_path,'/WELLS/',session_name,'_t88_111_wells'));
    A=avw.img;
    avw=avw_img_read(strcat(session_path,'/WELLS/',session_name,'_t88_111_seg'));
    Seg=avw.img;
    
%    A=A(75:125,75:125,75:124);
%    Seg=Seg(75:125,75:125,75:124);
    [Res W]=icm(A,Seg,[1 2 3 4]);

 
    icm_file=strcat(session_path,'/WELLS/',session_name,'_t88_111_icm');
    avw.fileprefix=icm_file;
    avw.img=Res;
    avw_img_write(avw,icm_file);
end