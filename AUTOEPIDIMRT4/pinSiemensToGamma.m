function [gamma_result_file_name,beam_name2]=pinSiemensToGamma(pin_tps_file, epid_dicom_file,DTA,tol,pixel_dose_factor)

% function: 
% input:
% output:


% read Pinnacle dose and grid information from pinnacle file

 [xgrid,ygrid,tpsdose]=readPinnacleDose2(pin_tps_file);
 
 % read EPID dose and grid information from the Simens EPID image
 [Ex,Ey,epiddose,gamma_image_name,beam_name2]=epidSiemensToDoseXio8(epid_dicom_file,pixel_dose_factor);
 
 epiddose=imrotate(epiddose,90,'bilinear','loose');
 
 
%   epiddose=epidose.*(mean(tpsdose)/mean(epiddose));
  
  % interpolate the EPID dose image over the TPS grids.
 
  epid_inter=interp2(Ex,Ey,epiddose,xgrid,ygrid');
  
% Automatically registrar two images
 
  [output shiftedepid] = dftregistration(fft2(tpsdose),fft2(epid_inter),100);

   shiftedepid=abs(ifft2(shiftedepid));
   image1=tpsdose;
   image2=shiftedepid;
   
%    image1=tpsdose.*(mean(image2/image1));
   
   xp=xgrid;
    yp=ygrid;
    thresh=5;
    dosetol=tol;
    dta=DTA;
    res_x = xp(20) - xp(19);
    res_y = yp(20) - yp(19);
    radius_cm = dta/10*1.5;
    thresh = thresh/100;
    dosetol = dosetol/100;
    dta = dta/10;       % Convert to cm
    rad_pix = min(ceil(radius_cm/res_x),ceil(radius_cm/res_y));

% use the Gamma function to calculate gamma pass rate

[gmap,npass,gmean,ncheck] = Gamma(image1,image2,xp,yp,dosetol,dta,thresh,rad_pix);

% set gamma window and color coding for gamma map display.
    
[h1 h2 h3 h4 h5] = EImage(gmap,[xp(1) xp(end)],[yp(1) yp(end)],'Title','Gamma Map', ...
                'xlabel', 'x (cm)', 'ylabel', 'y (cm)')
 cmap = [ 0,0,0.7; 0,0,0.7; 0,0,1; 0,1,0; 0.7,1,0.2; 0.8,0,0]; % no orange
 colormap(h1,cmap);
 caxis(h1,[0,1.2]);
 colorbar('peer',h1);

% get root window information 

 chl=h5
 figure(chl);
 get(chl);
 set(chl,'Units','Pixel');
 position2=get(chl,'Position');
 set(0,'Units','Pixel');
 root_screen=get(0,'ScreenSize');
%  figure(hh);
robo = java.awt.Robot;
t = java.awt.Toolkit.getDefaultToolkit();
rectangle = java.awt.Rectangle(position2(1),root_screen(4)-(position2(2)+position2(4)),position2(3),position2(4));
image5 = robo.createScreenCapture(rectangle);

gamma_result_file_name=['Pin_gamma map_' gamma_image_name '.jpg'];
filehandle = java.io.File(gamma_result_file_name);
javax.imageio.ImageIO.write(image5,'jpg',filehandle);
%imageview(gamma_result_file_name);

close(h5);

     