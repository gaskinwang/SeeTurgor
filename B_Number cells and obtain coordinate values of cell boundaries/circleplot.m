function circleplot(x,y)
    R=13;
    theta=0:0.1:2*pi;
    xx=cos(theta)*R+x;
    yy=sin(theta)*R+y;
    plot(xx,yy,'b')
end