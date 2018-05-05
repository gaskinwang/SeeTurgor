%基础部分全部测试完成，下面加入遗传算法的框架
clear all;close all;clc
load prepare.mat

ColorAllocation=cell(1,3);
FinalColorAllocation=zeros(1,size(Centre,1));
AddationImformation.Known=[ 9   10  11  12  13  14  15  16;...
                            4   4   1   1   1   1   1   1];

for se=1:3
    AddationImformation.se=se;
    AddationImformation.Information=Information;
    AddationImformation.InformationCount=InformationCount;
    if se ~=2
        [AddationImformation.Information,AddationImformation.InformationCount]=...
            Remove0_5(Information,InformationCount);
    end
    AddationImformation.Path=Path{se};
    AddationImformation.PathCount=PathCount{se};
    AddationImformation.selection=xlsread('select.xlsx',se);
    AddationImformation.Path=relativePath(...
        AddationImformation.Path,AddationImformation.selection);
    AddationImformation.CellVertex=Bound4Cell;
    AddationImformation.x=Centre(:,1);
    AddationImformation.y=Centre(:,2);
    
    CellAmount=length(AddationImformation.selection);
    GaStrategy.TribeSize=100;
    GaStrategy.GenSize=CellAmount;
    GaStrategy.AddationImformation=AddationImformation;
    GaStrategy.DiasterCountDown=200;%-
    GaStrategy.HighTribeMixMax=100;%-
    GaStrategy.EvolutionYearMax=inf;%-
    GaStrategy.TimeMax=1;
    GaStrategy.MovieOn=true;
    GaStrategy.MovieClearCountDown=[1000,1000];
    
    BestGen=myga5(GaStrategy);
    ColorAllocation{se}=GetColorAllocation(BestGen,AddationImformation);
    xlswrite('ColorAllocation.xlsx',ColorAllocation{se},se);
    FinalColorAllocation(AddationImformation.selection)=...
        ColorAllocation{se};
end


%可视化部分
h_fig=figure();
cmap=hsv();%颜色对应关系
colormap(cmap);
caxis([0 5])
colorbar
hold on
x=Centre(:,1);y=Centre(:,2);
CellVertex=Bound4Cell;
for ind=1:(length(x)-1)
    c=ind2rgb(floor(FinalColorAllocation(ind)/5*64),cmap);
    patch(CellVertex{ind}(:,1),CellVertex{ind}(:,2),c);
    text(x(ind),y(ind),num2str(ind),'Color','red','FontSize',8);
end
axis([0 2500 0 1000])
axis manual

save FinalColorAllocation.mat FinalColorAllocation