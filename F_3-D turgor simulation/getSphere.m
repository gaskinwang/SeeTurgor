function [xx,yy,zz]=getSphere(a,b,c,r,boundary_of_x)
max_Y=rand()*pi/4;
max_X=rand()*pi/4;
theta1=rand()*max_Y;
theta2=rand()*max_X;
[fia,theta]=meshgrid(linspace(0,2*pi,20),linspace(0,pi,10));
zz=sin(theta).*cos(fia);
yy=sin(theta).*sin(fia);
xx=cos(theta);

tmpresult=[xx(:),yy(:),zz(:)]*[cos(theta1) 0 -sin(theta1);0 1 0;sin(theta1) 0 cos(theta1)];
tmpresult=tmpresult*[1 0 0;0 cos(theta2) sin(theta2);0 -sin(theta2) cos(theta2)];
xx=reshape(tmpresult(:,1),size(zz,1),size(zz,2));
yy=reshape(tmpresult(:,2),size(zz,1),size(zz,2));
zz=reshape(tmpresult(:,3),size(zz,1),size(zz,2));

zz=zz*r+c;
yy=yy*r+b;
xx=xx*boundary_of_x+a;
end