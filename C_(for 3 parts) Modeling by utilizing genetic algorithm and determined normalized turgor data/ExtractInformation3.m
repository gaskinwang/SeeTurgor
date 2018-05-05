%����Ԥ�����õ�ÿ��ϸ�������б߽�
load Centre.mat%����ϸ������
load Bound4Cell.mat%����ϸ���߽�
Measurement=xlsread('WT98 1+ 0.5 modelling data.xlsx');%����ԭʼ������Ϣ
AllBoundary=1:23;%��֯ϸ�������Ե
Path=cell(1,3);
PathCount=cell(1,3);
for se=1:3%��֯ϸ����Ϊ3��
    select=xlsread('select.xlsx',se);
    CurBoundary=intersect(AllBoundary,select);
    Path{se}=zeros(10000,size(Measurement,2));%����·����ȡ���ܶȲ���20180427gaskinע��
    Path_mark=1;
    PathCount{se}=zeros(10000,1);
    
    BouStep=5;
    ScanStep=0.025;
    DepthStep=10;
    for bc=CurBoundary'
        disp(bc)
        %��������ʵĵ�̽������
        Left=zeros(1,2);
        Right=zeros(1,2);
        Extract=Bound4Cell{bc}(Bound4Cell{bc}(:,2)>mean(Bound4Cell{bc}(:,2)),:);
        [Left(1),LeftMark]  =min(Extract(:,1));
        [Right(1),RightMark]=max(Extract(:,1));
        Left(2) =Extract(LeftMark ,2);
        Right(2)=Extract(RightMark,2);
        boux=linspace(Left(1),Right(1),BouStep);
        bouy=linspace(Left(2),Right(2),BouStep);
        
        AvoidEmpty=50;ae=0;
        for bouMark=length(boux)%���ڱ߽�ϸ���ϵ���ɢ�ĵ�
            for Scan=0.01:ScanStep:2*pi%����ÿһ��ɨ��Ƕ�
                NowPath=zeros(1,size(Measurement,2));
                NowPath(1)=bc;
                NowPathMark=2;
                ae=0;
                for Length=0:DepthStep:1000
                    findcell=false;
                    [nowx,nowy]=getPoint(boux(bouMark),bouy(bouMark),Scan,Length);
                    for SearchCellNumber=select'
                        [in,on]=inpolygon(nowx,nowy,Bound4Cell{SearchCellNumber}(:,1),Bound4Cell{SearchCellNumber}(:,2));
                        if in&&~on
                           findcell=true; 
                        end
                        if in&&~on&&SearchCellNumber~=NowPath(NowPathMark-1)
                            NowPath(NowPathMark)=SearchCellNumber;
                            NowPathMark=NowPathMark+1;
                            break;
                        end
                    end
                    
                    if findcell==false
                        ae=ae+DepthStep;
                        if ae>AvoidEmpty
                            break
                        end
                    else
                        ae=0;
                    end
                    if NowPathMark>size(Measurement,2)
                        break
                    end
                end
                %�ҵ������ϸ��
                if NowPathMark>size(Measurement,2)
                    Exist=false;
                    for PreviousPath=1:(Path_mark-1)
                        if all(Path{se}(PreviousPath,:)==NowPath)
                            Exist=true;
                            PathCount{se}(PreviousPath)=PathCount{se}(PreviousPath)+1;
                            break;
                        end
                    end
                    if ~Exist
                        Path{se}(Path_mark,:)=NowPath;
                        PathCount{se}(PreviousPath)=PathCount{se}(PreviousPath)+1;
                        Path_mark=Path_mark+1;
                    end
                end
            end
        end
    end
    Path_remove_zero=find(Path{se}(:,1)==0,1);
    Path{se}=Path{se}(1:(Path_remove_zero-1),:);
    PathCount{se}=PathCount{se}(1:(Path_remove_zero-1),:);
end
save prepare.mat
Refresh

%��ʵ֤����Ӱ��Ч�ʵ���������ЩСϸ�ڣ������﷨��Ҳ��Ϊ����Щ����Ƶģ�Ϊ�˱�̸����������
