load prepare.mat
Data=xlsread('WT98.xlsx');
% �����Ǹ���ʵ�ʲ������ݽ��з������
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



%% ����infomation����

save prepare.mat

%��ʵ֤����Ӱ��Ч�ʵ���������ЩСϸ�ڣ������﷨��Ҳ��Ϊ����Щ����Ƶģ�Ϊ�˱�̸����������
