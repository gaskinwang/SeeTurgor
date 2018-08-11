function [nowx,nowy]=getPoint(basex,basey,Scan,Depth)
nowx=basex+cos(Scan)*Depth;
nowy=basey+sin(Scan)*Depth;
end