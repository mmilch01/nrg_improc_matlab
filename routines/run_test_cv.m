%data_dir='../DATA';
data_dir='/data/cninds01/data2/WORK/misha/src';
[paths names nSessions]=sessions(data_dir);

% out_dir='/data/cninds01/data2/WORK/misha';
nClasses=3;
cov=double(zeros(7,nSessions,nClasses));
avg=double(zeros(7,nSessions,nClasses));
cjv=double(zeros(7,nSessions,1));


cur_dir=pwd;
%sprintf('%s %s %s %s t1%s %s %s','ORIG','BFC','ITK','FSL','FSL_PARTITIOND','MNI','PARTITIOND');
percents=double(zeros(nSessions,3));

for i=2:2%nSessions
%    cd ([data_dir]);
    session_name=char(names(i));
    disp(session_name);
    session_path=char(paths(i));
%    [cova(i,:) cjva(i,1) avga(i,:)] = test_cv('ANALYZE',session_path,'_t88_111.4dint.img');
%    [covb(i,:) cjvb(i,1) avgb(i,:)] = test_cv('BFC',session_path,'_t88_111_bfc.4dint.img');
%    [covi(i,:) cjvi(i,1) avgi(i,:)] = test_cv('ITK',session_path,'_t88_111_itk.4dint.img');
%    [covf(i,:) cjvf(i,1) avgf(i,:)] = test_cv('FSL',session_path,'_t88_111_bet_restore.img');
%    [covfp(i,:) cjvfp(i,1) avgfp(i,:)] = test_cv('FSL_PARTITIOND',session_path,'_bet_restore.img');
%    [covm(i,:) cjvm(i,1) avgm(i,:)] = test_cv('MNI',session_path,'_t88_111_n3.4dint.img');
%    [covp(i,:) cjvp(i,1) avgp(i,:)] = test_cv('PARTITIOND',session_path,'_t88_111_gfc.img');
    
%    [covw(i,:) cjvw(i,1) avgw(i,:)] = test_cv('WELLS',session_path,'_t88_111_h.img');
    [covd(i,:) cjvd(i,1) avgd(i,:)] = test_cv('EM_SF',session_path,'_t88_111_bet_emsf.img');
%    [covdb(i,:) cjvdb(i,1) avgdb(i,:)] = test_cv('EM_SF_BET',session_path,'_t88_111_bet_emsf.img');
%    [covd2(i,:) cjvd2(i,1) avgd2(i,:)] = test_cv('EM_SF2',session_path,'_t88_111_bet_emsf.img');
     
end