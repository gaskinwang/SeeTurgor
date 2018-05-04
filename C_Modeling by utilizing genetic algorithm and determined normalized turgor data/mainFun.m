clear all;close all;
load prepare.mat
% KnownCellProproty=[BoundaryCell;ones(size(BoundaryCell))];
% m1=find(BoundaryCell==7);
% m2=find(BoundaryCell==8);
% KnownCellProproty(2,[m1 m2])=4;
% AddationImformation.KnownCellProproty=KnownCellProproty;
AddationImformation.CellAmount=CellAmount;
AddationImformation.x=Centre(:,1);
AddationImformation.y=Centre(:,2);

GaStrategy.TribeSize=50;
GaStrategy.GenSize=CellAmount;
GaStrategy.AddationImformation=AddationImformation;
GaStrategy.DiasterCountDown=200;%-
GaStrategy.HighTribeMixMax=100;%-
GaStrategy.EvolutionYearMax=inf;%-
GaStrategy.TimeMax=10;
GaStrategy.MovieOn=true;
GaStrategy.MovieClearCountDown=[1000,1000];
BestGen=myga5(GaStrategy);
ColorAllocation=GetColorAllocation(BestGen,AddationImformation);


%可视化部分Visualization
figure
cmap=hsv();%颜色对应关系
colormap(cmap);
caxis([0 5])
colorbar
hold on
ColorAllocation(ColorAllocation==4)=0.5;
x=Centre(:,1);y=Centre(:,2);
for ttt = 1:CellAmount
c=ind2rgb(floor(ColorAllocation(ttt)/5*64),cmap);
patch(CellVertex{ttt}(:,1),CellVertex{ttt}(:,2),c);
text(x(ttt),y(ttt),num2str(ttt),'Color','red','FontSize',8);
end
axis([0 1000 0 800])
axis manual

save ColorAllocation.mat ColorAllocation
