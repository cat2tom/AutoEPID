function profilegamma3

% img = imread('cameraman.tif');
% %Left/right
% s = size(img);
% shiftp = 30;
% img = img(:,mod((1:s(2))+s(2)+shiftp,s(2))+1);
% 
% %Up/Down
% img = img(mod((1:s(1))+s(1)+shiftp,s(1))+1,:);
% imagesc(img)


 [Ex,Ey,epiddose]=convertHisFileIntoImage2('2.HIS',0.0001045387);
 
%  epiddose
 
 imtool(epiddose)
 
 [xgrid,ygrid,tpsdose]=readPinnacleDose3('DosePlane_2.txt');
 
%  size(tpsdose)
%  
%  size(xgrid)
%  
%  size(ygrid)
%  
%  class(epiddose)
 
 
 
 imtool(tpsdose)
 
%  ygrid
%  class(Ey)
 
 class(epiddose)
%  figure
%  
%  image(tpsdose);

% [xgrid,ygrid,tpsdose]=readXioDose('1008982_F1_180.txt');
%  [Ex,Ey,epiddose]=epidSiemensToDoseXio8('F1_180_1.RTIMAGE.1.2.2012.03.23.17.55.16.171875.85275379.IMA'...
%          ,0.00005197);
% h=figure
% 
% image(epiddose,'XData',[-512,512],'YData',[-512,512]);

% print(h,'-dpdf','test.pdf');
% 
% print(h,'-dpdf' , '-append','test.pdf')
     
     
% shiftp = -100;
% 
% s=size(epiddose);
% epiddose = epiddose(:,mod((1:s(2))+s(2)+shiftp,s(2))+1);
%    size(Ey)

   
%     Ex=Ex+2.5
% %   
%     Ey=Ey+0.1
%      
% figure
% 
% image(tpsdose)

%    figure
%   
%   image(epiddose)
  
%   row=length(ygrid);
%   
%   col=length(xgrid);
%   
%   Ex=Ex*1024/row;
%   
%   
%   Ey=Ey*1024/col;
%   
%   Exx=((1:col)-col/2)*(Ex(2)-Ex(1));
%   
%   Eyy=((1:row)-row/2)*(Ey(2)-Ey(1));
%   
%   epid_inter=interp2(Ex,Ey,epiddose,xgrid,ygrid');
  
%   tx=(1:row)-0.5;
%   
%   ty=(1:col)-0.5;
% 
%   epid_inter2=imresize(epiddose,[row col]);
% %   
%   epid_inter=interp2(epiddose,tx,ty');
  
%   tps_inter=interp2(xgrid,ygrid,tpsdose,Ex,Ey);
  
%   epid_inter2=interp2(Ex,Ey,epiddose,xgrid,ygrid');
%   
%   
%   [tpsrow tpscol]=find(tpsdose==max(tpsdose(:)));
%   
%   [epidrow,epidcol]=find(epid_inter2==max(epid_inter2(:)));
  
%   Ex=Ex+(tpscol-epidcol)*0.1;
%   
%   Ey=Ey+(tpsrow-epidrow)*0.1;
  
   epid_inter=interp2(Ex,Ey,epiddose,xgrid,ygrid');
   
   size(epid_inter)
   
   size(tpsdose)
   
%    size(xgrid)
%    size(ygrid)
   
%    size(tpsdose)
  
    
%   figure
%   
%      
%   image(epid_inter)
%   
  
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


    
%   hh=ImageCompare(tpsdose,'tps',shiftedepid,'epid',xgrid',ygrid');
  
%   set(hh,'visible','off');
   
  
%   tmp=get(h)
%  
%   print(hh,'-dpdf','foo.pdf');

   image1=tpsdose;
   
   image2=shiftedepid;
   
   xp=xgrid;
   
   yp=ygrid;

   thresh=10;
   dosetol=3;
   
   dta=3;
    res_x = xp(2) - xp(1);
    res_y = yp(2) - yp(1);
    radius_cm = dta/10*1.5;
    thresh = thresh/100;
    dosetol = dosetol/100;
    dta = dta/10;       % Convert to cm
    rad_pix = min(ceil(radius_cm/res_x),ceil(radius_cm/res_y));
    [gmap,npass,gmean,ncheck] = Gamma(image1,image2,xp,yp,dosetol,dta,thresh,rad_pix);
    
    [h1 h2 h3 h4 h5] = EImage(gmap,[xp(1) xp(end)],[yp(1) yp(end)],'Title','Gamma Map', ...
                'xlabel', 'x (cm)', 'ylabel', 'y (cm)')
%      hplot = EImage(gmap,[xp(1) xp(end)],[yp(1) yp(end)],'Title','Gamma Map', ...
%                 'xlabel', 'x (cm)', 'ylabel', 'y (cm)')
                   
            
    cmap = [ 0,0,0.7; 0,0,0.7; 0,0,1; 0,1,0; 0.7,1,0.2; 0.8,0,0]; % no orange
    colormap(h1,cmap);
     caxis(h1,[0,1.2]);
    colorbar('peer',h1);
     
%     caxis(hplot,[0,1.2]);
%     colorbar('peer',hplot)
           
%     h=openfig('EImage.fig');
%     print(h,'-dpdf','ax.pdf');       
%    set(0,'unit','pixel');         
  % 
  
 chl=h5

 figure(chl);
 
 print(chl,'-dpdf','aitang.pdf');
 get(chl);
%  chl=gcf;
 set(chl,'Units','Pixel');
 position2=get(chl,'Position')
  
set(0,'Units','Pixel');
root_screen=get(0,'ScreenSize')
% set(hplot,'position',root_screen);

 
%  set(hh,'unit','pixel');
%  position2=get(chl,'Position')


  robo = java.awt.Robot;
  t = java.awt.Toolkit.getDefaultToolkit();  

rectangle = java.awt.Rectangle(position2(1),root_screen(4)-(position2(2)+position2(4)),position2(3),position2(4));
% rectangle = java.awt.Rectangle(t.getScreenSize());
image5 = robo.createScreenCapture(rectangle);
% image5 = robo.createScreenCapture(position2(1),position2(2),position2(3),position2(4));

filehandle = java.io.File('ax.jpg');
javax.imageio.ImageIO.write(image5,'jpg',filehandle);
imageview('ax.jpg');

     