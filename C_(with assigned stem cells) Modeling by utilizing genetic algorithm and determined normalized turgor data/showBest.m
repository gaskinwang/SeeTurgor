function showBest(BestGen,AddationImformation)
global add_axis
global cmap
global h_patchs
global h_texts
ColorAllocation=GetColorAllocation(BestGen,AddationImformation);
if isempty(add_axis)
%     Widen=0.12;
    figure();
    add_axis=gca();
    cmap=hsv();%
    colormap(cmap);
    caxis([0 5])
    colorbar
    hold on
    axis([0 2500 0 1000])
    axis manual
end

delete(h_patchs)
delete(h_texts)
for ttt = 1:AddationImformation.CellAmount
    c=ind2rgb(floor(ColorAllocation(ttt)/5*64),cmap);
    h_patchs(ttt)=patch(add_axis,AddationImformation.CellVertex{ttt}(:,1),AddationImformation.CellVertex{ttt}(:,2),c);
    h_texts(ttt)=text(add_axis,AddationImformation.x(ttt),AddationImformation.y(ttt),num2str(ttt),'Color','red','FontSize',8);
end
end