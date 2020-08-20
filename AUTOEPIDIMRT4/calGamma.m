function calGamma

% This is test function to test gamma function in IMRTChecker.
% The function will call three other functions:
% [xgrid,ygrid,tpsdose]=readXioDose('xio_plane_dose.txt'), reads the dose
% from xio plane file and return dose to 2d matrix and the x and y
% cooridnate in 1D array xgrid and ygrid.

% [Ex,Ey, epdidsoe]=epidSiemensToDoseXio6('epid_image.IMA', pixel-to_dose
% factor) return the epid dose to matrix epiddose and cooridinates in Ex,
% and Ey, respectively.



     [xgrid,ygrid,tpsdose]=readXioDose('1008982_F1_180.txt');
%           [xgrid,ygrid,tpsdose]=epidSiemensToDoseXio6('F1_180_1.RTIMAGE.1.2.2012.03.23.17.55.16.171875.85275379.IMA'...
%          ,0.00005093);%Phil - temp for testing
     
     h=figure;
     
     image(tpsdose);
     
     % the calibration factor in the following fucntion is made up
     
     [Ex,Ey,epiddose]=epidSiemensToDoseXio6('F1_180_1.RTIMAGE.1.2.2012.03.23.17.55.16.171875.85275379.IMA'...
         ,0.00005093);
        
%      [Ex,Ey,epiddose]=readXioDose('1008982_F1_180.txt');%Phil - temp for testing
%       epiddose=1.0*epiddose;

     h=figure;
     
%      image(epiddose);
%    % the following line is manually shift the epid image for registration of two images and will be optimize 
%    % later.
%      Ex=Ex+0.3;
%      Ey=Ey;
     
     % In order to calculate gamma, the epid dose is interpolated to
     % coordiante grids of dose grid from xio
     
     epid_inter=interp2(Ex,Ey,epiddose,xgrid,ygrid');
     
     image(epid_inter);
     
%      tpsdose=tpsdose/max(tpsdose)*100;
%      epid_inter=epid_inter/max(epid_inter)*100;
     % call the fucntion to calculate Gamma,return the gmap, pass rate, the
     % average and total points in the images.
     % tpsdose, epid_inter are just arbitraily 2d matrix with same
     % dimension, xgrid and ygrid are just vector containg the coordinates
     % for x axis and yaixs. 
     
     
     [gmap,npass,av,total]=Gamma(tpsdose,epid_inter,xgrid,ygrid,0.03,0.3,0.1);
     
% %      h3=figure
% %      
% %      image(gmap)
%        hi=image(gmap)
% %      cmap = [ 0,0,0.7; 0,0,0.7; 0,0,1; 0,1,0; 0.7,1,0.2; 0.8,0,0]
% %      
%      colormap(hi,cmap)
%     Show the gamma map for inspection. 
             figure;
            imagesc(gmap);
            axis('image');
            
            cmap = [ 0,0,0.7; 0,0,0.7; 0,0,1; 0,1,0; 0.7,1,0.2; 0.8,0,0]; % no orange
            colormap(cmap);  
            caxis([0,1.2]); 
               
     npass
     av
     total
     
    
     