function profile_image_file_name=pinElektaToProfile2(pin_tps_file, epid_his_file,PSF,DTA,tol,pixel_dose_factor,coll_angle)


% read Pinnacle dose and grid information from Pinnacle dose file

 [xgrid,ygrid,tpsdose]=readPinnacleDose3(pin_tps_file);

% read EPID dose and grid information from the Elekta EPID image

 [Ex,Ey,epiddose,beam_name2]=convertHisFileIntoImage4(epid_his_file,PSF,pixel_dose_factor);
 
 if coll_angle~=0
 

        epiddose=imrotate(epiddose,-coll_angle,'nearest','loose');
        
        
         if coll_angle==90

           epiddose=fliplr(epiddose);
           
         end 
        
     
 end 
 
 %%  change to loose
 
 if coll_angle~=0 %  for choice of 'loose' in imrotate;
     
  % get new Ex and Ey for loose option 
  
  [newRow,newCol]=size(epiddose);
  
  Ex1=0;
  
  Ey1=0;
  
   
  if iseven(newRow)
  
  Ex1=-newRow/2:(newRow/2-1); % remove last one to make sure same size as epidose
  Ex1=-Ex1*(Ex(2)-Ex(1)); % time the resolution.
  
  
  Ey1=-newCol/2:(newCol/2-1);
  Ey1=Ey1*(Ey(2)-Ey(1));
  
  end 
  
  if isodd(newRow)
      
       Ex1=-(newRow-1)/2:(newRow-1)/2; % remove last one to make sure same size as epidose
       Ex1=Ex1*(Ex(2)-Ex(1)); % time the resolution.
  
       Ey1=-(newCol-1)/2:(newCol-1)/2;
       
       Ey1=Ey1*(Ey(2)-Ey(1));
      
  end 
  
 
 
  Ex=Ex1;
  
  Ey=Ey1;
   
 end % for choice for loose.
 
%%
 
 
 
% Interpolate epid image over the xio dose grid
   
  epid_inter2=interp2(Ex,Ey,epiddose,xgrid,ygrid');
  
    
  [tpsrow tpscol]=find(tpsdose==max(tpsdose(:)));
  
  [epidrow,epidcol]=find(epid_inter2==max(epid_inter2(:)));
  
  Ex=Ex+(tpscol(1)-epidcol(1))*0.1;
  
  Ey=Ey+(tpsrow(1)-epidrow(1))*0.1;
  

  
  epid_inter=interp2(Ex,Ey,epiddose,xgrid,ygrid','linear');
  
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
%  [tpsrow2, tpscol2]=find(image1==max(image1(:)));
%   
%  [epidrow2,epidcol2]=find(image2==max(image2(:)));
% 
%  shift=[-(tpsrow2(1)-epidrow2(1))/2,(tpscol2(1)-epidcol2(1))*2]
% %  shift=[0,160];
% %  
% %  shift=[8.5,14];
% 
% image2_shifted=imageTranslate(image2,shift);
% 
% image2=image2_shifted;


%%

  
 hh=ImageCompare(image1,'TPS',image2,'EPID',xgrid',ygrid');
 
 
% ###########################################################
% set screen size for image capture 
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
%imageview(gamma_result_file_name);

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
     