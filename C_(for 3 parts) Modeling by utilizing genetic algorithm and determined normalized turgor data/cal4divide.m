% small program cal for divide
visualization;
clear;
points=ginput(2);
fun=@(x,y,points)(sign((points(2,2)-points(1,2))/(points(2,1)-points(1,1)))*...
    ((points(2,2)-points(1,2))/(points(2,1)-points(1,1))*(x-points(1,1))-(y-points(1,2))));
load Centre.mat
plot(points(:,1),points(:,2))
result1=fun(Centre(:,1),Centre(:,2),points);
points=ginput(2);
plot(points(:,1),points(:,2))
result2=fun(Centre(:,1),Centre(:,2),points);
select{1}=find((result1<0)&(result2<0));
select{2}=find((result1>0)&(result2<0));
select{3}=find((result1>0)&(result2>0));
for ii=1:3
    xlswrite('select.xlsx',select{ii},ii)
end
save select.mat select



