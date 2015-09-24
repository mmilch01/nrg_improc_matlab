function add_grid(file_in, fmt_in, file_out, fmt_out, stepx, stepy)
A=imread(file_in,fmt_in);
M=prctile(A(:),95);
szx=size(A,1);
szy=size(A,2);
nch=size(A,3);
val=uint8(double(M)*ones(nch,1));

for x=1:szx
    for y=1:szy
       if (mod(x,stepy)==0)
            A(x,y,:)=val;
       end
       if (mod(y,stepx)==0)
           A(x,y,:)=val;
       end
    end
end

imwrite(A,file_out,fmt_out);