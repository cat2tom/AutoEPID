function gamma_result_file_name=xioSiemensToGammaMap(xio_tps_file, epid_dicom_file,DTA,tol,pixel_dose_factor)

%  The function read the dose file from xio and epid dicom file from
%  Siemens machine and analyze the resutls.

% input: xio_tps_file---the dose plane file exported from xio
%        epid_dicom_file-the epid dicom file from Siemens machine
%        DTA-distance to agreement
%        Tol-dose tolerance
% pixel_dose_factor-the dose conversion factor
% output: gamma_resutls_file-the file name of gamma images
       

% read xio dose and grid information from xio dose file

 [xgrid,ygrid,tpsdose]=readXioDose(xio_tps_file);

% read EPID dose and grid information from the Simens EPID image
 [Ex,Ey,epiddose,gamma_image_name]=epidSiemensToDoseXio8(epid_dicom_file,pixel_dose_factor);
  
% dose grid interpolation from EPID grid to xio's
  row=length(ygrid);
  
  col=length(xgrid);
  
  epid_inter2=interp2(Ex,Ey,epiddose,xgrid,ygrid');
  
  
  [tpsrow tpscol]=find(tpsdose==max(tpsdose(:)));
  
  [epidrow,epidcol]=find(epid_inter2==max(epid_inter2(:)));
  
  Ex=Ex+(tpscol-epidcol)*0.1;
  
  Ey=Ey+(tpsrow-epidrow)*0.1;
  
  epid_inter=interp2(Ex,Ey,epiddose,xgrid,ygrid');
  
 % Automatically register two images after they have same grid resolutions.
  
  [output shiftedepid] = dftregistration(fft2(tpsdose),fft2(epid_inter),100);
  
  shiftedepid=abs(ifft2(shiftedepid));
  
 % set up tolerace parameters for gamma analysis

   image1=tpsdose;
   
   image2=shiftedepid;
   
   xp=xgrid;
   
   yp=ygrid;

    thresh=10;
    dosetol=tol;
   
    dta=DTA;
    res_x = xp(2) - xp(1);
    res_y = yp(2) - yp(1);
    radius_cm = dta/10*1.5;
    thresh = thresh/100;
    dosetol = dosetol/100;
    dta = dta/10;       % Convert to cm
    rad_pix = min(ceil(radius_cm/res_x),ceil(radius_cm/res_y));
    
% use Gamma function to calculate the Gamma map

    [gmap,npass,gmean,ncheck] = Gamma(image1,image2,xp,yp,dosetol,dta,thresh,rad_pix);
    
    [h1 h2 h3 h4 h5] = EImage(gmap,[xp(1) xp(end)],[yp(1) yp(end)],'Title','Gamma Map', ...
                'xlabel', 'x (cm)', 'ylabel', 'y (cm)')

% set the gamma color coding for display purpose
            
    cmap = [ 0,0,0.7; 0,0,0.7; 0,0,1; 0,1,0; 0.7,1,0.2; 0.8,0,0]; % no orange
    colormap(h1,cmap);
    caxis(h1,[0,1.2]);
    colorbar('peer',h1);
     
  
 chl=h5;

 figure(chl);
 
 get(chl);
%  chl=gcf;
 set(chl,'Units','Pixel');
 position2=get(chl,'Position');
  
set(0,'Units','Pixel');
root_screen=get(0,'ScreenSize');

% use matlab java interface to capture the picture and save it as jpg for
% late use.
robo = java.awt.Robot;
t = java.awt.Toolkit.getDefaultToolkit();  

rectangle = java.awt.Rectangle(position2(1),root_screen(4)-(position2(2)+position2(4)),position2(3),position2(4));

image5 = robo.createScreenCapture(rectangle);

gamma_result_file_name=['Xio gamma map_' gamma_image_name '.jpg'];

filehandle = java.io.File(gamma_result_file_name);
javax.imageio.ImageIO.write(image5,'jpg',filehandle);
%imageview(gamma_result_file_name);

close(h5);

     