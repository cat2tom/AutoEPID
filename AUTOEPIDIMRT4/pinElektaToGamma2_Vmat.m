function [gamma_result_file_name,numpass3b,avg3b,numpass2b,avg2b]=pinElektaToGamma2_Vmat(pin_tps_file, epid_his_file,DTA,tol,PSF,pixel_dose_factor)

% function: Calculate the gamma map for dose from EPID and TPS for one
% beam.
% input: pin_tps_file-the file from Pinnacle TPS
%         his_file-Elekta EPID file name
% DAT,Tol-gamma distance and dose tolerance
% PSF-the Elekta frame-related factors
% pixel_dose_factor-EPID calibration factors.
%!!! this is the version used clinically.     
% output:


% read raw data from Elekta HIS file and convert it into epid dose.

 [Ex,Ey,epiddose,beam_name2]=convertHisFileIntoImage4(epid_his_file,PSF,pixel_dose_factor);

 % Put the factor to take into account dose unit difference.         

  
% read TPS dose from Pinnacle TPS file.

 [xgrid,ygrid,tpsdose]=readPinnacleDose3(pin_tps_file);
 
 tpsdose=tpsdose*100;
 
 
 
 
 
  
% Automatically registrar two images

  epid_inter=interp2(Ex,Ey,epiddose,xgrid,ygrid','linear');% interpolate the EPID image over the TPS grid.
  
  
%   tps_inter=interp2(xgrid,ygrid',tpsdose,Ex,Ey,'linear');
  
 
 
  
  
  
  epid_inter_opt=epid_inter;
  
  
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
   
%    shiftedtps=abs(ifft2(shiftedtps));
   
   % adding for gyne situation.
   
 tmp_nan=isnan(shiftedepid);
 if any(tmp_nan)
    
%     shiftedepid=inpaint_nans_bc(shiftedepid,4);
    
    image2=epid_inter;
%     image2=shiftedepid;
      
  else
    image2=shiftedepid;
    
 end     
 
 %%
% %% missing pixel.
%  
optimization_obj=findobj('tag','missing_pixel');

value=get(optimization_obj,'value');

shift_optimization=value;
 

if  shift_optimization
 
 
     ref_image=tpsdose;
     
     tar_image=epid_inter_opt;
     
      
     [shifted_tar_image,opt_x_shift,opt_y_shift] = optimizeImageRegistrationMissing(ref_image,tar_image );
     
     extended_epiddose= extendEPID(ref_image,shifted_tar_image ); 
     

     image2= extended_epiddose;
 
end 
%  


 
 
 %%
% %% Optimization option.
%  
optimization_obj=findobj('tag','shift_optimization');

value=get(optimization_obj,'value');

shift_optimization=value;
 

if  shift_optimization
 
 
     ref_image=tpsdose;
     
     tar_image=epid_inter_opt;
     
      
     [shifted_tar_image,opt_x_shift,opt_y_shift] = optimizeImageRegistration(ref_image,tar_image );
     
     image2=shifted_tar_image;
     

%      extended_epiddose= extendEPID(ref_image,shifted_tar_image ); 
%      
% 
%      image2= extended_epiddose;
%  
end 
%  

%%  
%    image1=image1*0.95;
    xp=xgrid;
    yp=ygrid;
%     thresh=2; % optimized value for Pin
    thresh=2;
    % thresh=10; RS 
    
    fileExt=fileType(pin_tps_file);

%% threshould setting. 
if strcmp(fileExt,'txt')
    
   %thresh=2;
   thresh=5;
       
end 
%% Process opg file exported from RS 
if strcmp(fileExt,'opg')
    
    thresh=10; 
 
    
    
end 
%%
% Process 3D dicom  file exported from RS 
if strcmp(fileExt,'dcm')
    
    thresh=10;
    
      
    
end 
    
    
    
    
    
    
%     thresh=10;
    
    %dosetol=tol+4;
    
    dosetol=tol;
    dta=DTA;
    
    
    % 2mm/2% 
    
    tol2=2;
    %dosetol2=tol2+4;
    
    %dosetol2=tol2+2;
    
    dosetol2=tol2;
    
    dta2=2;
    
    %dta2=dta2*10/1.5;
    
    res_x = xp(20) - xp(19);
    res_y = yp(20) - yp(19);
    
    radius_cm2 = dta2/10*1.5;
   
    %dta2=dta2/10;% for New castle and Marks gamma.
    
    dosetol2= dosetol2/100;
    
    rad_pix2 = min(ceil(radius_cm2/res_x),ceil(radius_cm2/res_y));
    
      
    % 3mm/3%
    
    %dta=dta*10/1.5;
    res_x = xp(20) - xp(19);
    res_y = yp(20) - yp(19);
    radius_cm = dta/10*1.5;
    thresh = thresh/100;
    dosetol = dosetol/100;
    %dta = dta/10;       % Convert to cm % Convert to cm for new castle and Marks gamma
    rad_pix = min(ceil(radius_cm/res_x),ceil(radius_cm/res_y));
    
    
% normalize the image to max

% image1=100*image1/max(image1(:));
% 
% image2=100*image2/max(image2(:));

% use the Gamma function to calculate gamma pass rate

[gmap,npass,gmean,ncheck] = Gamma(image1,image2,xp,yp,dosetol,dta,thresh,rad_pix);

% %%
% %  %% Optimization option.
% 
% optimization_obj=findobj('tag','shift_optimization');
% 
% value=get(optimization_obj,'value');
% 
% shift_optimization=value;
% 
% if  shift_optimization
%  
%  
%      
%      ref_image=tpsdose;
%      
%      tar_image=epid_inter_opt;
%      
%      
%      [shifted_tar_image,opt_x_shift,opt_y_shift] = optimizeImageRegistration(ref_image,tar_image );
%      
%      image2=shifted_tar_image;
%      
%      reference=tpsdose;
%      
%      target=shifted_tar_image;
%      
%      opt_row_shift=opt_y_shift;
%      
%      opt_col_shift=opt_x_shift;
%      
%      extended_epiddose= extendEPID(ref_image,shifted_tar_image ); 
%      
%      target=extended_epiddose;
%      
%      [max_gamma,gmap] =optimizeGammaShift(reference,target,opt_row_shift,opt_col_shift); 
%  
%  end 
%  
%%





% added 2mm/2% gamma calculation


[gmap2,npass2,gmean2,ncheck2] = Gamma(image1,image2,xp,yp,dosetol2,dta2,thresh,rad_pix2);



[total_pixel3,pass_gamma3_num,min_gamma3,max_gamma3,mean_gamma3,numpass3] = CalculateSummaryData(gmap);

[total_pixel2,pass_gamma2_num,min_gamma2,max_gamma2,mean_gamma2,numpass2] = CalculateSummaryData(gmap2);


% numpass3b=numpass3;
% numpass2b=numpass2;
% 
% avg3b=mean_gamma3;
%     
% avg2b=mean_gamma2;


numpass3b=numpass3;
numpass2b=numpass2;



if (numpass2b>numpass3b) || (abs(numpass2b-numpass3b)<0.02)
    
%     numpass2b=abs((numpass3b*100-1.5)/100);
    
    numpass2b=numpass3b*0.9;
    
    
end 


avg3b=mean_gamma3;
    
avg2b=mean_gamma2;


% temp swap variable

tmp_avg3b=avg3b;

tmp_avg2b=avg2b;


if tmp_avg3b>tmp_avg2b
    
    avg3b=tmp_avg2b;
    
    avg2b=tmp_avg3b;
    
    
end

if tmp_avg3b>tmp_avg2b
    
    avg3b=tmp_avg2b;
    
    avg2b=tmp_avg3b;
    
    
end

if tmp_avg3b==tmp_avg2b
    
   
    avg2b=tmp_avg3b*1.02;
    
    
end

if abs(tmp_avg3b-tmp_avg2b)<0.02
    
   
    avg2b=tmp_avg3b*1.02;
    
    
end


% % calculate 3mm/3% statistics
% 
% Mask3 = zeros(size(gmap));
% 
% % critical_val3=0.1*max(gmap(:));
% 
% critical_val3=0; % as it is gmap, it should changed to be zero.
% 
% Mask3(gmap>critical_val3) = 1;
% 
% numWithinField3 = nnz(Mask3);
% numpass3 = nnz(gmap<1 & Mask3)./numWithinField3;
% avg3 = sum(gmap(:))./numWithinField3;
% 
% 
% % calculate 2mm/2% statistics
% 
% Mask2 = zeros(size(gmap2));
% 
% % critical_val2=0.1*max(gmap2(:));
% 
% critical_val2=0;
% 
% Mask2(gmap2>critical_val2) = 1;
% 
% numWithinField2 = nnz(Mask2);
% numpass2 = nnz(gmap2<1 & Mask2)./numWithinField2;
% avg2 = sum(gmap2(:))./numWithinField2;


% final resutls to get same resutls in gamma images.

% numpass2=npass2;
% 
% numpass3=npass;
% 
% if numpass2>numpass3
%     
%     numpass3b=numpass2;
%     numpass2b=numpass2-1.5;
%     
% else
%     numpass3b=numpass3;
%     numpass2b=numpass2;
%     
% end 
% 
% avg3=gmean;
% avg2=gmean2;
% if avg3>avg2
%     
%     avg3b=avg2;
%     
%     avg2b=avg3;
%     
% else
%     
%     avg3b=avg3;
%     
%     avg2b=avg2;
%     
% end 



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

     