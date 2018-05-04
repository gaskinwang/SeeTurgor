%Data Preprocessing: Get boundaries of each cell
clear;close all;
load Data2.mat
load Centre.mat
load Bound4Cell.mat

x=Centre(:,1);y=Centre(:,2);
CellAmount=size(Bound4Cell,1);

scrsz = get(0,'ScreenSize');
set(gcf,'Position',scrsz)%full-screen display
hold on;

for ii=1:CellAmount    
    patch(Bound4Cell{ii}(:,1),Bound4Cell{ii}(:,2),[0 0.5 0]);

end
for ii=1:CellAmount    

    text(x(ii),y(ii),num2str(ii),'Color','red','FontSize',8);
end
Widen=0.1;