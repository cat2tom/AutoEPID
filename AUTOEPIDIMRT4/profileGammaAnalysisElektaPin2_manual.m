function [gamma_image_file_name,profile_image_file_name,npass,gmean,npass2,gmean2,beam_name2]=profileGammaAnalysisElektaPin2_manual(tps_file,epid_his_file,DTA,tol,PSF,pixel_dose_factor,coll_angle)

% This function just wrapps up two other functions.

   pin_tps_file=tps_file;
   
   [gamma_image_file_name,npass,gmean,npass2,gmean2,beam_name2]=pinElektaToGamma2_manual(pin_tps_file, epid_his_file,DTA,tol,PSF,pixel_dose_factor,coll_angle);
 
   profile_image_file_name=pinElektaToProfile2(pin_tps_file, epid_his_file,PSF,DTA,tol,pixel_dose_factor,coll_angle);
   
      
  