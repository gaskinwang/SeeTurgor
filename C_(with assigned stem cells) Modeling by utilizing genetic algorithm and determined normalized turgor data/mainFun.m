clear all;close all;
load prepare.mat
KnownCellProproty=[BoundaryCell;ones(size(BoundaryCell))];
m1=find(BoundaryCell==5);
m2=find(BoundaryCell==6);
KnownCellProproty(2,[m1 m2])=4;
AddationImformation.KnownCellProproty=KnownCellProproty;
AddationImformation.CellAmount=CellAmount;
AddationImformation.x=Centre(:,1);
AddationImformation.y=Centre(:,2);



GaStrategy.TribeSize=50;
GaStrategy.GenSize=CellAmount;
GaStrategy.AddationImformation=AddationImformation;
GaStrategy.DiasterCountDown=200;%-
GaStrategy.HighTribeMixMax=100;%-
GaStrategy.EvolutionYearMax=inf;%-
GaStrategy.TimeMax=1;
GaStrategy.MovieOn=true;
GaStrategy.MovieClearCountDown=[1000,1000];
BestGen=myga5(GaStrategy);
ColorAllocation=GetColorAllocation(BestGen,AddationImformation);
%
figure
cmap=hsv();%
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

% axis([0.2-Widen 1+Widen 0-Widen 0.9+Widen])
axis([0 1800 0 1200])
axis manual
