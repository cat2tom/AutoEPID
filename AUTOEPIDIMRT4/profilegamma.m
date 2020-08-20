function profilegamma

[xgrid,ygrid,tpsdose]=readXioDose('1008982_F1_180.txt');

 [Ex,Ey,epiddose]=epidSiemensToDoseXio6('F1_180_1.RTIMAGE.1.2.2012.03.23.17.55.16.171875.85275379.IMA'...
         ,0.00005093);
     
  Exx=((1:1024)-512)*0.3;
  
  Eyy=((1:1024)-512)*0.3;
  
  
  epid_inter3=interp2(Ex,Ey,epiddose,Exx,Eyy');
  
  image(epid_inter3)

%   test=size(Ex)
  row=length(ygrid);
  
  col=length(xgrid);
  
%   epiddose=imresize(epiddose,[row  col]);
  
  [rowrange, colrange,choppedEx,choppedEy]=matchLength(Ex,Ey,col,row);
  
  
  
  tmp2=length(rowrange);
  
  tmp3=colrange;
  
   
  tmp_epiddose=epiddose(rowrange,colrange);
  
  size(tmp_epiddose)
  
%   Ex=choppedEx;
%   
%   size(Ex)
%   
%   size(Ey)
%   
%   size(epidose)
%   
%   Ey=choppedEy;
  
  epiddose4=imresize(epiddose,[row col]);
  
  tpsdose2=imresize(tpsdose,[1024 1024]);
  
  [output shiftedepid] = dftregistration(fft2(tpsdose2),fft2(epiddose),100);
  
 
%   image(shiftedepid)
%   
%   image(tpsdose)
  
  shiftedepid=abs(ifft2(shiftedepid));
  
  shiftedepid=interp2(Ex,Ey,shiftedepid,xgrid,ygrid');
%   
%   tps_max=max(tpsdose(:));
%   
%   epid_max=max(shiftepid(:));
%   
%   shiftepid=shiftepid.*(tps_max/epid_max);
%   
%   epid_inter2=interp2(choppedEx,choppedEy,shiftepid,xgrid,ygrid');
  
  ImageCompare(tpsdose,'tps',shiftedepid,'epid',xgrid',ygrid');
     