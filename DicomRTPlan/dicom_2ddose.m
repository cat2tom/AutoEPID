dicom_file2d='rs_2d_dose.dcm';

dicom_file3d='rs_3d_dose.dcm';

info1=dicominfo(dicom_file2d)

info2=dicominfo(dicom_file3d)

if ~isfield(info1,'NumberOfFrames')
    disp('test')
end 

info2.NumberOfFrames