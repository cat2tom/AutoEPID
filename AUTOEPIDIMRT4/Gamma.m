function [GammaMap2, numpass, avg, numWithinField] = Gamma(Image1, Image2, Xpoints, Ypoints, Dose_tol, DTA_tol, FE_thresh, rad)
% This version is the LCTC version.. 
% Version 1 - 31-May-08 
%
% Compare Image2 to reference image (TPS) Image1
% rad: radius - in points - need to work out before pass 
% Version 2  - 13/06/08 improved speed by making submatrix about calc point
% 29.04.09 changed Image 1 to image to find > 10% to avoid noise spikes in
% film - changed code to Mask(selected) = 1;
% Version 3 - 04/11/09 Improved speed for larger fields by vectorizing the
% calculation. Speed increase of ~50% for 20x20 cm field. Slightly slower
% for small fields. Decrease in speed of ~10% for 5x5 cm field.
% 04.06.10 PG added boundary check of max and min indices
% 
% GAMMA settings
%Dose_tol = DoseTol; % Percent of maximum dose. Given as a fraction
%DTA_tol = DistTol; % cm
%FE_thresh = ThreshFx; eg 0.1 means 10% .% Given as a fraction
%rad = radius; % number of points to search whin
% Note: DTA tolerance and specified X, Y points must be in the same units

% prepare input image1 is target and image2 is reference.

Reference=Image1;

Evaluated=Image2;



% convert Dosed is fraction, eg 10% to 0.1
dosed=Dose_tol;

% expect in mm.
DTA=DTA_tol;

% global gamma map
local='global';

%threshold in fraction 0.1 =10%.

minLim=FE_thresh;

% call the gamma function to calculate it. 

[GammaMap, gammaAngle]=gamma2dnewandgammaangle(Reference,Evaluated,DTA,dosed,minLim,local );


% get mask

 MaxVal = max(Image1(:));

% MaxVal=100;%cGy to match OminPro.


Mask = zeros(size(Image1));
crit_val = FE_thresh*MaxVal;

Mask(Image1>crit_val) = 1;



% change Mask to logical values.
Mask=logical(Mask);


% get gamma map less than threshold value.
cutoff_gammamap=GammaMap(Mask);

% Account the total gamma map elements.
numWithinField=numel(cutoff_gammamap);

% get gamma value less than 1.
numpass=numel(cutoff_gammamap(cutoff_gammamap<1))./numWithinField;

% 
% numWithinField = nnz(Mask);
% numpass = nnz(imagedata<=1 & Mask)./numWithinField;

% avg = sum(imagedata(:))./numWithinField;

avg=sum(cutoff_gammamap(:))./numWithinField;

% get the masked gamma map for statistics purpose 
% GammaMap2=GammaMap.*Mask; 


GammaMap2=GammaMap.*Mask; 

% if max(GammaMap2(:))>=2
%      
%      GammaMap2=2*GammaMap2./max(GammaMap2(:));
%      
% end 



if numpass>=0.85
     
     GammaMap2=2*GammaMap2./max(GammaMap2(:));
     
end 


