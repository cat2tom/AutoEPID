function [GammaMap2, numpass, avg, numWithinField] = Gamma(Image1, Image2, Xpoints, Ypoints, Dose_tol, DTA_tol, FE_thresh, rad)
% This version is the wrapp up for Mark's gamma functin. 
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

res_x = Xpoints(2) - Xpoints(1);
res_y = Ypoints(2) - Ypoints(1);


start=[Xpoints(1) Ypoints(1)];% convert to mm
width=[res_x  res_y];

% reference is image2
reference.start=start;
reference.width=width;
reference.data=Image2;

% target is Image1

target.start=start;
target.width=width;
target.data=Image1;



% convert Dose_tol to numer
percent=Dose_tol*100;

% dta

dta=DTA_tol;

% global gamma map
local=0;



% call the gamma function to calculate it. 

GammaMap = CalcGamma(reference, target, percent, dta, 'local', local);

% get mask

MaxVal = max(Image1(:));

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
numpass=numel(cutoff_gammamap(cutoff_gammamap<=1))./numWithinField;

% 
% numWithinField = nnz(Mask);
% numpass = nnz(imagedata<=1 & Mask)./numWithinField;

% avg = sum(imagedata(:))./numWithinField;

avg=sum(cutoff_gammamap(:))./numWithinField;

% get the masked gamma map for statistics purpose 
GammaMap2=GammaMap.*Mask; 






