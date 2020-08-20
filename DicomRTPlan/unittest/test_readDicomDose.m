dcm_file='rs_3d_dose.dcm';

% dcm_file='rs_2d_dose.dcm';
 
 
% dcm_file='miller3d.dcm';

[xgrid,ygrid, dose_plane2]=readDicomDose(dcm_file);

maxTemp=max(dose_plane2(:));

figure;

imshow(dose_plane2)

