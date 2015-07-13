cov_mean=zeros(7,3);
cjv_mean=zeros(7,1);
for i=1:7
     cov_mean(i,:,:)=mean(cov(i,:,:));
     cjv_mean(i)=mean(cjv(i,:));
end;
cov_mean_diff=zeros(6,3);
cjv_mean_diff=zeros(6,1);
cov_diff=zeros(6,16,3);
cjv_diff=zeros(6,16);
for i=2:7
    cov_mean_diff(i-1,:,:)=cov_mean(1,:,:)-cov_mean(i,:,:);
    cjv_mean_diff(i-1,:)=cjv_mean(1,:)-cjv_mean(i,:,:);
    cov_diff(i-1,:,:)=cov(1,:,:)-cov(i,:,:);
    cjv_diff(i-1,:)=cjv(1,:)-cjv(i,:);
end;
cov_diff=max(cov_diff,0);
cjv_diff=max(cjv_diff,0);

figure; 
bar(cov_mean_diff);
set(get(gca,'YLabel'),'String','Average reduction in COV');
set(get(gca,'XLabel'),'String','Algorithm');
set(gca,'YLim',[-0.01 0.08]);
legend('CSF','GM','WM','Location','NorthWest');
set(gca,'XTickLabel',{'BFC';'ITK';'FSL';'AVI+FSL';'N3';'AVI'});

figure;
bar(cjv_mean_diff);
set(get(gca,'YLabel'),'String','Average reduction in CJV of GM and WM');
set(get(gca,'XLabel'),'String','Algorithm');
%set(gca,'YLim',[-0.01 0.08]);
%legend('CSF','GM','WM','Location','NorthWest');
set(gca,'XTickLabel',{'BFC';'ITK';'FSL';'AVI+FSL';'N3';'AVI'});


figure;
[cd2_s ind2]=sortrows(-cov_diff(:,:,2),2);
bar3(-cd2_s);
set(get(gca,'YLabel'),'String','Algorithm');
set(get(gca,'XLabel'),'String','Dataset');
set(get(gca,'ZLabel'),'String','Reduction in COV of GM');

set(gca,'ZLim',[0 0.1]);
set(gca,'YLim',[0 7]);
set(gca,'YTickLabel',{'AVI+FSL';'AVI';'BFC';'N3';'FSL';'ITK'});

figure;
[cd3_s ind3]=sortrows(-cov_diff(:,:,3),2);
bar3(-cd3_s);
set(get(gca,'YLabel'),'String','Algorithm');
set(get(gca,'XLabel'),'String','Dataset');
set(get(gca,'XLabel'),'String','Reduction in WM');
set(gca,'ZLim',[0 0.11]);
set(gca,'YLim',[0 7]);
set(gca,'YTickLabel',{'AVI+FSL';'FSL';'AVI';'BFC';'N3';'ITK'});
set(get(gca,'ZLabel'),'String','Reduction in COV of WM');


figure;
[cj_s indj]=sortrows(-cjv_diff,2);
bar3(-cj_s);
set(get(gca,'YLabel'),'String','Algorithm');
set(get(gca,'XLabel'),'String','Dataset');
set(gca,'ZLim',[0 0.5]);
set(gca,'YLim',[0 7]);
set(gca,'YTickLabel',{'AVI+FSL';'AVI';'FSL';'N3';'BFC';'ITK'});
set(get(gca,'ZLabel'),'String','Reduction in CJV of GM and WM');
