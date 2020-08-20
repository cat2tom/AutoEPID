
function  dicomImageResize(dicom_file_name)

% This function is to rescale the size of dicom image as did in IMRT
% OmniPro.
% input: dicom_file_name
% output: write the scaled image into the same name as input and return
% scale factor

info1=dicominfo(dicom_file_name);
data=dicomread(dicom_file_name);

% scale factor
% 

company=info1.Manufacturer;

scale_factor=1;
if strcmp(company,'ELEKTA')
    
    scale_factor=0.625;
end 

if strcmp(company,'Siemens Oncology Care Systems')
    
    sid=info1.RTImageSID;
    
    scale_factor=1000.0/sid;
    
end 

tmp2=info1.ImagePlanePixelSpacing;

info1.ImagePlanePixelSpacing=tmp2*scale_factor;


dicomwrite(data,dicom_file_name,info1,'CreateMode','copy');


end 

