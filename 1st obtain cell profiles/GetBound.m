clear;
Centre=xlsread('centre.xlsx');
save Centre.mat Centre
load Data2.mat
cirstep=0.01;
linstep=0.1;
linmax=100;
%--------------
% imshow(Data2)
hold on
% axis xy
%--------------

Bound4Cell=cell(size(Centre,1),1);
for num=1:size(Centre,1)
   BoundTmpMark=1;
   BoundTmp=zeros(500,2);
   for cir=0:cirstep:2*pi
      for lin=linstep:linstep:linmax
          pos=Centre(num,:)+[cos(cir),sin(cir)]*lin;
          tmppos=ceil([pos(2) pos(1)]);
          if Data2(tmppos(1),tmppos(2))==0;
              BoundTmp(BoundTmpMark,:)=pos;
              BoundTmpMark=BoundTmpMark+1;
              break% very important
          end
      end
   end
   BoundTmp=BoundTmp(1:(BoundTmpMark-1),:);
   hplot=plot(BoundTmp(:,1),BoundTmp(:,2));
   drawnow
   Bound4Cell{num}=BoundTmp;
end
save Bound4Cell.mat Bound4Cell