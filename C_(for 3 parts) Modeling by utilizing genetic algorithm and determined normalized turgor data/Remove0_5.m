function [Info_,InfoCount_]=...
    Remove0_5(Info,InfoCount)
inds=zeros(1000,1);
inds_mark=1;
for ind=1:size(Info,1)
    if any(Info(ind,:)==4)
        inds(inds_mark)=ind;
        inds_mark=inds_mark+1;
    end
end
inds=inds(1:(inds_mark-1));
Info_=Info;Info_(inds,:)=[];
InfoCount_=InfoCount;InfoCount_(inds,:)=[];
end