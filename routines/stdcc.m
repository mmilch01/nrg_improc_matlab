function [res] = stdcc (A,B,C)
l=size(A(:));
res=zeros(size(A));
for i=1:l(1)
    nv=1;
    if ( ~isnan(A(i)) )
        vec(nv)=A(i);
        nv=nv+1;
    end
    if ( ~isnan(B(i)) )
        vec(nv)=B(i);
        nv=nv+1;
    end
    if ( ~isnan(C(i)) )
        vec(nv)=C(i);
        nv=nv+1;
    end        
    res(i)=round(std(vec)*100)*.01;
end;
