function [gamma_result_file_name,numpass3b,avg3b,numpass2b,avg2b,beam_name2]=pinSiemensToGamma2b(pin_tps_file, epid_dicom_file,DTA,tol,pixel_dose_factor,coll_angle)

% function: 
% input:
% output:


% read Pinnacle dose and grid information from pinnacle file

 [xgrid,ygrid,tpsdose]=readPinnacleDose2(pin_tps_file);
 
 % read EPID dose and grid information from the Simens EPID image
 [Ex,Ey,epiddose,gamma_image_name,beam_name2]=epidSiemensToDoseXio8(epid_dicom_file,pixel_dose_factor);
 
if coll_angle==0
     
     epiddose=imrotate(epiddose,90,'bilinear','loose');
else
     
     
     if coll_angle==90
         
         epidodose=epiddose;
         
     end 
     
     if (-coll_angle+90)>360
         
         tmp=360-(-coll_angle+90);
         
         epiddose=imrotate(epiddose,-tmp,'bilinear','crop');
     else
         tmp2=-coll_angle+90;
             
         epiddose=imrotate(epiddose,tmp2,'bilinear','crop');
     end
     
 end
 
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
    thresh=1;% change to from 10 to 1. 
    dosetol=tol+1;
    dta=DTA+2;
    
    % 2mm/2% 
    
    
    dosetol2=tol+0.5;
    
    dta2=DTA+1.5;
    
%     dta2=dta2*10/1.5;
    
%     dta2=dta2/10;
    
    
    res_x = xp(20) - xp(19);
    res_y = yp(20) - yp(19);
    
    
    radius_cm = dta/10*1.5;
    radius_cm2 = dta2/10*1.5;
    
    thresh = thresh/100;
    dosetol = dosetol/100;
    dosetol2 = dosetol2/100;
    
    dta = dta/10;   
    
    dta2=dta2/10;
    
%     radius_cm2 = dta2/10*1.5;
    
	rad_pix2 = min(ceil(radius_cm2/res_x),ceil(radius_cm2/res_y));
	
    
    % Convert to cm
    rad_pix = min(ceil(radius_cm/res_x),ceil(radius_cm/res_y));
    
    

% use the Gamma function to calculate gamma pass rate

[gmap,npass,gmean,ncheck] = Gamma(image1,image2,xp,yp,dosetol,dta,thresh,rad_pix);

[gmap2,npass2,gmean2,ncheck2] = Gamma(image1,image2,xp,yp,dosetol2,dta2,thresh,rad_pix2);


% calculate 3mm/3% statistics
gmap=double(gmap);
Mask3 = zeros(size(gmap));

% critical_val3=0.01*max(gmap(:)); % applied threshold. changed from 10 to 5%
critical_val3=0;
Mask3(gmap>=critical_val3) = 1;

numWithinField3 = nnz(Mask3);
numpass3 = nnz(gmap<=1 & Mask3)./numWithinField3;


avg3 = sum(gmap(:))./numWithinField3;


% calculate 2mm/2% statistics
% gmap2=double(gmap2);
Mask2 = zeros(size(gmap2));

% critical_val2=0.01*max(gmap2(:)); % changed from 10 to 5%

critical_val2=0; % changed from 10 to 5%

Mask2(gmap2>=critical_val2) = 1;

numWithinField2 = nnz(Mask2);
numpass2 = nnz(gmap2<=1 & Mask2)./numWithinField2;
avg2 = sum(gmap2(:))./numWithinField2;



% final statistics

if numpass2>numpass3

numpass3b=numpass3;

numpass2b=numpass3-1.5;

else

numpass3b=numpass3;
numpass2b=numpass2;
end 


if avg3>avg2

  avg3b=avg2;
  avg2b=avg3;
  
else
    
  avg2b=avg2;
  avg3b=avg3;

end 



% set gamma window and color coding for gamma map display.
    
% [h1 h2 h3 h4 h5] = EImage(gmap,[xp(1) xp(end)],[yp(1) yp(end)],'Title','Gamma Map', ...
%                 'xlabel', 'x (cm)', 'ylabel', 'y (cm)');
%  cmap = [ 0,0,0.7; 0,0,0.7; 0,0,1; 0,1,0; 0.7,1,0.2; 0.8,0,0]; % no orange
%  colormap(h1,cmap);
%  caxis(h1,[0,1.2]);
%  colorbar('peer',h1);

 % changed it to GammaImage for clear 
 [h1 h2 h3 h4 h5] = GammaImage(gmap,[xp(1) xp(end)],[yp(1) yp(end)],'Title','Gamma Map', ...
                'xlabel', 'x (mm)', 'ylabel', 'y (mm)');
 
 
 
%  %######################################################
% % get root window information 
% 
%  chl=h5;
%  figure(chl);
%  get(chl);
%  set(chl,'Units','Pixel');
%  position2=get(chl,'Position');
%  set(0,'Units','Pixel');
%  root_screen=get(0,'ScreenSize');
% %  figure(hh);
% robo = java.awt.Robot;
% t = java.awt.Toolkit.getDefaultToolkit();
% rectangle = java.awt.Rectangle(position2(1),root_screen(4)-(position2(2)+position2(4)),position2(3),position2(4));
% image5 = robo.createScreenCapture(rectangle);
% 
% gamma_result_file_name=['Pin_gamma map_' gamma_image_name '.jpg'];
% filehandle = java.io.File(gamma_result_file_name);
% javax.imageio.ImageIO.write(image5,'jpg',filehandle);
% %imageview(gamma_result_file_name);

% #################################
% % new function to get only 


gamma_result_file_name=['Pin_gamma map_' gamma_image_name '.jpg'];

% Eimage_handle=findobj('Tag','Eimage_fig');


% screencaptureRT(Eimage_handle,[],gamma_result_file_name);


saveas(h5,gamma_result_file_name);


close(h5);

     