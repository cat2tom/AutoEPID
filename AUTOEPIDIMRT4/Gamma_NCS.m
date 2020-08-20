function [GammaMap2, numpass, avg, numWithinField] = Gamma(Image1, Image2, Xpoints, Ypoints, Dose_tol, DTA_tol, FE_thresh, rad)

% Version 1 - 31-May-08 
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

debuglevel = 2;

res_x = Xpoints(2) - Xpoints(1);
res_y = Ypoints(2) - Ypoints(1);

% if radius not specified, compute a sensible one
% Expand DTA tolerance by 50%. Use this as a search radius
if ~exist('rad','var') || isempty(rad)
    radlim = DTA_tol * 1.5; % from 1.5 to 5
    rad = min(ceil(radlim/res_x),ceil(radlim/res_y));
end
MaxVal = max(Image1(:));
%MaxVal = max(max(Image1));
%[Im1_ydim, Im1_xdim] = size(Image1);
Mask = zeros(size(Image1));
crit_val = FE_thresh*MaxVal;

%[Im1_ydim Im1_xdim] = size(Image1);

% Use the Resampled image for this - EPID no spikes?
Mask(Image1>crit_val) = 1;

% figure;
%             imagesc(Mask);
            
Dose_tol = Dose_tol*MaxVal; % GLOBAL - PERCENTAGE OF MAX DOSE
if debuglevel > 1
    fprintf('Maximum dose for Gamma: %2.1f cGy\n',MaxVal);
    fprintf('Dose Tolerance for Gamma: %2.1f cGy\n',Dose_tol);
end

% VECTORIZED CALCULATION STARTS HERE

% GammaMapsub will carry the calculated gamma values for the truncated
% images. GammaMap2 will be the Gamma values for the full image.
GammaMapsub = NaN;
GammaMap = zeros(size(Image1));
% Find the threshold limits for truncation
[validmask_y validmask_x] = find(Mask);
min_x = min(validmask_x)-rad;
max_x = max(validmask_x)+rad;
min_y = min(validmask_y)-rad;
max_y = max(validmask_y)+rad;
if min_x < 1
    min_x = 1;
end
if min_y < 1
    min_y = 1;
end
if max_x > size(Image1,2)
    max_x = size(Image1,2);
end
if max_y > size(Image1,1)
    max_y = size(Image1,1);
end
% Truncate the images to avoid needless calculations
Im1 = Image1(min_y:max_y,min_x:max_x);
Im2 = Image2(min_y:max_y,min_x:max_x);
   


[row_tmp,col_tmp]=size(Im1);

numpoint=row_tmp*col_tmp;

% Shift the image by varying amounts. Determine the minimum gamma value
% for all shifts
for i=-rad:rad
    for j=-rad:rad
        % circshift function wraps elements from top to bottom as necessary
        % The entire image is shifted at once
        Im2_shift = circshift(Im2,[i j]);
        dist = sqrt((res_y*i)^2 + (res_x*j)^2);
        DoseDiff = Im2_shift - Im1;
        % Compute the gamma map for this particular shift value
        Gamma_temp = sqrt((dist./DTA_tol).^2 + (DoseDiff./Dose_tol).^2);
        % Accumulate the map of the minimum values of gamma at each point
        GammaMapsub = min(GammaMapsub,Gamma_temp);
    end
end
% Put the truncated gamma map back into its proper location within the full
% gamma map
GammaMap(min_y:max_y,min_x:max_x) = GammaMapsub;
% Remove any edge effects from the circular shifting by multiplying by the
% mask values. This will negate any calculated gamma values around the
% edges of the distribution where this effect would arise
%GammaMap = GammaMap .* Mask;
% Ensure that NaN values outside the mask do not affect the calculation
GammaMap(~Mask) = 0.0;

GammaMap(isnan(GammaMap))=0;

% change this to make sure gamma statticstic are same.
imagedata=GammaMap;
% critical_val=0.01*max(imagedata(:));  % changed from 10 to 1%.
% critical_val=0;
% Mask(imagedata>=critical_val) = 1;

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






