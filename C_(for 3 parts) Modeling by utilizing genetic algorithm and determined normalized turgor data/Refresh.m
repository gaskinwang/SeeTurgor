load prepare.mat
Data=xlsread('WT98.xlsx');
% 这里是根据实际测量数据进行分类汇总
Data(Data==0.5)=4;
Information=zeros(10000,size(Data,2));
Information_mark=0;
InformationCount=zeros(10000,1);
for Mark4Data=1:size(Data,1)
    Exist=false;
    for NowInformation_mark=1:Information_mark
        if all(Information(NowInformation_mark,:)==Data(Mark4Data,:))
            Exist=true;
            break;
        end
    end
    if Exist==true
        InformationCount(NowInformation_mark,:)=InformationCount(NowInformation_mark,:)+1;
    else
        Information_mark=Information_mark+1;
        Information(Information_mark,:)=Data(Mark4Data,:);
        InformationCount(Information_mark,:)=1;
    end
end
Information_remove_zero=find(Information(:,1)==0,1);
Information=Information(1:(Information_remove_zero-1),:);
InformationCount=InformationCount(1:(Information_remove_zero-1),:);
Information(Information==0.5)=4;
AddationImformation.Information=Information;
AddationImformation.InformationCount=InformationCount;



%% 插入infomation即可

save prepare.mat

%事实证明，影响效率的往往是那些小细节，所以语法糖也是为了这些而设计的，为了编程更加清楚明了
