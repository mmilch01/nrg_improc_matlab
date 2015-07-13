function[]=draw_shape(pts)
type='tetr';
%if(type=='tetr')
    vertices=pts;
    faces=zeros(3,5);
    faces(:,1)=[1,2,3];
    faces(:,2)=[1,2,4];
    faces(:,3)=[2,3,4];
    faces(:,4)=[1,3,4];
    faces(:,5)=[1,1,5];
    faces=faces';
%else 
%    return;
%end;
face_color=[0 0 0];
edge_color=[0 0 0];
line_style='-';
alpha=0;

patch('vertices',vertices,'faces',faces,...
    'facecolor',face_color,...
    'edgecolor',edge_color,...
    'CData',[NaN NaN NaN],...
    'LineStyle',line_style,...
    'FaceAlpha',alpha,...
    'FaceLighting','flat');
%colormap rgb;%gray(256);
%lighting flat;
%camproj('perspective');
axis square;
axis tight;
axis off;
daspect([1 1 1]);
view([-1 0.7 0.5]);
