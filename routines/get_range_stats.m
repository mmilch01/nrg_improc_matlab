% Returns sample statistics (2xnClasses) of specified intensity ranges
% I - source volume, ranges - 2xnRanges - array specifying lower and upper
% bounds.

function[out]= get_range_stats(I,ranges)
sz=size(ranges);
nClasses=sz(2);
sz=size(I);
out=zeros(2,nClasses);
nn=zeros(nClasses,1);
M=0.05*max(max(max(I)));
for i=1:nClasses
    if(ranges(2,i)-ranges(1,i)==0)
        ranges(2,i)=ranges(2,i)+M;
        ranges(1,i)=ranges(1,i)-M;
    end;
end;
for z=1:sz(3) 
    for y=1:sz(2)
        for x=1:sz(1)
            for i=1:nClasses
                if((I(x,y,z)>=ranges(1,i)) && (I(x,y,z)<ranges(2,i)))
                    out(1,i)=out(1,i)+I(x,y,z);
                    out(2,i)=out(2,i)+I(x,y,z)*I(x,y,z);
                    nn(i)=nn(i)+1;
                    break;
                end;
            end;
        end;
    end;
end;
out(1,:)=out(1,:)./nn';
out(2,:)=out(2,:)./nn';
out(2,:)=out(2,:)-out(1,:).*out(1,:);
return;