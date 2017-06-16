function[] =  plot_profiles(rt)
    mfwid=1;
    nm1=[ rt '_profile_init.csv'];
    P=csvread([rt nm1]);
    nm2=[char(subs(i)) '_profile_final_lin.csv'];
    P1=csvread([rt nm2]);
    nm3=[char(subs(i)) '_profile_final_nonlin.csv'];
    P2=csvread([rt nm3]);
%    subplot(nrow,ncol,2*i-1);
    set(0,'DefaultAxesColorOrder',[1 .5 0; 0 .5 1; 0 .7 .5],'DefaultAxesLineStyleOrder','-');
    lines=find(P(:,2)==0);    
    P2(lines,2)=P2(lines-1,2);
    P1(lines,2)=P1(lines-1,2);
    P(lines,2)=P(lines-1,2);    
    f=figure('Visible','off','OuterPosition',[0,0,640,480]);
    plot(P(:,1),medfilt1(P(:,2),mfwid),P1(:,1),medfilt1(P1(:,2),mfwid),P2(:,1),medfilt1(P2(:,2),mfwid)),title(nm1,'interpreter','none'),axis tight;
    saveas(f,[rt '_profiles.png'], 'png');    
end