

file_2d='rs_2d_dose.dcm';

file_3d='rs_3d_dose.dcm';

new_2D_file_name='test.dcm';

new_2D_dicom_file=DicomDose3Dto2D(file_3d,file_2d,new_2D_file_name);


 
 
% dose_array=dicomread(info);
% 
% dose=dose_array*info.DoseGridScaling;
% 
% imagesc(dose)

