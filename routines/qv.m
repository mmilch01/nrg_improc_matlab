function[]= qv(I)
mn=min(min(I));
mx=prctile(reshape(I,[],1),95);
figure;
imshow(I,[mn mx]);