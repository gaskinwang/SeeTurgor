clear
load prepare.mat

try
AllAvailablePath=[Path{1};
    Path{2};
    Path{3}];
catch
    AllAvailablePath=Path;
end


cmap=hsv();
alltext=findobj(gcf,'FontSize',8);
allface=findobj(gcf,'-not','FontSize',8);
for ind=1:length(alltext)
    if all(get(allface(ind+3),'facecolor')==cmap(floor(4/5*64),:));
        set(allface(ind+3),'facecolor',ind2rgb(floor(0.5/5*64),cmap))
    end
    set(alltext(ind),'HorizontalAlignment','center','color',1-get(allface(ind+3),'facecolor'));
end
x=Centre(:,1);y=Centre(:,2);
CellVertex=Bound4Cell;
%Visualization
Detectable=unique(AllAvailablePath(:));
NotDetectable=setdiff(1:(length(x)-1),Detectable);
for ind=NotDetectable
    c=[1 1 1];
    patch(CellVertex{ind}(:,1),CellVertex{ind}(:,2),c);
    text(x(ind),y(ind),num2str(ind),'Color',1-c,...
        'FontSize',8,'HorizontalAlignment','center');
end
width=max(x)-min(x);height=max(y)-min(y);
axis([min(x)-0.1*width max(x)+0.1*width min(y)-0.1*height max(y)+0.1*height])
axis manual
