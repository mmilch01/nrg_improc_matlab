function [CR,BAmean,BAstd,linFit,linfit2,rsq,Sa2,Sb2] = BlandAltman(var1_0, var2_0, flag,name1,name2)
 
name=strcat(name1,'_vs_',name2);
v=isnan(var1_0)+isnan(var2_0);
n=1;

for i=1:size(var1_0,1)
        if(v(i)==0) 
            var1(n)=var1_0(i);
            var2(n)=var2_0(i);
            n=n+1;
        end;
end;

    %%%Plots a Bland-Altman Plot
    %%%INPUTS:
    %%% var1 and var2 - vectors of the measurements
    %%%flag - how much you want to plot
        %%% 0 = no plot
        %%% 1 = just the data
        %%% 2 = data and the difference and CR lines
        %%% 3 = above and a linear fit
    %%%
    %%%OUTPUTS:
    %%% means = the means of the data
    %%% diffs = the raw differences
    %%% meanDiff = the mean difference
    %%% CR = the 2SD confidence limits
    %%% linfit = the paramters for the linear fit
    
    
    if (nargin<1)
       %%%Use test data
       var1=[512,430,520,428,500,600,364,380,658,445,432,626,260,477,259,350,451];%,...
       var2=[525,415,508,444,500,625,460,390,642,432,420,605,227,467,268,370,443];
       flag = 3;
    end
    
        
        
    if nargin==2
        flag = 0;
    end
    
    means = mean([var1;var2]);
    diffs = var1-var2;
    if(flag==4)
        diffs=(var1-var2)./means;
    end
    meanDiff = mean(diffs);
    sdDiff = std(diffs);
    BAmean=meanDiff;
    BAstd=sdDiff;
    CR = [meanDiff + 1.96 * sdDiff, meanDiff - 1.96 * sdDiff]; %%95% confidence range
    
    [linFit S] = polyfit(means,diffs,1); %%%work out the linear fit coefficients
    
    %%%plot results unless flag is 0
    if flag ~= 0        
        f=figure('OuterPosition',[0,0,1200,568]);
        %bland-altman
                
        subplot(1,2,1);
        plot(means,diffs,'o');
        hold on
        if flag > 1
            plot(means, ones(1,length(means)).*CR(1),'k-'); %%%plot the upper CR
            plot(means, ones(1,length(means)).*CR(2),'k-'); %%%plot the lower CR
%           plot(means,zeros(1,length(means)),'k'); %%%plot zero
            plot([min(means(:)) max(means(:))], ones(1,2).*meanDiff,':k','LineWidth',2);%plot mu
        end
        if flag > 2
            plot(means, means.*linFit(1)+linFit(2),'k--'); %%%plot the linear fit
        end
        xlabel(strcat('(',name1,' + ', name2,') / 2'));
        ylabel(strcat('(',name1,' - ', name2,') / (',name1, ' + ', name2,')'));
        title('Bland-Altman');
        hold off               
        
        %one set against the other
        subplot(1,2,2);
        mn=min(min(var1(:)),min(var2(:)));
        mx=max(max(var1(:)),max(var2(:)));
        plot(var1,var2,'o');
        hold on;
        xlim([mn; mx]);
        ylim([mn; mx]);
        xlabel (name1);
        ylabel (name2);
        title ('Linear regression');
        hold off;
        linfit2 = polyfit(var1,var2,1);
        [Sa2,Sb2]=getsigmas(var1,var2,linfit2(1),linfit2(2));
        yfit2=polyval(linfit2,var1);
        resid=var2 - yfit2;
        SSresid=sum(resid.^2);
        SStotal=(length(var2)-1)*var(var2);
        rsq=1-SSresid/SStotal;
        
        meanDiff = mean(var1);
        sdDiff = std(var2);
%       CRL = [meanDiff + 1.96 * sdDiff, meanDiff - 1.96 * sdDiff]; %%95% confidence range        
        hold on
        if flag > 2
            plot(var2, var2.*linfit2(1)+linfit2(2),'k--'); %%%plot the linear fit
        end
%        title(['Linear fit: ' name]);
        text(mx-(mx-mn)*.2,mn+(mx-mn)*.1,['R^2=' num2str(rsq,2)]);
        set(gcf,'PaperPositionMode','auto');
        print('-dpng',[name '.png']);
        close(f);
%        saveas(f,[name '.png'],'png');
    end
    
function [Sa2,Sb2]=getsigmas(x,y,a,b)
N=max(size(x));
Sxx=sum(x.*x);
Sx=sum(x);
S=N-1;
delta=(N-1)*Sxx-Sx*Sx;
Sa2=Sxx/delta;
Sb2=S/delta;
tmp=y-a*ones(size(y))-b*x;
ch_sq=sqrt(sum(tmp.*tmp)/(N-2));
Sa2=Sa2*ch_sq;
Sb2=Sb2*ch_sq;



