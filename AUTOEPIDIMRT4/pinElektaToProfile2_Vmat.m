function profile_image_file_name=pinElektaToProfile2_Vmat(pin_tps_file, epid_his_file,PSF,DTA,tol,pixel_dose_factor)


% read Pinnacle dose and grid information from Pinnacle dose file

 [xgrid,ygrid,tpsdose]=readPinnacleDose3(pin_tps_file);
 
 tpsdose=tpsdose*100;

% read EPID dose and grid information from the Elekta EPID image

 [Ex,Ey,epiddose,beam_name2]=convertHisFileIntoImage4(epid_his_file,PSF,pixel_dose_factor);
 
 
% Interpolate epid image over the xio dose grid
   
  epid_inter2=interp2(Ex,Ey,epiddose,xgrid,ygrid');
  
    
  [tpsrow tpscol]=find(tpsdose==max(tpsdose(:)));
  
  [epidrow,epidcol]=find(epid_inter2==max(epid_inter2(:)));
  
  Ex=Ex+(tpscol(1)-epidcol(1))*0.1;
  
  Ey=Ey+(tpsrow(1)-epidrow(1))*0.1;
  
  epid_inter=interp2(Ex,Ey,epiddose,xgrid,ygrid','linear');
  
  
  epid_inter_opt=epid_inter;
  
  
  epid_inter2=epid_inter;
  
  if any(isnan(epid_inter))
      
      epid_inter=inpaint_nans_bc(epid_inter,4);
      
  end 
  
%Auto register two images.
  
  [output shiftedepid] = dftregistration(fft2(tpsdose),fft2(epid_inter),100);
  
 
 shiftedepid=abs(ifft2(shiftedepid));
  
 image1=tpsdose;
   
 image2=shiftedepid;
 
%  % adding for gyne situation.
%  
   tmp_nan=isnan(shiftedepid);
   
if any(tmp_nan)

    image2=epid_inter;
    
             
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




%% shift optimization option.


optimization_obj=findobj('tag','shift_optimization');

value=get(optimization_obj,'value');

shift_optimization=value;

if  shift_optimization

     
    ref_image=tpsdose;
    
    tar_image=epid_inter_opt;
    
    
    [shifted_tar_image,opt_x_shift,opt_y_shift] = optimizeImageRegistration(ref_image,tar_image );
    
    
    
    image2=shifted_tar_image;
     
%      
%      extended_epiddose= extendEPID(ref_image,shifted_tar_image ); 
%      
% 
%      image2= extended_epiddose;
%  
 
end 
%%

  
 hh=ImageCompare(image1,'TPS',image2,'EPID',xgrid',ygrid');
 
% % #################################################
% % set screen size for image capture 
%  chl=hh;
% 
%  figure(chl);
%  get(chl);
%  set(chl,'Units','Pixel');
%  position2=get(chl,'Position');
%   
% set(0,'Units','Pixel');
% root_screen=get(0,'ScreenSize');
% 
% 
% % use java to get the profile iamges
%  robo = java.awt.Robot;
%  t = java.awt.Toolkit.getDefaultToolkit();
% rectangle = java.awt.Rectangle(position2(1),root_screen(4)-(position2(2)+position2(4)),position2(3),position2(4));
% image5 = robo.createScreenCapture(rectangle);
% 
% gamma_image_name=beam_name2;
% 
% gamma_result_file_name=['pin_profile_' gamma_image_name '.jpg'];
% 
% profile_image_file_name=gamma_result_file_name;
% 
% filehandle = java.io.File(gamma_result_file_name);
% javax.imageio.ImageIO.write(image5,'jpg',filehandle);
% %imageview(gamma_result_file_name);

% ##################################################################

gamma_image_name=beam_name2;

gamma_result_file_name=['pin_profile_' gamma_image_name '.jpg'];

profile_image_file_name=gamma_result_file_name;

% get the profile handle
profile_image_handle=findobj('Tag','ImageCompare_fig');


% screencaptureRT(profile_image_handle,[],profile_image_file_name);

% copy all chidrens to a new figure and save it. 
test_h=figure;
set(test_h,'Visible','off');

axes;
copyobj(allchild(profile_image_handle),test_h);
%title(get(handles.image1_panel,'Title'));
saveas(test_h,profile_image_file_name);

close(test_h);






close(hh);
     