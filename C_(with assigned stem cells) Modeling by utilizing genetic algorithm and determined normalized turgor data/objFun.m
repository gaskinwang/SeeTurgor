% function ObjectiveValue=objFun(MixGen,AddationImformation)
% ColorAllocation=GetColorAllocation(MixGen,AddationImformation);
% 
% ObjectiveValue=zeros(size(ColorAllocation,1),1);
% for ObjectiveValueMark=1:size(ColorAllocation,1)
%     Path=AddationImformation.Path;
%     for CellNum=1:size(ColorAllocation,2)
%         Path(Path==CellNum)=ColorAllocation(ObjectiveValueMark,CellNum);
%     end
%     
% end
% end



function ObjectiveValue=objFun(MixGen,AddationImformation)
ColorAllocation=GetColorAllocation(MixGen,AddationImformation);

ObjectiveValue=zeros(size(ColorAllocation,1),1);
simplehash=@(info)(sin(info(:,1))+cos(info(:,2))+tan(info(:,3))+...
        info(:,4)+info(:,5).^2+info(:,6).^3+info(:,7).^0.5);
right=simplehash(AddationImformation.Information);
for ObjectiveValueMark=1:size(ColorAllocation,1)
    
    ppap1=ColorAllocation(ObjectiveValueMark,:);
    Path=ppap1(AddationImformation.Path);
    InfoCountTemp=zeros(size(AddationImformation.InformationCount));    
    wrong=simplehash(Path);
    for InformationMark=1:size(right,1)
        InfoCountTemp(InformationMark)=sum(...
             AddationImformation.PathCount(wrong==right(InformationMark)));
    end
    ObjectiveValue(ObjectiveValueMark)=sum(abs(InfoCountTemp/sum(AddationImformation.PathCount)-...
        AddationImformation.InformationCount/sum(AddationImformation.InformationCount)));
end
end


