function ColorAllocation=GetColorAllocation(MixGen,AddationImformation)
ColorAllocation=ceil(MixGen*5);
if AddationImformation.se==2
    ColorAllocation(:,AddationImformation.Known(1,:))=...
               repmat(AddationImformation.Known(2,:),size(ColorAllocation,1),1);
end


end