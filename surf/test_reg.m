%I=imread('d:/workspace/matlab/RAW.jpg','jpg');
I=imread('~/matlab/RAW.jpg','jpg');
x=[[112 125]; [159 65]; [209 70]; [235 30]; [264 66]; [296 55]; [335 63]; [344 78]; [369 98]];
[nPts k]=size(x);
wid=15;
R=I;

figure;
subplot(1,2,1),subimage(I,[0 255]),title('Original image');
hold on;
xmin=min(x(:,1));
xmax=max(x(:,1));
ymin=min(x(:,2));
ymax=max(x(:,2));

%plot([xmin xmin xmax xmax xmin],[ymin ymax ymax ymin ymin],'--r','LineWidth',2);
%plot(x(:,1),x(:,2),'-bs','LineWidth',2,'MarkerEdgeColor','b','MarkerFaceColor',...
%    'w','MarkerSize',5);
h=fspecial('average',wid);
figure;
for(i=2:nPts)        
    [B,bl,tl,tr,br]=ExtractRegion(double(I),x(i-1,:),x(i,:),wid);
    if(i==2)
        x0=[bl(1) bl(2)];
        x1=tl;
    end;
    x2=tr;
    x3=br;
    
    if(i==4)
        x2=[234 47];
        x3=[233 14];
    end;
    
%    plot([x0(1) x1(1) x2(1) x3(1) x0(1)],[x0(2) x1(2) x2(2) x3(2) x0(2)],'--b','LineWidth',1);
    x0=x3; 
    x1=x2;
%    B=ones(size(B))*255;
    %figure;
    %imshow(B,[0 255]);
    B=imfilter(B,h,'replicate');
    subplot(3,3,i-1),subimage(B,[0 255]);
    R=SaveRegion(R,B,x(i-1,:),x(i,:),wid);
end;

hold off;
figure;
subplot(1,1,1),subimage(R,[0 255]),title('Masked image');
hold on;
plot([xmin xmin xmax xmax xmin],[ymin ymax ymax ymin ymin],'--r','LineWidth',2);
hold off;

