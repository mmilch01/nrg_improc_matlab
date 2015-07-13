function[out, W]=icm(I,Iseg,Seg)
beta=0.2;
[M N K]=size(I);
nClasses=max(size(Seg));
FixClass=max(max(Seg))+1;
Neib=[[-1 0 -1]; [0 -1 -1]; [1 0 -1]; [0 1 -1]; [0 0 -1]; [-1 0 0]; [-1 -1 0]; ...
    [0 -1 0]; [1 -1 0]; [1 0 0]; [1 1 0]; [0 1 0]; [-1 1 0]; [-1 0 1]; [0 -1 1]; ...
    [1 0 1]; [0 1 1]; [0 0 1]];
sz=size(Neib);
nNeib=sz(1);
'Calculating region statistics...'
Stats=get_seg_stats(I,Iseg,Seg);
logSigma=log(sqrt(Stats(2,:)));
invSigma=ones(nClasses,1)./(2*Stats(2,:))';
INextSeg=Iseg;
Nstart=1;
Ifix=Iseg;
W=zeros(M, N, K, nClasses);
for iter=1:10
    Nchg=0;
    sprintf('Iteration %d',iter)
    for z=2:K-1
%        disp(sprintf('Processing slice %d out of %d',z,K-1));
        for y=2:N-1
            for x=2:M-1
                if(Ifix(x,y,z)==FixClass) continue; end;
                U=zeros(nClasses,1);
                valSeg=Iseg(x,y,z);                
                val=I(x,y,z);
                for i=1:nNeib
                    ind=[x y z]+Neib(i,:);
                    for j=1:nClasses
                        if(Iseg(ind(1),ind(2),ind(3))==Seg(j))
                            U(j)=U(j)+1;
                        end;
                    end;
                end;
                S=zeros(nClasses,1);
                for i=1:nClasses
                    S(i)=invSigma(i)*(val-Stats(1,i))^2 - beta*U(i)+logSigma(i);
                    W(x,y,z,i)=0;
                end;
                [m ind]=min(S);
                INextSeg(x,y,z)=Seg(ind);
                W(x,y,z,ind)=1;
                if(valSeg~=Seg(ind)) %change this classification
                    Nchg=Nchg+1;
                elseif(U(ind)==nNeib)
                    Ifix(x,y,z)=FixClass;
                end;
            end;
        end;
    end;
    sprintf('Changed %d points',Nchg)
    if(iter==1) Nstart=Nchg; end;
    Iseg=INextSeg;
    if(Nstart/Nchg>=10.0) break; end;
end;
out=Iseg;
return;

