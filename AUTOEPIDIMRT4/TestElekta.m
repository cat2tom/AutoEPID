m1=0.0001045387;

m2=0.0001044300;

mmtest=0.0001033087;

pin_tps_file='0279385_Beam_1.01_153-TotalDose.txt';

epid_his_file='Field_3.HIS';

PSF=0.07298;

DTA=10;
tol=10;

pixel_dose_factor=m2;

[gamma_image_file_name,profile_image_file_name]=profileGammaAnalysisElekta(pin_tps_file,epid_his_file,DTA,tol,PSF,pixel_dose_factor);

% gamma_result_file_name=pinElektaToGamma(pin_tps_file, epid_his_file,DTA,tol,PSF,pixel_dose_factor)
% 
% profile_image_file_name=pinElektaToProfile(pin_tps_file, epid_his_file,PSF,DTA,tol,pixel_dose_factor)

% matched_HIS_file_name=matchElektaHIS2PinTPSFile(pin_tps_file);

% test='C:\aitang research\EPID IMRT commisioning\guiepid\EPIDDOSE6\tpscode\pintpsfile';
% 
% machedPin_TPS_file_name=findTPSFileNameFromGantryAngle(test,56)

% renameTPSFiles(test)