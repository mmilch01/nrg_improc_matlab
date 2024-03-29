function[] = draw_line_3d(p0,p1,c)
ver=zeros(3,2);
fac=zeros(3,2);
ver(:,1)=p0;
ver(:,2)=p1;
fac(1,1)=1;
fac(2,1)=2;
fac(3,1)=2;
fac(1,2)=2;
fac(2,2)=1;
fac(3,2)=2;

patch('vertices',ver,'faces',fac,...
    'edgecolor',c,...
    'facecolor',c,...
    'CData',[NaN NaN NaN],...
    'LineStyle','-',...
    'FaceAlpha',1,...
    'FaceLighting','flat');
