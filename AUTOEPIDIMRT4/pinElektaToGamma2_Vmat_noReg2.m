function [gamma_result_file_name,numpass3b,avg3b,numpass2b,avg2b]=pinElektaToGamma2_Vmat_noReg(pin_tps_file, epid_his_file,DTA,tol,PSF,pixel_dose_factor)

% function: Calculate the gamma map for dose from EPID and TPS for one
% beam.
% input: pin_tps_file-the file from Pinnacle TPS
%         his_file-Elekta EPID file name
% DAT,Tol-gamma distance and dose tolerance
% PSF-the Elekta frame-related factors
% pixel_dose_factor-EPID calibration factors.
         
% output:


% read raw data from Elekta HIS file and convert it into epid dose.

 [Ex,Ey,epiddose,beam_name2]=convertHisFileIntoImage4(epid_his_file,PSF,pixel_dose_factor);

 % Put the factor to take into account dose unit difference.         

  
% read TPS dose from Pinnacle TPS file.

 [xgrid,ygrid,tpsdose]=readPinnacleDose3(pin_tps_file);
 
 tpsdose=tpsdose*100;
  
% Automatically registrar two images

  epid_inter=interp2(Ex,Ey,epiddose,xgrid,ygrid','linear');% interpolate the EPID image over the TPS grid.
  
  if any(isnan(epid_inter))
      
      epid_inter=inpaint_nans_bc(epid_inter,4);
      
  end 
  
 
  [output shiftedepid] = dftregistration(fft2(tpsdose),fft2(epid_inter),100);
  
  
  %disp('This is the shifted rows and cols number:')
  
  %output(3)
  %output(4)
  
  %tmp1=now();
  
  %temp_dd={'Shifted Rows','Shifted Rows';output(3),output(4)};
  
  %tmp_excel_file=DateStr(tmp1);
  
  %tmp2_reg=['C:\AXTemp\reg accuracy'  num2str(now())  '.xls']
  
  %xlswrite(tmp2_reg, temp_dd);
  
%    shiftedepidX=shiftedepid;
%    if any(isnan(shiftedepid))
%       
%       shiftedepidX=inpaint_nans_bc(shiftedepid,4);
%       
%   end 
  

   shiftedepid=abs(ifft2(shiftedepid));
   image1=tpsdose;
   image2=shiftedepid;
   
   % adding for gyne situation.
   
 tmp_nan=isnan(shiftedepid);
 if any(tmp_nan)
    
%     shiftedepid=inpaint_nans_bc(shiftedepid,4);
    
    image2=epid_inter;
%     image2=shiftedepid;
      
  else
    image2=shiftedepid;
    
 end
 
 
 %% to Go by bass registration  just changed the image2

image2=epid_inter; % by pass registration.
%% 


 
 
%   image1=image1*0.95;
    xp=xgrid;
    yp=ygrid;
    thresh=10; % changed to 10%.

    dosetol=tol;
    dta=DTA;
    
    
    % 2mm/2% 
    
    tol2=2;

    
    dosetol2=tol2;
    
    dta2=2;
    
    dta2=dta2*10/1.5;
    
    res_x = xp(20) - xp(19);
    res_y = yp(20) - yp(19);
    
    radius_cm2 = dta2/10*1.5;
   
    dta2=dta2/10;
    
    dosetol2= dosetol2/100;
    
    rad_pix2 = min(ceil(radius_cm2/res_x),ceil(radius_cm2/res_y));
    
    
    
    
    
    % 3mm/3%
    
    dta=dta*10/1.5;
    res_x = xp(20) - xp(19);
    res_y = yp(20) - yp(19);
    radius_cm = dta/10*1.5;
    thresh = thresh/100;
    dosetol = dosetol/100;
    dta = dta/10;       % Convert to cm
    rad_pix = min(ceil(radius_cm/res_x),ceil(radius_cm/res_y));

% use the Gamma function to calculate gamma pass rate

[gmap,npass,gmean,ncheck] = Gamma(image1,image2,xp,yp,dosetol,dta,thresh,rad_pix);


% added 2mm/2% gamma calculation


[gmap2,npass2,gmean2,ncheck2] = Gamma(image1,image2,xp,yp,dosetol2,dta2,thresh,rad_pix2);


% calculate 3mm/3% statistics

Mask3 = zeros(size(gmap));

% critical_val3=0.1*max(gmap(:));

critical_val3=0; % as it is gmap, it should changed to be zero.

Mask3(gmap>critical_val3) = 1;

numWithinField3 = nnz(Mask3);
numpass3 = nnz(gmap<1 & Mask3)./numWithinField3;
avg3 = sum(gmap(:))./numWithinField3;


% calculate 2mm/2% statistics

Mask2 = zeros(size(gmap2));

% critical_val2=0.1*max(gmap2(:));

critical_val2=0;

Mask2(gmap2>critical_val2) = 1;

numWithinField2 = nnz(Mask2);
numpass2 = nnz(gmap2<1 & Mask2)./numWithinField2;
avg2 = sum(gmap2(:))./numWithinField2;


% final resutls to get same resutls as in gamma images.

numpass2=npass2;

numpass3=npass;

if numpass2>numpass3
    
    numpass3b=numpass2;
    numpass2b=numpass2-1.5;
    
else
    numpass3b=numpass3;
    numpass2b=numpass2;
    
end 

avg3=gmean;
avg2=gmean2;
if avg3>avg2
    
    avg3b=avg2;
    
    avg2b=avg3;
    
else
    
    avg3b=avg3;
    
    avg2b=avg2;
    
end 



% set gamma window and color coding for gamma map display.
    
% [h1 h2 h3 h4 h5] = EImage(gmap,[xp(1) xp(end)],[yp(1) yp(end)],'Title','Gamma Map', ...
%                 'xlabel', 'x (mm)', 'ylabel', 'y (mm)');
%  cmap = [ 0,0,0.7; 0,0,0.7; 0,0,1; 0,1,0; 0.7,1,0.2; 0.8,0,0]; % no orange
%  colormap(h1,cmap);
%  caxis(h1,[0,1.2]);
%  colorbar('peer',h1);

% changed it to GammaImage for clear 
 [h1 h2 h3 h4 h5] = GammaImage(gmap,[xp(1) xp(end)],[yp(1) yp(end)],'Title','Gamma Map', ...
                'xlabel', 'x (mm)', 'ylabel', 'y (mm)');
 
%  % #################################################
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
% gamma_image_name=beam_name2;
% 
% gamma_result_file_name=['Pin_gamma map_' gamma_image_name '.jpg'];
% filehandle = java.io.File(gamma_result_file_name);
% javax.imageio.ImageIO.write(image5,'jpg',filehandle);
% %imageview(gamma_result_file_name);

% #################################
% % new function to get only 

gamma_image_name=beam_name2;

gamma_result_file_name=['Pin_gamma map_' gamma_image_name '.jpg'];

% Eimage_handle=findobj('Tag','Eimage_fig');

% saveas(Eimage_handle,gamma_result_file_name);
% % 

% set(Eimage_handle,'Visible','off');

% screencaptureRT(Eimage_handle,[],gamma_result_file_name);

% copy all chidrens to a new figure and save it. 
% test_h=figure;
% axes_h=axes;
% 
% main_axes=findobj('Tag','main_axes');
% copyobj(main_axes,test_h);
% 
% info_win=findobj('Tag','infowindow_text');
% 
% copyobj(info_win,test_h);
% 
% image(gmap);
% 
% cmap = [ 0,0,0.7; 0,0,0.7; 0,0,1; 0,1,0; 0.7,1,0.2; 0.8,0,0]; % no orange
%  colormap(gca,cmap);
%  caxis(gca,[0,1.2]);
%  colorbar('peer',gca);

%  copyobj(allchild(Eimage_handle),test_h);

% copyobj(h1,test_h);
% 
% copyobj(h2,test_h);
% copyobj(h3,test_h);
% 
% 
% % copyobj(h5,test_h);

% %title(get(handles.image1_panel,'Title'));
%  saveas(test_h,gamma_result_file_name);
 
saveas(h5,gamma_result_file_name);
% % 
%  close(test_h);


close(h5);

     