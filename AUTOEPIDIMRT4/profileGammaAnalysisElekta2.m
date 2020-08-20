function [gamma_image_file_name,profile_image_file_name]=profileGammaAnalysisElekta2(tps_file,epid_his_file,DTA,tol,PSF,pixel_dose_factor,coll_angle)

% This function just wrapps up two other functions.

   pin_tps_file=tps_file;
   
   gamma_image_file_name=pinElektaToGamma(pin_tps_file, epid_his_file,DTA,tol,PSF,pixel_dose_factor,coll_angle);
 
   profile_image_file_name=pinElektaToProfile(pin_tps_file, epid_his_file,PSF,DTA,tol,pixel_dose_factor,coll_angle);
   
      
  