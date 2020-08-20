%{
 This scripts is to show how to an test patient by

 (1) make an image pattern;
 (2) write the image pattern into HIS file;
 (3) write the image pattern into TPS file;

%}


% make reference image with 10 pixel having value of 10;

ref_image=ones(1024,1024)*100; % size has to be 1024.

ref_image(517,517)=108; % maximum value

ref_image(1:100)=10.5; % make 10 pixel less than threshold; 


% write a reference image to an TPS file

 pin_tps_file='test_patient_tps.txt';
 
 pinDoseFileName=pin_tps_file;
 
 imageData=ref_image;
 
 size(imageData)

 %% write into an tps file name
  write2PinacleDoseFile(pinDoseFileName,imageData )


 %%
 
% make second image. For EPID image, in order to get 100Gy or 100cGy, you
% need set as: second_image=ones(1024,1024)*100/M2_Calibration_factor. 

second_image=ones(1024,1024)*100;

%% write to an epid HisFile.

template_his_file='template.HIS';

test_patient_epid_file='test_patient_epid.HIS';

data=second_image;

write2HISFile(template_his_file,test_patient_epid_file,data);


%% 


