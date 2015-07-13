hold on;
for i=1:6
if(t(i).deg==0) continue;end;
ver=[t(i).origin;t(i).origin+t(i).v1;...
    t(i).origin+t(i).v2;t(i).origin+t(i).v3;x];
draw_shape(ver);
end;


ver=[tetr.origin;tetr.origin+tetr.v1;tetr.origin+tetr.v2;tetr.origin+...
    tetr.v3;x];
draw_shape(ver);