% model: yi=ai*xi+bi, i=1..3.
% Solve with least squares method for N samples.
% X: 3xN, Y: 3xN.
function [a, b, P]=solve_coord_ls(X,Y,N)
Sx=sum(X,2);
Sy=sum(Y,2);
Sxy=sum(X.*Y,2);
Sy2=sum(Y.*Y,2);
A=zeros(6,6);
B=zeros(6,1);
for i=1:3
    A(i,i)=Sy2(i);
    A(i,i+3)=Sy(i);
    A(i+3,i)=Sy(i);
    A(i+3,i+3)=N;
    B(i)=Sxy(i);
    B(i+3)=Sx(i);
end;
res=inv(A)*B;
a=res(1:3);
b=res(4:6);
for i=1:N
    P(:,i)=Y(:,i).*a+b;
end;

