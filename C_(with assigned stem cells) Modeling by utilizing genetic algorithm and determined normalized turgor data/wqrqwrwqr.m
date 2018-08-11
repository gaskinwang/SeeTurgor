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
axis([0 2500 0 1000])
axis manual