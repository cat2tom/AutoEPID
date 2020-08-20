function [total_pixel,pass_gamma_num,min_gamma,max_gamma,mean_gamma,numpass] = CalculateSummaryData(imagedata)
% Compute some summary values

% input: imagedata-the gamma map with same size as reference dose. 

% ouput: total_pixel-the total pixel number within threshold
%         pass_gamma_num-the number of pixe whose gamma value is less than
%         1
%         min_gamma,max_gamma,mean_gamma-the statistical number.
%         numpass-the pass rate in %. eg.95%


% imagedata is the threshold cutoff gamma map.
threshed_gamampa=imagedata;

% only account the masked values.
tmp_imagedata=imagedata(imagedata>0);

minimage = min(tmp_imagedata(:));

if minimage<0
    
  minimage=0;
  
end 


maximage = max(tmp_imagedata(:));
meanimage = mean(tmp_imagedata(:));
% medimage = median(imagedata(:));
% devimage = std(imagedata(:));
[ypix xpix] = size(imagedata);

% get mask for gamma image

% use gmap as images dataset.
% Mask = zeros(size(imagedata));


% critical_val=0.01*max(imagedata(:));  % changed from 10 to 1%.

% critical_val=0;
% 
% Mask(imagedata>=critical_val) = 1;

numWithinField = nnz(imagedata);

% numpass = nnz(imagedata<1 & Mask)./numWithinField;

pass_gamma_num=nnz(tmp_imagedata<1);
numpass = nnz(tmp_imagedata<1)./numWithinField;

avg = sum(tmp_imagedata(:))./numWithinField;

total_pixel=numWithinField;

min_gamma=minimage;

max_gamma=maximage;

mean_gamma=avg;




