%Data Preprocessing: Get boundaries of cells
clear;close all;
load Data2.mat
load Centre.mat
load Bound4Cell.mat
load Leval.mat

x=Centre(:,1);y=Centre(:,2);
CellAmount=size(Bound4Cell,1);

scrsz = get(0,'ScreenSize');
set(gcf,'Position',scrsz*0.8)%full-screen display
hold on;

for ii=l0    
    patch(Bound4Cell{ii}(:,1),Bound4Cell{ii}(:,2),[0 0.5 0]);
    text(x(ii),y(ii),num2str(ii),'Color','red','FontSize',8);
end


for ii=l1
    patch(Bound4Cell{ii}(:,1),Bound4Cell{ii}(:,2),[0.6 0.3 0.3]);
    text(x(ii),y(ii),num2str(ii),'Color','red','FontSize',8);
end

for ii=l2
    patch(Bound4Cell{ii}(:,1),Bound4Cell{ii}(:,2),[0.6 0.5 0.7]);
    text(x(ii),y(ii),num2str(ii),'Color','red','FontSize',8);
end

for ii=l3
    patch(Bound4Cell{ii}(:,1),Bound4Cell{ii}(:,2),[0.2 0.3 0.3]);
    text(x(ii),y(ii),num2str(ii),'Color','red','FontSize',8);
end

for ii=l4
    patch(Bound4Cell{ii}(:,1),Bound4Cell{ii}(:,2),[0.6 0.3 0.7]);
    text(x(ii),y(ii),num2str(ii),'Color','red','FontSize',8);
end

for ii=l5
    patch(Bound4Cell{ii}(:,1),Bound4Cell{ii}(:,2),[0.6 0.7 0.3]);
    text(x(ii),y(ii),num2str(ii),'Color','red','FontSize',8);
end

for ii=l6
    patch(Bound4Cell{ii}(:,1),Bound4Cell{ii}(:,2),[0.6 0.3 0.3]);
    text(x(ii),y(ii),num2str(ii),'Color','red','FontSize',8);
end