Data1=imread('data.png'); % *.png£¬your figure
Data2=mean(Data1,3);
Data2(Data2~=0)=255;
Data2=255-Data2;
Data2=flipud(Data2);
imshow(Data2)
hold on
axis xy

Centra=zeros(1000,2);
CentraMark=1;

ttt=1;
while ttt~=65 % = (number of total condidate cell) - 1
    ttt=ttt+1;
    [x,y]=ginput(1);
    circleplot(x,y)    
    Centra(CentraMark,:)=[x,y];
    CentraMark=CentraMark+1;   
end
Centra=Centra(1:(CentraMark-1),:);
save Data2.mat Data2

Centre=Centra(:,:)
xlswrite('Centre.xlsx',Centre)
