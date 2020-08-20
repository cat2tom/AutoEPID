function [gamma_image_file_name,profile_image_file_name,beam_name2]=profileGammaAnalysisSiemens(tps_file,epid_dicom_file,DTA,tol,pixel_dose_factor)

% This function just wrapps up two other functions.

   pin_tps_file=tps_file;
   
   [gamma_image_file_name,beam_name2]=pinSiemensToGamma(pin_tps_file, epid_dicom_file,DTA,tol,pixel_dose_factor);
   [profile_image_file_name,beam_name2]=pinSiemensToProfile(pin_tps_file, epid_dicom_file,DTA,tol,pixel_dose_factor);
   
   
 