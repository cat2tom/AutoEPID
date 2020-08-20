function profile_image_file_name=pinElektaToProfile2b(pin_tps_file, epid_his_file,PSF,DTA,tol,pixel_dose_factor,coll_angle)

pin_tps_file='1201293_Beam_0_G0.0_C0.0-TotalDose.txt';

epid_his_file='Field_1.HIS';

pixel_dose_factor=0.0001045387;

PSF=0.04074;

coll_angle=0;

tol=0.03;

DTA=0.3;


% read Pinnacle dose and grid information from Pinnacle dose file

 [xgrid,ygrid,tpsdose]=readPinnacleDose3(pin_tps_file);

% read EPID dose and grid information from the Elekta EPID image

 [Ex,Ey,epiddose,beam_name2]=convertHisFileIntoImage4(epid_his_file,PSF,pixel_dose_factor);
 

 
 if coll_angle~=0
 
        epiddose=imrotate(epiddose,-coll_angle,'bilinear','crop');
  
  
 end 
 
% Interpolate epid image over the xio dose grid
   
  epid_inter2=interp2(Ex,Ey,epiddose,xgrid,ygrid');
  
    
  [tpsrow tpscol]=find(tpsdose==max(tpsdose(:)));
  
  [epidrow,epidcol]=find(epid_inter2==max(epid_inter2(:)));
  
  Ex=Ex+(tpscol(1)-epidcol(1))*0.1;
  
  Ey=Ey+(tpsrow(1)-epidrow(1))*0.1;
  
  epid_inter=interp2(Ex,Ey,epiddose,xgrid,ygrid');
  
% Auto register two images.
  
  [output shiftedepid] = dftregistration(fft2(tpsdose),fft2(epid_inter),200);
  
 
 shiftedepid2=abs(ifft2(shiftedepid));
 

 image1=tpsdose;
 
 image2=shiftedepid2;
   
if isnan(shiftedepid2)
    
    image2=epid_inter;
    
else
    image2=shiftedepid2;
    
end     
%  image2=shiftedepid2;
 
 
%  image2=epid_inter;
%  imshow(image1)
%  
%  imshow(image2)
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

gamma_image_name=beam_name2;

gamma_result_file_name=['pin_profile_' gamma_image_name '.jpg'];

profile_image_file_name=gamma_result_file_name;

filehandle = java.io.File(gamma_result_file_name);
javax.imageio.ImageIO.write(image5,'jpg',filehandle);
%imageview(gamma_result_file_name);
close(hh);
     