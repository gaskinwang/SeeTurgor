function ColorAllocation=GetColorAllocation(MixGen,AddationImformation)
ColorAllocation=ceil(MixGen*5);

for temp=1:size(AddationImformation.KnownCellProproty,2)
    ColorAllocation(:,AddationImformation.KnownCellProproty(1,temp))=...
                 AddationImformation.KnownCellProproty(2,temp);
end


end