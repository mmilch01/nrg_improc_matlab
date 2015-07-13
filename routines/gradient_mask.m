function [B] = gradient_mask(A)
%[Gx Gy Gz]=gradient(A);
%G=sqrt(Gx.*Gx+Gy.*Gy+Gz.*Gz);
%m=max(max(max(G)));
sz=size(A);
%m=m*0.2;
B=ones(sz(1),sz(2),sz(3));
max_d=min(min(sz(1)/2,sz(2)/2),sz(3)/2);
min_w=0.1;

cw=1-min_w;
dx=sz(1);
dy=sz(2);
dz=sz(3);
for(z=1:dz)
    for(y=1:dy)
        for(x=1:dz)
            d=min(sqrt((z-dz/2)^2+(y-dy/2)^2+(x-dx/2)^2),max_d);
            r=1-cw*(d/max_d);
            B(x,y,z)=r;
        end;
    end;
end;
