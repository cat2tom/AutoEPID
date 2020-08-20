function [profile_image_name,beam_name2]=pinSiemensToProfile(pin_tps_file, epid_dicom_file,DTA,tol,pixel_dose_factor)

% Function: 
% input:
% output:

% read the dose file from Pinnacle

 [xgrid,ygrid,tpsdose]=readPinnacleDose2(pin_tps_file);
 
% rotate the images

% tpsdose=imrotate(tpsdose,-180,'bilinear','loose');
 
%  Read EPID dose from Siemens machine

[Ex,Ey,epiddose,gamma_image_name,beam_name2]=epidSiemensToDoseXio8(epid_dicom_file,pixel_dose_factor);

epiddose=imrotate(epiddose,90,'bilinear','loose');
   
 % Interploate the EPID over TPS resolutions

  epid_inter=interp2(Ex,Ey,epiddose,xgrid,ygrid');
      

% Automatically registrar two images
  
  [output shiftedepid] = dftregistration(fft2(tpsdose),fft2(epid_inter),100);
  
  shiftedepid=abs(ifft2(shiftedepid));
  
% image(tpsdose*100)

hh=ImageCompare(tpsdose,'TPS', shiftedepid,'EPID',xgrid',ygrid');
  

%set the root screen

chl=hh;
figure(chl);
get(chl);
set(chl,'Units','Pixel');
position2=get(chl,'Position')
  
set(0,'Units','Pixel');
root_screen=get(0,'ScreenSize')


%  figure(hh);
robo = java.awt.Robot;
t = java.awt.Toolkit.getDefaultToolkit();
rectangle = java.awt.Rectangle(position2(1),root_screen(4)-(position2(2)+position2(4)),position2(3),position2(4));

image5 = robo.createScreenCapture(rectangle);

gamma_result_file_name=['Pin_profile_' gamma_image_name '.jpg'];

profile_image_name=gamma_result_file_name;

filehandle = java.io.File(gamma_result_file_name);
javax.imageio.ImageIO.write(image5,'jpg',filehandle);
%imageview(gamma_result_file_name);
close(hh);

     