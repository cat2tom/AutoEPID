function gamma_rate = get1DGammaRate(x_cor,y_cor,pixel_1,pixel_2 )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here




Image1=pixel_1; 
Image2=pixel_2;

Xpoints=x_cor;
Ypoints=y_cor;
Dose_tol=0.03;
FE_thresh=0.1;

DTA_tol=3; 

rad=6; 

[GammaMap2, numpass, avg, numWithinField] = Gamma(Image1, Image2, Xpoints, Ypoints, Dose_tol, DTA_tol, FE_thresh, rad);

gamma_rate=numpass*100; 


end

