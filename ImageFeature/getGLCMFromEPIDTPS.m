function GLCM_featureS = getGLCMFromEPIDTPS(pixel_matrix,pair)
%{ 
 
Calculute the GLCM features from EPID and TPS images. 
Input: 
pixel_matrix: the 2d pixel matrix read from tps or EPID image file

pairs: pairs controling the neighers pixel for each pixel in image matrix.
       like  


output:

GLCM_featureS:structure returned by GLCM_features4.


%}



% provide default for pairs
if nargin==1
    
   pair = [0,-1;0,1; -1,1; 1,0;-1,0; -1, -1]; % used four neighbour pixels.
end 

% remove nan if any

pixel_matrix(isnan(pixel_matrix))=0;

% calculate GLCM features.

GLCM2 = graycomatrix(pixel_matrix,'Offset',pair);

GLCM_featureS= GLCM_Features4(GLCM2,0);


end

