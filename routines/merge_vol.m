function C = merge_vol(V,Vsub,x0)
sz=size(Vsub);
szv=size(V);
C=V;
dsy=szv(2)-sz(2);

for z=1:sz(3)
    for y=1:sz(2)
        for x=1:sz(1)
            C(x+x0(1),y+x0(2)+dsy,z+x0(3))=Vsub(x,y,z);
        end;
    end;
end;