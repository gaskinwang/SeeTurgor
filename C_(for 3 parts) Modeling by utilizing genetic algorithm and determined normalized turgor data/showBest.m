function showBest(BestGen,AddationImformation)
global add_axis
global cmap

ColorAllocation=GetColorAllocation(BestGen,AddationImformation);
if isempty(add_axis)
%     Widen=0.12;
    figure();
    add_axis=gca();
    cmap=hsv();%颜色对应关系
    colormap(cmap);
    caxis([0 5])
    colorbar
    hold on
    axis([0 2500 0 1000])
    axis manual
end
h_patchs_and_text=findobj(add_axis,'tag','toDelete');
delete(h_patchs_and_text)

for Path4Divide = 1:length(AddationImformation.selection)
    c=ind2rgb(floor(ColorAllocation(Path4Divide)/5*64),cmap);
    Path4AllCell=AddationImformation.selection(Path4Divide);
    patch(add_axis,AddationImformation.CellVertex{Path4AllCell}(:,1),...
        AddationImformation.CellVertex{Path4AllCell}(:,2),c,'tag','toDelete');
    text(add_axis,AddationImformation.x(Path4AllCell),AddationImformation.y(Path4AllCell),...
        num2str(Path4AllCell),'Color','red','FontSize',8,'tag','toDelete');
end
end