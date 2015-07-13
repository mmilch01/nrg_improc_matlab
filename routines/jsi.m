function js = jsi(A,B)
A1=A(:);
B1=B(:);
n=size(A1,1);
m=0;
for i=1:n
    if(A1(i)~=B1(i)) m=m+1; end;
end;
js=1-m/n;