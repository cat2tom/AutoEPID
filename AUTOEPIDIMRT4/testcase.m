
%The following codes is to test the function xioSiemensToGammaMap and
%xioSiemensToProfile.
xio_tps_file='1008982_F1_180.txt';
epid_dicom_file='F1_180_1.RTIMAGE.1.2.2012.03.23.17.55.16.171875.85275379.IMA';
DTA=3;
tol=3;
pixel_dose_factor=0.00005197;

pin_pixel_dose_factor=0.000043545;

pin_epid_dicom_file='MCDONALD_MURIEL_ALICE.RTIMAGE.PORTAL_IMAGING.1.8.2012.05.24.16.40.07.78125.62368673.IMA';
%gamma_result_file_name=xioSiemensToGammaMap(xio_tps_file,epid_dicom_file,DTA,tol,pixel_dose_factor);

%profile_image_file_name=xioSiemensToProfile(xio_tps_file, epid_dicom_file,DTA,tol,pixel_dose_factor)

%The following code is to test the function 

pin_tps_file='1074172_Beam_215-TotalDose.txt';

%gamma_result_file_name2=pinSiemensToGamma(pin_tps_file, pin_epid_dicom_file,DTA,tol,pin_pixel_dose_factor);
gamma_result_file_name3=pinSiemensToProfile(pin_tps_file, pin_epid_dicom_file,DTA,tol,pin_pixel_dose_factor);
