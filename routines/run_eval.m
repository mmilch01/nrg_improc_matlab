%data_dir='../DATA';
data_dir='/data/cninds01/data2/WORK/misha/src';
[paths names nSessions]=sessions(data_dir)

% out_dir='/data/cninds01/data2/WORK/misha';
%cov=double(zeros(nSessions,2,7));
%avg=double(zeros(nSessions,2,7));
%cjv=double(zeros(nSessions,1,7));

cur_dir=pwd;
%sprintf('%s %s %s %s %s %s %s','ORIG','BFC','ITK','FSL','FSL_PARTITIOND','MNI','PARTITIOND');
percents=double(zeros(nSessions,3));

for i=1:nSessions
%    cd ([data_dir]);
    session_name=char(names(i))
    session_path=char(paths(i));
    percents(i,:)=test_class_diff(session_name,session_path);
%    percents(i,:)=test_class_diff('24831');
%    [cov(i,:,:) cjv(i,:,:) avg(i,:,:)]=test_cv(session.name);

end