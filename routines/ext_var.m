
function[var]=ext_var(A)
%obtain volume histogram
H=showhist(A,'square',0);
H=nicefy(H);
sz=size(A);
nPix=sz(1)*sz(2)*sz(3);
nPix=sum(H);

nI=size(H); %number of intensities
nI=nI(2);
var=zeros(nI,1);
pp1=zeros(nI,1);
mm_t=zeros(nI,1);
m_tot=0; %total volume mean intensity
for i=1:nI
    m_tot=m_tot+(i*H(i))/nPix;
end;

p1=0;
m_t=0;

%calculate medium watershed for cross-class variance
for i=1:nI 
    fr=H(i)/nPix;
    p1=p1+fr;
    pp1(i)=p1;
    m_t=m_t+i*fr;
    mm_t(i)=m_t;
    if(p1==0) continue; end;
    var(i)=(m_tot*p1-m_t)^2/(p1*(1-p1));
end;

[mmm ind]=max(var)

return;
%initial estimate of tissue class mean intensities
t=zeros(3,1);
t(1)=ind*4/9; t(2)=ind*7/9; t(3)=ind*14/9;
v=5*get_grad(3); %all possible increment vectors

nI=min(nI,2000);
H=H(1:nI);


sg0=0;sg=1;
nInc=size(v); %number of increment vectors
nInc=nInc(2);
sgv=zeros(nInc,1); %array to contain sample inter-class variances based on different increment vectors
while (sg0<sg)
    for i=1:nInc
        new_t=adj_t(t,v(:,i),nI);
        if(is_valid(new_t))
            sgv(i)=sigma_g(H,m_tot,new_t);
        else 
            sgv(i)=0;
        end;
    end;
    sg0=sg;
    [sg best_ind]=max(sgv);
    sg-sg0
    best_ind
    t=adj_t(t,v(:,best_ind),nI);
end;
t
% subplot(3,1,1);
% plot(1:nI,var);
% subplot(3,1,2);
% plot(1:nI,pp1);
% subplot(3,1,3);
% plot(1:nI,mm_t);

function [out]=sigma_g(H,m_tot,t)
nSeg=size(t);
nSeg=nSeg(1);
st=1;
sigma_g=0;
nI=size(H);
for i=1:nSeg
    if(i<nSeg) en=round(t(i));
    else en=nI;
    end;
    sigma_g=sigma_g+pr(H,st,en)*((mu(H,st,en)-m_tot)^2);
    st=en;
end;
out=sigma_g;
return;

function[out]=pr(H,st,en)
nI=sum(H);
out=sum(H(st:en))/nI;
return;

function[out]=mu(H,st,en)
nI=sum(H);
out=0.0;
for i=st:en
    out=out+i*H(i);
end;
out=out/nI;
return;

function[out]=get_grad(nEl)
nInc=3^nEl;
vec=zeros(3,nInc);
chg=[-1 0 1];
ind=1;
for i=1:3
    for j=1:3
        for k=1:3
            vec(:,ind)=[chg(i) chg(j) chg(k)];
            ind=ind+1;
        end;
    end;
end;
out=vec;
return;
    
function[out]=adj_t(t,vec,t_max)
out=t+vec;
for i=1:size(t)
    out(i)=max(out(i),0);
    out(i)=min(t_max,out(i));
end;
return;

function[out]=is_valid(t)
out=1;
for i=1:size(t)-1
    if(t(i)>=t(i+1))
        out=0;
        break;
    end;
end;
return;


function [out]=nicefy(H)
NIn=max(size(H));
sm=0;
NPts=0.01*sum(H);
max_ind=-1;
for i=NIn:-1:1
    sm=sm+H(i);
    if(sm>NPts)
        max_ind=i;
        break;
    end;
end;
if(max_ind<0)
    max_ind=NIn;
end;
out=H(1:max_ind/2);
return;