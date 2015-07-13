function[A]=add_noise(SRC)
sz=size(SRC);
A=SRC;
for z=1:sz(3)
    for y=1:sz(2)
        for x=1:sz(1)
            if(A(x,y,z)>0) continue; end;
            A(x,y,z)=10+rand()*10;
        end;
    end;
end;