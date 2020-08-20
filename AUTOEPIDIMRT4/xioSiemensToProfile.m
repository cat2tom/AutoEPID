function profile_image_file_name=xioSiemensToProfile(xio_tps_file, epid_dicom_file,DTA,tol,pixel_dose_factor)


% read xio dose and grid information from xio dose file

 [xgrid,ygrid,tpsdose]=readXioDose(xio_tps_file);

% read EPID dose and grid information from the Simens EPID image
 [Ex,Ey,epiddose,gamma_image_name]=epidSiemensToDoseXio8(epid_dicom_file,pixel_dose_factor);
 
% Interpolate epid image over the xio dose grid
   
  epid_inter2=interp2(Ex,Ey,epiddose,xgrid,ygrid');
  
    
  [tpsrow tpscol]=find(tpsdose==max(tpsdose(:)));
  
  [epidrow,epidcol]=find(epid_inter2==max(epid_inter2(:)));
  
  Ex=Ex+(tpscol(1)-epidcol(1))*0.1;
  
  Ey=Ey+(tpsrow(1)-epidrow(1))*0.1;
  
  epid_inter=interp2(Ex,Ey,epiddose,xgrid,ygrid');
  
% Auto register two images.
  
  [output shiftedepid] = dftregistration(fft2(tpsdose),fft2(epid_inter),100);
  
 
 shiftedepid=abs(ifft2(shiftedepid));
  
 image1=tpsdose;
   
 image2=shiftedepid;
 hh=ImageCompare(image1,'TPS',image2,'EPID',xgrid',ygrid');

% set screen size for image capture 
 chl=hh;

 figure(chl);
 get(chl);
 set(chl,'Units','Pixel');
 position2=get(chl,'Position');
  
set(0,'Units','Pixel');
root_screen=get(0,'ScreenSize');


% use java to get the profile iamges
 robo = java.awt.Robot;
 t = java.awt.Toolkit.getDefaultToolkit();
rectangle = java.awt.Rectangle(position2(1),root_screen(4)-(position2(2)+position2(4)),position2(3),position2(4));
image5 = robo.createScreenCapture(rectangle);

gamma_result_file_name=['profile_' gamma_image_name '.jpg'];

profile_image_file_name=gamma_result_file_name;

filehandle = java.io.File(gamma_result_file_name);
javax.imageio.ImageIO.write(image5,'jpg',filehandle);
%imageview(gamma_result_file_name);
close(hh);
     