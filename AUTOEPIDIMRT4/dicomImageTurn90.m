
function  dicomImageTurn90(dicom_file_name)

% This function is to dicom image 90 degree for Pinacle  as did in IMRT
% OmniPro.
% input: dicom_file_name
% output: write the scaled image into the same name as input and return
% scale factor

info1=dicominfo(dicom_file_name);
data=dicomread(dicom_file_name);



data2=imrotate(data,-90,'bilinear','loose');

dicomwrite(data2,dicom_file_name,info1,'CreateMode','copy');


end 

