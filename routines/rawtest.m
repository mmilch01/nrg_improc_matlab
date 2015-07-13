M=analyze75read('mask.4dfp.img');
V=analyze75read('W001_MR_01122010_preop_10_CBV_SH_on_W001_MR_01122010_preop_17_TRA_T1_25mm.4dfp.img');
k=1;
for i=1:numel(M)
    if (M(i)==1) res(k)=V(i); k=k+1; end;
    
end;
        
