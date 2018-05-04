function Ways=FindWays4()
global MeasureData;
global updata;
global MeasureMark
global Current_Way;
global Current_Ways;
global BestWayLog;%Implementation of this function requires that each record from data2.xlsx to be unique
%Data reading and initialization
updata=xlsread('Data2',2);%data for Top(i.e., stack-A)
MeasureData=xlsread('Data2',4);%measured data
Current_Way=zeros(7,2);%Record current path

Current_Ways=cell(5000,3);%Record all solutions, their R2 and occurrences
BestWayLog=cell(size(MeasureData,1),2);%Record all optimal solutions and their occurrences



Ways=cell(size(MeasureData,1),1);
for MeasureMark=1:size(MeasureData,1)
    for mark=1:length(updata(1,:))%The default here is definitely to insert from the first layer (L1)
        if updata(1,mark)==MeasureData(MeasureMark,1)
            FW([1,mark],1,1);
            FW([1,mark],1,-1);
        end
    end
    %Query the optimal solution record
    for tmp2=1:size(Current_Ways,1)
        if isempty(Current_Ways{tmp2,1})
            break
        end
        for tmp=1:size(BestWayLog,1)
            if isempty(BestWayLog{tmp,1})
                Current_Ways{tmp2,3}=0;
                break;
            end
            if isequal(BestWayLog{tmp,1},Current_Ways{tmp2,1})
                Current_Ways{tmp2,3}=BestWayLog{tmp,2};
                break;
            end
        end
    end
    %Select the appropriate optimal solution
    Times=cell2mat(Current_Ways(:,3));
    [~,Times_mark]=sort(Times);
    Current_Ways=Current_Ways(Times_mark,:);
    Times=cell2mat(Current_Ways(:,3));
    Extract=Current_Ways(Times==Times(1),:);
    [~,sort_mark_by_R]=sort(cell2mat(Extract(:,2)));
    sort_mark_by_R=sort_mark_by_R(end:-1:1);
    Current_Ways(Times==Times(1),:)=Extract(sort_mark_by_R,:);
    Ways{MeasureMark}=Current_Ways{1,1};
    %Write record
    for tmp=1:size(BestWayLog,1)
        if isempty(BestWayLog{tmp,1})
            BestWayLog{tmp,1}=Ways{MeasureMark};
            BestWayLog{tmp,2}=1;
            break;
        end
        if isequal(BestWayLog{tmp,1},Ways{MeasureMark})
            BestWayLog{tmp,2}=BestWayLog{tmp,2}+1;
            break;
        end
    end
    %Empty solution space
    Current_Ways=cell(5000,3);
end
end