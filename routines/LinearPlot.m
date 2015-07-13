function [] = LinearPlot(xx,yy,titl)

v=isnan(xx)+isnan(yy);
n=1;

for i=1:size(xx,1)
        if(v(i)==0) 
            x(n)=xx(i);
            y(n)=yy(i);
            n=n+1;
        end;
end;

figure('color','white');
minx=min(x(:));
maxx=max(x(:));
dx=0.1*(maxx-minx);
miny=min(y(:));
maxy=max(y(:));
dy=0.1*(maxy-miny);
plot(x,y,'o'),xlim([minx-dx maxx+dx]),ylim([miny-dy maxy+dy]);
hold on;
linfit=polyfit(x,y,1);
plot(x, x.*linfit(1)+linfit(2),'k--');
hold off;
title(titl);