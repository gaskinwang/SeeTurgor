
%   Input£º 
%   In the file Data2.xlsx, sheet1 is the presupposed turgor arragment data of 
%                           stack-A while sheet2 is that of stack-B; 
%                           sheet 3 is the measured, normalized turgor data
%                           for inserting into stack-A, while sheet 4 is that 
%                           data for inserting into stack-B.
%                           
%                          

%Data reading and initialization
clear;close all;
updata=xlsread('Data2',1);%data for Top(i.e., stack-A)
sidedata=xlsread('Data2',2);%data for Side (i.e., stack-B)
h_fig=figure();
scrsz = get(0,'ScreenSize');
set(h_fig,'Position',scrsz)%full screen display
[fia,theta]=meshgrid(linspace(-pi,pi,20),linspace(0,pi/2,20));
xx=sin(theta).*cos(fia);
yy=sin(theta).*sin(fia);
zz=cos(theta);
h_surf=surf(xx,yy,zz);%Semi-ellipsoid
axis([-1.2 1.2 -1.2 1.2 -0.2 1.2]);
axis equal
cmap=hsv();%color
colormap(cmap);
caxis([0 10])
h_colorbar=colorbar();%bar
set(h_surf,'EdgeColor',[1 0.5 0],'EdgeAlpha',1,'FaceColor','none','FaceAlpha',0.1);
set(h_fig,'Color',[0.494 0.494 0.494]);
set(gca,'Visible','Off');
view(-87,-2.8);
hold on;

Up_Layer_Centre=cell(7,8);%Separately store (x y z) of each layer of stack-A
boundary_of_x=0.06;%width of stack-A
theta_range=pi*(1/8);
x_range=-boundary_of_x:0.01:boundary_of_x;%radian range of stack-A
cos_theta=cos(linspace(pi/2-theta_range,pi/2+theta_range,9));
r_change_step=0.5/8;%thickness of each layers of stack-A
Down_step=r_change_step*1.1;%distence of going down steps of layers 

x_grid_ori=repmat(x_range,length(cos_theta),1);
y_grid_ori=sqrt(1-x_grid_ori.^2).*repmat(cos_theta',1,length(x_range));
z_grid_ori=sqrt(1-x_grid_ori.^2-y_grid_ori.^2);
yy_grid_ori=sqrt((1-r_change_step)^2-x_grid_ori.^2).*repmat(cos_theta',1,length(x_range));
zz_grid_ori=sqrt((1-r_change_step)^2-x_grid_ori.^2-y_grid_ori.^2);


%Get the handle of each cell in each layer of stack A
Up_Layer_Patch=cell(7,8);
for LayerNum=1:2
    for ymark=1:8
        x_grid=x_grid_ori(ymark:ymark+1,:);
        y_grid=y_grid_ori(ymark:ymark+1,:);
        z_grid=z_grid_ori(ymark:ymark+1,:);
        yy_grid=yy_grid_ori(ymark:ymark+1,:);
        zz_grid=zz_grid_ori(ymark:ymark+1,:);
        
        x_grid=[x_grid(1,:);x_grid;x_grid(end,:)];
        y_grid=[y_grid(1,:);y_grid;y_grid(end,:)];
        z_grid=[z_grid(1,:);z_grid;z_grid(end,:)];
        yy_grid=[y_grid(1,:);yy_grid;y_grid(end,:)];
        zz_grid=[z_grid(1,:);zz_grid;z_grid(end,:)];
        
        x_final=[x_grid,fliplr(x_grid),x_grid(:,1)];
        y_final=[y_grid,fliplr(yy_grid),y_grid(:,1)];
        z_final=[z_grid,fliplr(zz_grid),z_grid(:,1)];
        Up_Layer_Patch{LayerNum,ymark}=surf(x_final,y_final,z_final-Down_step*(LayerNum-1));
        Up_Layer_Centre{LayerNum,ymark}=[0,mean(y_final(:)),mean(z_final(:))-Down_step*(LayerNum-1)+0.017];
    end
end
R=1-r_change_step*0.95;
smallMove=theta_range/8;
C_y=R*cos(linspace(pi/2-theta_range+smallMove,pi/2+theta_range-smallMove,8));
C_z=R*sin(linspace(pi/2-theta_range+smallMove,pi/2+theta_range-smallMove,8));
for down=3:7
    for t=1:8
        [x,y,z]=getSphere(0,C_y(t)+mod(down,2)*0.02,C_z(t)-r_change_step*1.1*3-r_change_step*1.35*(down-4),r_change_step*0.95,boundary_of_x);
        Up_Layer_Patch{down,t}=surf(x,y,z);
        Up_Layer_Centre{down,t}=[0,C_y(t)+mod(down,2)*0.02,C_z(t)-r_change_step*1.1*3-r_change_step*1.35*(down-4)+0.02];
    end
end
%-------------------------------------------------------------------------------------------------------
%The processing of stack B is similar to that of stack A. Same annotations are omitted here.
theta1=-pi/4;%Rotation angle around Y axis
theta2=-pi/4;%Rotation angle around X axis

Side_Layer_Centre=cell(7,10);
boundary_of_x=0.06;
theta_range=pi*(1/8);
x_range=-boundary_of_x:0.01:boundary_of_x;
cos_theta=cos(linspace(pi/2-theta_range,pi/2+theta_range,11));
r_change_step=0.5/8;
Down_step=r_change_step*1.1;

x_grid_ori=repmat(x_range,length(cos_theta),1);
y_grid_ori=sqrt(1-x_grid_ori.^2).*repmat(cos_theta',1,length(x_range));
z_grid_ori=sqrt(1-x_grid_ori.^2-y_grid_ori.^2);
yy_grid_ori=sqrt((1-r_change_step)^2-x_grid_ori.^2).*repmat(cos_theta',1,length(x_range));
zz_grid_ori=sqrt((1-r_change_step)^2-x_grid_ori.^2-y_grid_ori.^2);



Side_Layer_Patch=cell(7,10);
for LayerNum=1:2
    for ymark=1:10
        x_grid=x_grid_ori(ymark:ymark+1,:);
        y_grid=y_grid_ori(ymark:ymark+1,:);
        z_grid=z_grid_ori(ymark:ymark+1,:);
        yy_grid=yy_grid_ori(ymark:ymark+1,:);
        zz_grid=zz_grid_ori(ymark:ymark+1,:);
        
        x_grid=[x_grid(1,:);x_grid;x_grid(end,:)];
        y_grid=[y_grid(1,:);y_grid;y_grid(end,:)];
        z_grid=[z_grid(1,:);z_grid;z_grid(end,:)];
        yy_grid=[y_grid(1,:);yy_grid;y_grid(end,:)];
        zz_grid=[z_grid(1,:);zz_grid;z_grid(end,:)];
        
        x_final=[x_grid,fliplr(x_grid),x_grid(:,1)];
        y_final=[y_grid,fliplr(yy_grid),y_grid(:,1)];
        z_final=[z_grid,fliplr(zz_grid),z_grid(:,1)];
        %-------------
        tmpresult=[x_final(:),y_final(:),z_final(:)-Down_step*(LayerNum-1)]*[cos(theta1) 0 -sin(theta1);0 1 0;sin(theta1) 0 cos(theta1)];
        tmpresult=tmpresult*[1 0 0;0 cos(theta2) sin(theta2);0 -sin(theta2) cos(theta2)];
        aa=reshape(tmpresult(:,1),size(x_final,1),size(x_final,2));
        bb=reshape(tmpresult(:,2),size(x_final,1),size(x_final,2));
        cc=reshape(tmpresult(:,3),size(x_final,1),size(x_final,2));
        %-------------
        Side_Layer_Patch{LayerNum,ymark}=surf(aa,bb,cc);
        Side_Layer_Centre{LayerNum,ymark}=[mean(aa(:)),mean(bb(:)),mean(cc(:))];
    end
end

R=1-r_change_step*0.95;
smallMove=theta_range/8;
C_y=R*cos(linspace(pi/2-theta_range+smallMove,pi/2+theta_range-smallMove,10));
C_z=R*sin(linspace(pi/2-theta_range+smallMove,pi/2+theta_range-smallMove,10));
for down=3:7
    for t=1:10
        [x,y,z]=getSphere(0,C_y(t)+mod(down,2)*0.02,C_z(t)-r_change_step*1.1*3-r_change_step*1.35*(down-4),r_change_step*0.95,boundary_of_x);
        z=z+0.15;
        %-------------
        tmpresult=[x(:),y(:),z(:)-Down_step*(LayerNum-1)]*[cos(theta1) 0 -sin(theta1);0 1 0;sin(theta1) 0 cos(theta1)];
        tmpresult=tmpresult*[1 0 0;0 cos(theta2) sin(theta2);0 -sin(theta2) cos(theta2)];
        aa=reshape(tmpresult(:,1),size(x,1),size(x,2));
        bb=reshape(tmpresult(:,2),size(x,1),size(x,2));
        cc=reshape(tmpresult(:,3),size(x,1),size(x,2));
        %-------------        
        Side_Layer_Patch{down,t}=surf(aa,bb,cc);
        Side_Layer_Centre{down,t}=[mean(aa(:)),mean(bb(:)),mean(cc(:))];
    end
end






% Fill the read data into above two stacks with color lines
c=ind2rgb(floor(updata/10*64),cmap);
for LayerNum=1:2
    for ymark=1:8
        set(Up_Layer_Patch{LayerNum,ymark},'FaceColor',c(LayerNum,ymark,:),'FaceAlpha',0.5,'EdgeColor',[0.25 0.25 0.25],'EdgeAlpha',0.3,'meshstyle','row');
    end
end
for LayerNum=3:7
    for ymark=1:8
        set(Up_Layer_Patch{LayerNum,ymark},'FaceColor',c(LayerNum,ymark,:),'FaceAlpha',0.5,'EdgeColor',[0.25 0.25 0.25],'EdgeAlpha',0);
    end
end


c=ind2rgb(floor(sidedata/10*64),cmap);
for LayerNum=1:2
    for ymark=1:10
        set(Side_Layer_Patch{LayerNum,ymark},'FaceColor',c(LayerNum,ymark,:),'FaceAlpha',0.5,'EdgeColor',[0.25 0.25 0.25],'EdgeAlpha',0.3,'meshstyle','row');
    end
end
for LayerNum=3:7
    for ymark=1:10
        set(Side_Layer_Patch{LayerNum,ymark},'FaceColor',c(LayerNum,ymark,:),'FaceAlpha',0.5,'EdgeColor',[0.25 0.25 0.25],'EdgeAlpha',0);
    end
end



Ways=FindWays3();
for n=1:size(Ways,1)
    From=Ways{n}(1,:);
    To=Ways{n}(7,:);
    X_random_change=(rand(1,2)-0.5)*boundary_of_x/2;
    Y_random_change=(rand(1,2)-0.5)*0.02;
    Z_random_change=(rand(1,2)-0.5)*0.003;
    h_line=line( [Up_Layer_Centre{From(1),From(2)}(1)+X_random_change(1),Up_Layer_Centre{To(1),To(2)}(1)+X_random_change(2)],...
                    [Up_Layer_Centre{From(1),From(2)}(2)+Y_random_change(1),Up_Layer_Centre{To(1),To(2)}(2)+Y_random_change(2)],...
                    [Up_Layer_Centre{From(1),From(2)}(3)+Z_random_change(1),Up_Layer_Centre{To(1),To(2)}(3)+Z_random_change(2)]);
    set(h_line,'Linewidth',1.5,'color',ind2rgb(floor(rand(1)*64),cmap));
end

Ways=FindWays4();
for n=1:size(Ways,1)
    From=Ways{n}(1,:);
    To=Ways{n}(7,:);
    X_random_change=(rand(1,2)-0.5)*boundary_of_x/2;
    Y_random_change=(rand(1,2)-0.5)*0.02;
    Z_random_change=(rand(1,2)-0.5)*0.003;
    h_line=line( [Side_Layer_Centre{From(1),From(2)}(1)+X_random_change(1),Side_Layer_Centre{To(1),To(2)}(1)+X_random_change(2)],...
                 [Side_Layer_Centre{From(1),From(2)}(2)+Y_random_change(1),Side_Layer_Centre{To(1),To(2)}(2)+Y_random_change(2)],...
                 [Side_Layer_Centre{From(1),From(2)}(3)+Z_random_change(1),Side_Layer_Centre{To(1),To(2)}(3)+Z_random_change(2)]);
    set(h_line,'Linewidth',1.5,'color',ind2rgb(floor(rand(1)*64),cmap));
end



