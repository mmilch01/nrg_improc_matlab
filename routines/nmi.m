function I=nmi(A,B)
ea=entropy(A);
eb=entropy(B);
eab=mi(A,B);
if(eab<1e-12) 
    I=0; 
else
    I=(ea+eb)/eab;
end;