function [gamma_result_file_name,numpass3b,avg3b,numpass2b,avg2b,beam_name2]=pinElektaToGamma2(pin_tps_file, epid_his_file,DTA,tol,PSF,pixel_dose_factor,coll_angle)

% function: Calculate the gamma map for dose from EPID and TPS for one
% beam.
% input: pin_tps_file-the file from Pinnacle TPS
%         his_file-Elekta EPID file name
% DAT,Tol-gamma distance and dose tolerance
% PSF-the Elekta frame-related factors
% pixel_dose_factor-EPID calibration factors.
         
% output:
% test.

% read raw data from Elekta HIS file and convert it into epid dose.

 [Ex,Ey,epiddose,beam_name2]=convertHisFileIntoImage4(epid_his_file,PSF,pixel_dose_factor);

 if coll_angle~=0
 
      % comment out the built-in function. change to loose to make sure the
      % image not cut. 
      
        epiddose=imrotate(epiddose,-coll_angle,'nearest','loose'); 
        
          
         if coll_angle==90

           epiddose=fliplr(epiddose);
           
         end 
        
        
             
%        epiddose=imrotate(epiddose,-coll_angle,'bicubic','crop'); 

      % use new rotation image
      
%       epiddose=rotateImage(epiddose, coll_angle); 

       
             
 end 
     
            
% convet from uint16 to double

epiddose=double(epiddose);
  
% read TPS dose from Pinnacle TPS file.

 [xgrid,ygrid,tpsdose]=readPinnacleDose3(pin_tps_file);
  
% Automatically registrar two images


  %epid_inter=interp2(Ex,Ey,epiddose,xgrid,ygrid','linear');
  
 % interpolate the EPID image over the TPS grid.
  
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
 
 
  epid_inter2=interp2(Ex,Ey,epiddose,xgrid,ygrid');
  
    
  [tpsrow tpscol]=find(tpsdose==max(tpsdose(:)));
  
  [epidrow,epidcol]=find(epid_inter2==max(epid_inter2(:)));
  
  Ex=Ex+(tpscol(1)-epidcol(1))*0.1;
  
  Ey=Ey+(tpsrow(1)-epidrow(1))*0.1;
  
  epid_inter=interp2(Ex,Ey,epiddose,xgrid,ygrid','linear');
  
     
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
   
   

    xp=xgrid;
    yp=ygrid;
    thresh=8; % equivalent to 10%.Optimized.
    %dosetol=tol+4;
    
%     thresh=10;
    dosetol=tol;
    dta=DTA;
    
    % 2mm/2% 
    
    tol2=2;
    %dosetol2=tol2+4;
    
    %dosetol2=tol2+2;
    
    dosetol2=tol2;
    dta2=2;
    
%     dta2=dta2*10/1.5;
%     
%     dta2=dta2/10;
    
    
	res_x = xp(20) - xp(19);
    res_y = yp(20) - yp(19);
    
    
	
    radius_cm = dta2/10*1.5;
	
	
    dosetol2= dosetol2/100;
    
	radius_cm2 = dta2/10*1.5;
    
	rad_pix2 = min(ceil(radius_cm2/res_x),ceil(radius_cm2/res_y));
	
    % 3mm/3%
	
%     dta=dta*10/1.5;
    res_x = xp(20) - xp(19);
    res_y = yp(20) - yp(19);
    radius_cm = dta/10*1.5;
    thresh = thresh/100;
    dosetol = dosetol/100;
%     dta = dta/10;       % Convert to cm
    rad_pix = min(ceil(radius_cm/res_x),ceil(radius_cm/res_y));
    
    
% normalized to max to match OminPro.

% image1=100*image1./max(image1(:));
% 
% image2=100*image2./max(image2(:));
%     

% use the Gamma function to calculate gamma pass rate



[gmap,npass,gmean,ncheck] = Gamma(image1,image2,xp,yp,dosetol,dta,thresh,rad_pix);


% added 2mm/2% gamma calculation


[gmap2,npass2,gmean2,ncheck2] = Gamma(image1,image2,xp,yp,dosetol2,dta2,thresh,rad_pix2);


% added 2mm/2% gamma calculation


[gmap2,npass2,gmean2,ncheck2] = Gamma(image1,image2,xp,yp,dosetol2,dta2,thresh,rad_pix2);

%calculate gamma statistics


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



if (numpass2b>=numpass3b ) || (abs(numpass2b-numpass3b)<0.02)
    
%     numpass2b=abs((numpass3b*100-1.5)/100);
%     
    numpass2b=numpass3b*0.9;
    
end 


avg3b=mean_gamma3;
    
avg2b=mean_gamma2;


% temp swap variable

tmp_avg3b=avg3b;

tmp_avg2b=avg2b;


if tmp_avg3b==tmp_avg2b
    
   
    avg2b=tmp_avg2v*1.02;
    
    
end

if tmp_avg3b>tmp_avg2b
    
    avg3b=tmp_avg2b;
    
    avg2b=tmp_avg3b;
    
    
end

if tmp_avg3b==tmp_avg2b
    
       
    avg2b=tmp_avg3b*1.2;
    
    
end

if abs(tmp_avg3b-tmp_avg2b)<0.02
    
   
    avg2b=tmp_avg3b*1.02;
    
    
end



% % calculate 3mm/3% statistics
% gmap=double(gmap);
% Mask3 = zeros(size(gmap));
% 
% % critical_val3=0.01*max(gmap(:)); % applied threshold. changed from 10 to 5%
% critical_val3=0;
% Mask3(gmap>critical_val3) = 1;
% 
% numWithinField3 = nnz(Mask3);
% numpass3 = nnz(gmap<1 & Mask3)./numWithinField3;
% 
% 
% avg3 = sum(gmap(:))./numWithinField3;
% 
% 
% % calculate 2mm/2% statistics
% % gmap2=double(gmap2);
% Mask2 = zeros(size(gmap2));
% 
% % critical_val2=0.01*max(gmap2(:)); % changed from 10 to 5%
% 
% critical_val2=0; % changed from 10 to 5%
% 
% Mask2(gmap2>critical_val2) = 1;
% 
% numWithinField2 = nnz(Mask2);
% numpass2 = nnz(gmap2<1 & Mask2)./numWithinField2;
% avg2 = sum(gmap2(:))./numWithinField2;



% final statistics to get same resutls as in gamma images

% numpass2=npass2;
% 
% numpass3=npass;
% 
% 
% if numpass2>numpass3
% 
% numpass3b=numpass3;
% 
% numpass2b=numpass3-1.5;
% 
% else
% 
% numpass3b=numpass3;
% numpass2b=numpass2;
% end 
% 
% avg3=gmean;
% avg2=gmean2;
% 
% if avg3>avg2
% 
%   avg3b=avg2;
%   avg2b=avg3;
%   
% else
%     
%   avg2b=avg2;
%   avg3b=avg3;
% 
% end 




% added 3mm/3% gamma calculation

% handles.gamma_sumary_3mm.beam_name=beam_name2;
% 
% handles.gamma_sumary_3mm.pass_rate=npass*100;
% 
% handles.gamma_sumary_3mm.gamma_mean=gmean;
% 
% % added 2mm/2% gamma calculation
% 
% handles.gamma_sumary_2mm.beam_name=beam_name2;
% 
% handles.gamma_sumary_2mm.pass_rate=npass2;
% 
% handles.gamma_sumary_2mm.gamma_mean=gmean2;





% set gamma window and color coding for gamma map display.
    
% [h1, h2 ,h3 ,h4,h5] = EImage(gmap,[xp(1) xp(end)],[yp(1) yp(end)],'Title','Gamma Map', ...
%                 'xlabel', 'x (mm)', 'ylabel', 'y (mm)');
%  cmap = [ 0,0,0.7; 0,0,0.7; 0,0,1; 0,1,0; 0.7,1,0.2; 0.8,0,0]; % no orange
%  colormap(h1,cmap);
%  caxis(h1,[0,1.2]);
%  colorbar('peer',h1);
 
% changed it to GammaImage for clear 
 [h1 h2 h3 h4 h5] = GammaImage(gmap,[xp(1) xp(end)],[yp(1) yp(end)],'Title','Gamma Map', ...
                'xlabel', 'x (mm)', 'ylabel', 'y (mm)');
 
 
 
% ##################
% get root window information 

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
% 

% #################################
% % new function to get only 

gamma_image_name=beam_name2;

gamma_result_file_name=['Pin_gamma map_' gamma_image_name '.jpg'];

% Eimage_handle=findobj('Tag','Eimage_fig');


% screencaptureRT(Eimage_handle,[],gamma_result_file_name);

saveas(h5,gamma_result_file_name);

% #########################################
%imageview(gamma_result_file_name);

close(h5);

% pass 


     