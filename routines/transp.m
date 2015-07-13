function[out]=transp(array,tr1,tr2)
sz=size(array);
%algorithms by performace
out0=zeros(sz);
for i=1:sz(1)
     out0(tr1(i),:)=array(i,:);
end;
out=out0;
%data by amount of variation

%out=zeros(sz);
%for i=1:sz(2)
%    out(:,i)=out0(:,tr2(i));
%end;
            