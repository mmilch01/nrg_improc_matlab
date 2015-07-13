function d=sim(A,B)
A1=A(:); B1=B(:);
for i=1:size(A1,1)
    if(A1(i)==0 || B1(i)==0)
        A1(i)=0;
        B1(i)=0;
    end;
end;        
t=A1-B1;

d=sqrt(sum(t.*t)/size(t,1));