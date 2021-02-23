function [shifted_tar_image,opt_x_shift,opt_y_shift] = optimizeImageRegistrationMissing(ref_image,tar_image )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% get profile.

[ref_xx_cor,ref_xy_cor,ref_x_pixel,ref_yx_cor,ref_yy_cor,ref_y_pixel ] = getMaxValProfile(ref_image);

[tar_xx_cor,tar_xy_cor,tar_x_pixel,tar_yx_cor,tar_yy_cor,tar_y_pixel ] = getMaxValProfile(tar_image);


opt_x_shift=optimizeProfileShiftMissing(ref_xx_cor,ref_xy_cor,ref_x_pixel,tar_x_pixel) ;

opt_y_shift=optimizeProfileShiftMissing(ref_yx_cor,ref_yy_cor,ref_y_pixel,tar_y_pixel) ;


trans=[opt_y_shift,opt_x_shift];

shifted_tar_image=imageTranslate(tar_image,trans);





end

