data_dir='/data/cninds01/data2/WORK/misha/src';
[paths names nSessions]=sessions(data_dir);

for i=1:nSessions
    session_name=char(names(i));
    disp(session_name);
    sp=[char(paths(i)) '/DEFACED/vol'];
    
    avw1=avw_img_read([sp '_orig']);
    A=avw1.img;
    avw=avw_img_read([sp '_blur']);
    Abl=avw.img;
    avw=avw_img_read([sp '_coating']);
    Act=avw.img;
    avw=avw_img_read([sp '_normfilter']);
    Anf=avw.img;
    nmis(i).blur=nmi(A,Abl);
    nmis(i).coating=nmi(A,Act);
    nmis(i).normfilter=nmi(A,Anf);
    dst(i).blur=sim(A,Abl);
    dst(i).coating=sim(A,Act);
    dst(i).normfilter=sim(A,Anf);
end

for i=13:13
    session_name=char(names(i));
    disp(session_name);
    sp=[char(paths(i)) '/DEFACED/vol'];
    
    avw=avw_img_read([sp '_orig_bet'],0);
    A=avw.img;
    avw=avw_img_read([sp '_orig_bet_em'],0);
    A_em=avw.img;    
    
    avw=avw_img_read([sp '_blur_bet'],0);
    Abl=avw.img;
    avw=avw_img_read([sp '_blur_bet_em'],0);
    Abl_em=avw.img;        
    
    avw=avw_img_read([sp '_coating_bet'],0);
    Act=avw.img;
    avw=avw_img_read([sp '_coating_bet_em'],0);
    Act_em=avw.img;    
    
    avw=avw_img_read([sp '_normfilter_bet'],0);
    Anf=avw.img;
    avw=avw_img_read([sp '_normfilter_bet_em'],0);
    Anf_em=avw.img;    
    
    jsis(i).blur=jsi(A,Abl);
    jsis(i).coating=jsi(A,Act);
    jsis(i).normfilter=jsi(A,Anf);
    
    pd_em(i).blur=sim(A_em,Abl_em);
    pd_em(i).coating=sim(A_em,Act_em);
    pd_em(i).normfilter=sim(A_em,Anf_em);
        
end