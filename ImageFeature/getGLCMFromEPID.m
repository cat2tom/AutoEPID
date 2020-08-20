function [GLCM_EPIDS,pixel_matrix] = getGLCMFromEPID(epid_file,pair)
%{ 
 
Calculute the GLCM features from EPID HIS images. 
Input: 
epid_file: epid file from Elekta.

pairs: pairs controling the neighers pixel for each pixel in image matrix.
       like  


output:

GLCM_featureS:structure returned by GLCM_features4.


%}



% provide default for pairs

if nargin==1
    
   pair = [0,-1;0,1; -1,1; 1,0;-1,0; -1, -1]; % used four neighbour pixels.
end 

% read EPID file from HIS file only for Elekta.

pixel_matrix=readHISfile(epid_file);

GLCM_EPIDS=getGLCMFromEPIDTPS(pixel_matrix);

end 

