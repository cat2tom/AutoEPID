%{
 This is an example script for Alison to test the Gamma accuracy and gamma
 pass rate accuracy. 

 Test: (1) Accuracy of Gamma value;
       (2) Threshold setting;
       (3) Gamma pass rate;

%}


% make reference image with 10 pixel having value of 10;

ref_image=ones(100,100)*100; 

ref_image(50,50)=108; % maximum value

ref_image(1:10)=10.5; % make 10 pixel less than threshold; 


% make second image

second_image=ones(100,100)*100;

% Calculate Gamma;

x_cors=-50:0.1:50;
y_cors=-50:0.1:50;

x_cors=x_cors(1:100);

y_cors=y_cors(1:100);


Dose_tol=0.03;

DTA_tol=0.3;
FE_thresh=0.1;

[GammaMap, numpass, avg, numWithinField] = Gamma(ref_image, second_image, x_cors, y_cors, Dose_tol, DTA_tol, FE_thresh)


