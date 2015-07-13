function[]=draw_reper(t)
hold on;
draw_line_3d(t.origin,t.origin+t.v1,[1,0,0]);
draw_line_3d(t.origin,t.origin+t.v2,[0,1,0]);
draw_line_3d(t.origin,t.origin+t.v3,[0,0,1]);

axis square;
axis tight;
axis off;
daspect([1 1 1]);
view([-1 0.7 0.5]);
hold off;