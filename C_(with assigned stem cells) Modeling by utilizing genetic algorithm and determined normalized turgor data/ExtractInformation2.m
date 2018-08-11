
clear;close all;
load Data2.mat
load Centre.mat
load Bound4Cell.mat
Data=xlsread('WT98 0.5 modelling data.xlsx');
CellAmount=size(Bound4Cell,1);
CellVertex=Bound4Cell;%储存每个细胞的顶点信息

% see "C_Modeling by utilizing genetic algorithm and determined normalized
% turgor data" for notes and comments

BoundaryCell=1:11;%
BoundaryPos=zeros(length(BoundaryCell),2);
Path=zeros(10000,size(Data,2));%
Path_mark=1;
PathCount=zeros(10000,1);

% 
% hold on
% for ii=1:CellAmount
%     patch(CellVertex{ii}(:,1),CellVertex{ii}(:,2),[0 0.5 0]);
%     text(Centre(ii,1),Centre(ii,2),num2str(ii),'Color','red','FontSize',8);
% end
BouStep=5;
ScanStep=0.025;
DepthStep=10;
for bc=BoundaryCell
    disp(bc)
    %
    Left=zeros(1,2);
    Right=zeros(1,2);
    Extract=CellVertex{bc}(CellVertex{bc}(:,2)>mean(CellVertex{bc}(:,2)),:);
    [Left(1),LeftMark]  =min(Extract(:,1));
    [Right(1),RightMark]=max(Extract(:,1));
    Left(2) =Extract(LeftMark ,2);
    Right(2)=Extract(RightMark,2);
    boux=linspace(Left(1),Right(1),BouStep);
    bouy=linspace(Left(2),Right(2),BouStep);
    
    for bouMark=length(boux)%
        for Scan=0.01:ScanStep:2*pi%
            NowPath=zeros(1,size(Data,2));
            NowPath(1)=bc;
            NowPathMark=2;
            for Length=0:DepthStep:1000
                [nowx,nowy]=getPoint(boux(bouMark),bouy(bouMark),Scan,Length);
                for SearchCellNumber=1:CellAmount
                    [in,on]=inpolygon(nowx,nowy,CellVertex{SearchCellNumber}(:,1),CellVertex{SearchCellNumber}(:,2));
                    if in&&~on&&SearchCellNumber~=NowPath(NowPathMark-1)
                        NowPath(NowPathMark)=SearchCellNumber;
                        NowPathMark=NowPathMark+1;
                        break;
                    end
                end
                if NowPathMark>size(Data,2)
                    break
                end
            end
            %
            if NowPathMark>size(Data,2)
                Exist=false;
                for PreviousPath=1:(Path_mark-1)
                    if all(Path(PreviousPath,:)==NowPath)
                        Exist=true;
                        PathCount(PreviousPath)=PathCount(PreviousPath)+1;
                        break;
                    end
                end
                if ~Exist
                    Path(Path_mark,:)=NowPath;
                    PathCount(PreviousPath)=PathCount(PreviousPath)+1;
                    Path_mark=Path_mark+1;
                end           
            end
        end
    end
end
Path_remove_zero=find(Path(:,1)==0,1);
Path=Path(1:(Path_remove_zero-1),:);
PathCount=PathCount(1:(Path_remove_zero-1),:);
%
AddationImformation.Path=Path;
AddationImformation.PathCount=PathCount;


% 
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

AddationImformation.CellVertex=CellVertex;

%% 

save prepare.mat

%
