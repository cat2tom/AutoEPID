function  new_2D_dicom_file=DicomDose3Dto2D(dicom_3d_dose_file,template_2D_dicom_file,new_2D_dicom_file)

% Convert 3D RT dose into 2D dose dicom.

dicom_dose_file=dicom_3d_dose_file;
template_dicom_file=template_2D_dicom_file;

% get 3D dicom info

[xgrid,ygrid, dose_plane2]=readDicomDose(dicom_dose_file);
info3D=dicominfo(dicom_dose_file);
doseScale3D=info3D.DoseGridScaling;

% get 2D dicom info 

templateInfo=dicominfo(template_dicom_file);
templateInfo.Rows=length(xgrid);
templateInfo.Columns=length(ygrid);
templateInfo.DoseGridScaling=doseScale3D;

dose_plane2=dose_plane2/doseScale3D;

% test=dicomread(template_2D_dicom_file);

% class(test)
% convert to Gy and uint16
dose_2d=uint16(dose_plane2);
dicomwrite(dose_2d,new_2D_dicom_file,templateInfo,'CreateMode', 'copy');

end 

