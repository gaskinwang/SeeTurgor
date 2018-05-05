%数据预处理：得到每个细胞的所有边界
clear;close all;
load Data2.mat
load Centre.mat
load Bound4Cell.mat
% load  select.mat

x=Centre(:,1);y=Centre(:,2);
CellAmount=size(Bound4Cell,1);
scrsz = get(0,'ScreenSize');
set(gcf,'Position',scrsz)%全屏显示
hold on;

for se=1:3
    sel=xlsread('select.xlsx',se);
    patch_color=zeros(1,3);
    patch_color(se)=1;
    patch_color=patch_color*0.5;
    for ii=sel'
        patch(Bound4Cell{ii}(:,1),Bound4Cell{ii}(:,2),patch_color);        
    end
    for ii=sel'
        text(x(ii),y(ii),num2str(ii),'Color','red','FontSize',8);
    end
    
end