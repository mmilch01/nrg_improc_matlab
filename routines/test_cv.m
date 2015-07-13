function [cov cjv avg] = test_cv(folder,session,suffix)
cur_dir=pwd;
cd ([session]);

%label_vol=read_vol('FSL_PARTITIOND',session,'_bet_seg.img');
%label_vol=read_vol('WELLS',session,'_t88_111_h_seg.img');
label_vol=read_vol('DSF',session,'_t88_111_avg_seg.img');
disp([folder]);
vol=round(read_vol([folder],session,suffix));

if(strcmp(folder,'FSL_PARTITIOND'))
    vol=read_vol('ANALYZE',session,'_t88_111.4dint.img');
    label_vol=read_vol('FSL_PARTITIOND',session,'_bet_seg.img');
%    disp('Original ANALYZE');
    [cov(:,1) cjv(:,1) avg(:,1)]=do_vol(label_vol,vol,[1 2 3]);
    analyze_wm_avg=avg(2);
    
    vol=read_vol([folder],session,suffix);

    vol=vol*0.1;
    [cov cjv avg]=do_vol(label_vol,vol,[1 2 3]);
    fsl_coeff=0.1*analyze_wm_avg/avg(2);    
    vol=read_vol('FSL_PARTITIOND',session,suffix);
    %cd ([pwd]);
    vol=vol*fsl_coeff;
    [cov cjv avg]=do_vol(label_vol,vol,[1 2 3]);
    cd ([cur_dir]);
    return;
end;
[cov cjv avg]=do_vol(label_vol,vol,[2 3 4]);
cd ([cur_dir]);
return;

%calculate variation coefficient
function [sigma, avg, cov]=vc(A,Atest)

nClasses=4;
stats=get_seg_stats(A,Atest+1,[1 2 3 4]);

sigma=zeros(3,1);
mu=zeros(3,1);

%for i=2:nClasses
% [dx dy dz]=size(A);
% 
% avg_=uint32(zeros(nClasses,1)); nn=uint32(zeros(nClasses,1));
% for i=1:1:dx %calculate avg(x)
%     for j=1:1:dy
%         for k=1:1:dz
%             if(Atest(i,j,k)==0) continue; end;
%             val=Atest(i,j,k);
%             for l=1:1:nClasses
%                 if(val==class_vals(l))
%                     avg_(l)=avg_(l)+double(A(i,j,k));
%                     nn(l)=nn(l)+1;
%                     break;
%                 end;
%             end;
%         end;
%     end;
% end;
% s='';
% avg=double(zeros(nClasses,1));
% for i=1:1:nClasses
%     avg(i)=avg_(i)/nn(i);
%     s=strcat(s,sprintf(' class %d: avg = %.2f; ',i,avg(i)));
% end
% 
% sigma_=double(zeros(nClasses,1));
% for i=1:1:dx %calculate disp(x)
%     for j=1:1:dy
%         for k=1:1:dz
%             if(Atest(i,j,k)==0) continue; end;
%             val=Atest(i,j,k);
%             for l=1:1:nClasses
%                 if(val==class_vals(l))
%                     tmp=double(A(i,j,k)-avg(l));
%                     sigma_(l)=sigma_(l)+tmp*tmp;
%                     break;
%                 end;
%             end;
%         end;
%     end;
% end;
% sigma=double(zeros(nClasses,1));
% for i=1:1:nClasses
%     sigma(i)=sqrt(double((sigma_(i)/(nn(i)-1))));
%     s=strcat(s,sprintf(' class %d: sigma = %.2f;',i,sigma(i)));
% end;
% disp(s);
% cov=sigma./avg;


function [cov,cjv,avg]=do_vol(vol_label,vol_src,seg_vals)
stats=get_seg_stats(double(vol_src),double(vol_label),seg_vals);
cov=zeros(3,1);
stats(2,:)=sqrt(stats(2,:));
im=max(size(seg_vals));
sm=max(size(stats));
cjv=(stats(2,sm-1)+stats(2,sm))/abs(stats(1,sm-1)-stats(1,sm));
avg=stats(1,sm-2:sm)';
for i=sm-2:sm
    cov(i-sm+3)=stats(2,i)/stats(1,i);
end;
return;
%[sigma avg cov]=vc(fsl_src,template,[2 3]);

function [out_vol] = read_vol(folder,root,suffix)
if(isdir(folder)==0) 
    out_vol=0;
    return;
end;
cd ([folder]);
out_vol=analyze75read(strcat(root,suffix));
cd ('..');
result=1;


