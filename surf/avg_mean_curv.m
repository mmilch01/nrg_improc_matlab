function [H,H0,S] = avg_mean_curv(V,Vmask,thr)
V=reorient(V,'x',1,-1);
Vmask=reorient(Vmask,'x',1,-1);
m2d=mask2d(Vmask);

S=calc_surf(V,m2d,thr);
[p,q]=gradient(S);
[r,s]=gradient(p);
[FYX,t]=gradient(q);
pp=p.*p; qq=q.*q;
h=sqrt(1+pp+qq);
H=abs((r.*(1+qq)-2*p.*q.*s+t.*(1+pp))./(2*h.*h.*h));
H0=sum(sum(H));

function[m2d]=mask2d(Vmask)
sz=size(Vmask);
m2d=zeros(sz(1),sz(2));
for x=1:sz(1)
    for y=1:sz(2)
        for z=1:sz(3)
            if(Vmask(x,y,z)~=0) m2d(x,y)=1; break; end;
        end;
    end;
end;

function [S]=calc_surf(V,m2d,thr)
sz=size(V);
S=zeros(sz(1),sz(2));
for y=1:sz(2)
   for x=1:sz(1)
       if(m2d(x,y)==0) continue; end;
       S(x,y)=getval(V,[x y],3,sz,thr);
    end;
end

function[res]=getval(V,x,axis,sz,thresh)
if(axis>0) dir=1; else dir=-1; axis=-axis; end;

if(dir==-1) st=sz(axis);en=1;res=1;
else st=1; en=sz(axis);res=sz(axis);
end;

res=0;
for i=st:dir:en
%    if (Msk(x(1),x(2),i)==0) continue; end;
    switch(axis)
        case 3
            val=V(x(1),x(2),i);
        case 2 
            val=V(x(1),i,x(3));
        case 1 
            val=V(i,x(2),x(3));
    end;            
    if(val>thresh)
      res=i;
      break;
    end;
end;

function[res]=reorient(V, vertical, dir, inverse)
if(strcmp(vertical,'x'))
   transp=[3 2 1];
elseif(strcmp(vertical,'y'))
   transp=[1 3 2];
else 
   transp=[1 2 3];
end;

if(dir==1) %forward
    res=redim(V,transp);
    if(inverse==1)
        res=reflect(res,3);
    end;
else %back
    res=redim(V,transp);
    if(inverse==1)
        if(strcmp(vertical,'x'))
            res=reflect(res,1);
        elseif(strcmp(vertical,'y'))
            res=reflect(res,2);
        else 
            res=reflect(res,3);
        end
    end
end;
