function profilegamma2

 [xgrid,ygrid,tpsdose]=readXioDose('1008982_F1_180.txt');

 [Ex,Ey,epiddose]=epidSiemensToDoseXio7('F1_180_1.RTIMAGE.1.2.2012.03.23.17.55.16.171875.85275379.IMA'...
         ,0.00005297);

 
%    Ex'
%    
%    Ey'
%    
   size(Ey)
%   Ex=Ex+3
%   
%   Ey=Ey;
%      
figure

image(tpsdose)

figure
  
  image(epiddose)
  
  row=length(ygrid);
  
  col=length(xgrid);
  
  Ex=Ex*1024/row;
  
  
  Ey=Ey*1024/col;
  
  Exx=((1:col)-col/2)*(Ex(2)-Ex(1));
  
  Eyy=((1:row)-row/2)*(Ey(2)-Ey(1));
  
%   epid_inter=interp2(Ex,Ey,epiddose,xgrid,ygrid');
  
%   tx=(1:row)-0.5;
%   
%   ty=(1:col)-0.5;
% 
  epid_inter2=imresize(epiddose,[row col]);
%   
%   epid_inter=interp2(epiddose,tx,ty');
  
%   tps_inter=interp2(xgrid,ygrid,tpsdose,Ex,Ey);
  
  epid_inter=interp2(Exx,Eyy,epid_inter2,xgrid,ygrid');
  h=figure
  
     
  image(epid_inter)
  
  
%   figure
%   image(epiddose)

%   test=size(Ex)
%   row=length(ygrid)
%   
%   col=length(xgrid)
%   
%   epiddose=imresize(epiddose,[row  col]);
%   
%   [choppedEx,choppedEy]=matchLength(Ex,Ey,col,row);
%   
%   Ex=choppedEx;
%   
%   size(Ex)
%   
%   size(Ey)
%   
%   size(epidose)
%   
%   Ey=choppedEy;
  
% figure
% 
% image(epid_inter)

% image(tps_inter)
  
  [output shiftedepid] = dftregistration(fft2(tpsdose),fft2(epid_inter),100);
  
%   [output shiftedepid] = dftregistration(fft2(epiddose),fft2(tps_inter),100);
  
  
  shiftedepid=abs(ifft2(shiftedepid));
  
%   figure 
%   image(shiftedepid)

  
%   shiftedepid=imresize(shiftedepid,[row,col]);
  
%   ratio=double(tpsdose./shiftedepid);
  
%   tps_max=max(tpsdose(:));
%   
%   epid_max=max(shiftepid(:));
%   
%   shiftepid=shiftepid.*(tps_max/epid_max);
  
%    shiftepid=shiftepid*mean(ratio(:));
  
%   epid_inter2=interp2(Ex,Ey,shiftepid,xgrid,ygrid');
%   ImageCompare(epiddose,'epid',tps_inter,'tps',xgrid',ygrid');
  ImageCompare(tpsdose,'tps',shiftedepid,'epid',xgrid',ygrid');
     