function [gamma_image_file_name,profile_image_file_name]=profileGammaAnalysisElekta(tps_file,epid_his_file,DTA,tol,PSF,pixel_dose_factor)

% This function just wrapps up two other functions.

   pin_tps_file=tps_file;
   
   gamma_image_file_name=pinElektaToGamma(pin_tps_file, epid_his_file,DTA,tol,PSF,pixel_dose_factor);
 
   profile_image_file_name=pinElektaToProfile(pin_tps_file, epid_his_file,PSF,DTA,tol,pixel_dose_factor);
   
      
  