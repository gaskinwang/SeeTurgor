function FW(from,deep,direction)
global MeasureData;
global updata;
global MeasureMark
global Current_Way;
global Current_Ways;

%Confirm the current node
Current_Way(deep,:)=from;

%direction: 1 to the right and -1 to the left
if deep==7
    x=linspace(Current_Way(1,1),Current_Way(end,1),size(Current_Way,1));
    y=linspace(Current_Way(1,2),Current_Way(end,2),size(Current_Way,1));
    R1=corrcoef(x,Current_Way(:,1));
    R2=corrcoef(y,Current_Way(:,2));
    R=min(R1(1,2)^2,R2(1,2)^2);
    for tmp=1:size(Current_Ways,1)
        if isempty(Current_Ways{tmp,1})
            Current_Ways{tmp,1}=Current_Way;
            Current_Ways{tmp,2}=R;
            break
        end
    end
    return;
end

%horizontal
if from(2)+direction>=1&&from(2)+direction<=size(updata,2)&&updata(from(1),from(2)+direction)==MeasureData(MeasureMark,deep+1)
    FW([from(1),from(2)+direction],deep+1,direction)
end
%vertical
if from(2)+direction>=1&&updata(from(1)+1,from(2))==MeasureData(MeasureMark,deep+1)
    FW([from(1)+1,from(2)],deep+1,direction)
end
%horizontal + vertical
if from(2)+direction>=1&&from(2)+direction<=size(updata,2)&&updata(from(1)+1,from(2)+direction)==MeasureData(MeasureMark,deep+1)
    FW([from(1)+1,from(2)+direction],deep+1,direction)
end

end