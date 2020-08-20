function [gamma_image_file_name,profile_image_file_name,numpass3,avg3,numpass2,avg2]=profileGammaAnalysisElektaPin2_Vmat_noReg(tps_file,epid_his_file,DTA,tol,PSF,pixel_dose_factor)

% This function just wrapps up two other functions.

   pin_tps_file=tps_file;
   
   [gamma_image_file_name,numpass3,avg3,numpass2,avg2]=pinElektaToGamma2_Vmat_noReg(pin_tps_file, epid_his_file,DTA,tol,PSF,pixel_dose_factor);
   
   %gamma_image_file_name=pinElektaToGamma2_Vmat(pin_tps_file, epid_his_file,DTA,tol,PSF,pixel_dose_factor);
 
   profile_image_file_name=pinElektaToProfile2_Vmat_noReg(pin_tps_file, epid_his_file,PSF,DTA,tol,pixel_dose_factor);
   
      
  