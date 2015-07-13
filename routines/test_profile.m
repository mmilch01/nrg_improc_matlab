function [] = test_profile()
eq=[2.4 4.2 3.5 -1.2];
x=[43.2 -4 3.1];
for i=1:5000000
%    res=ev_plane_eq(x,eq);
%     res=eq(1)*x(1)+eq(2)*x(2)+eq(3)*x(3)+eq(4);
    res=eq(1:3).*x+eq(4);
end;

function[res]=ev_plane_eq(x,eq)
%res=eq(1:3).*x+eq(4);
res=eq(1)*x(1)+eq(2)*x(2)+eq(3)*x(3)+eq(4);