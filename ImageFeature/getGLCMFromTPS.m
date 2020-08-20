function [GLCM_EPIDS,tpsdose]= getGLCMFromTPS(pin_tps_file,pair)
%{ 
 
Calculute the GLCM features from EPID HIS images. 
Input: 
tps_file: tps file name from Pinnacle.

pairs: pairs controling the neighers pixel for each pixel in image matrix.
       like  

output:

GLCM_featureS:structure returned by GLCM_features4.

tpsdose: tps dose from Pinnacle.


%}



% provide default for pairs
if nargin==1
    
   pair = [0,-1;0,1; -1,1; 1,0;-1,0; -1, -1]; % used four neighbour pixels.
end 

% read dose from pinnalce files.

[xgrid,ygrid,tpsdose]=readPinnacleDose3(pin_tps_file);
 
tpsdose=tpsdose*100;

% calculate from dose matrix.

GLCM_EPIDS=getGLCMFromEPIDTPS(tpsdose);

end

