function [gamma_image_file_name,profile_image_file_name,npass,gmean,npass2,gmean2,beam_name2]=profileGammaAnalysisSiemensPin2(tps_file,epid_dicom_file,DTA,tol,pixel_dose_factor,coll_angle)

% This function just wrapps up two other functions.

   pin_tps_file=tps_file;
   
   [gamma_image_file_name,npass,gmean,npass2,gmean2,beam_name2]=pinSiemensToGamma2b(pin_tps_file, epid_dicom_file,DTA,tol,pixel_dose_factor,coll_angle);
   [profile_image_file_name,beam_name2]=pinSiemensToProfile2(pin_tps_file, epid_dicom_file,DTA,tol,pixel_dose_factor,coll_angle);
   
   
 