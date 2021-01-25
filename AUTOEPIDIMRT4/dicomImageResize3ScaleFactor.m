
function  dicomImageResize3ScaleFactor(dicom_file_name, machine_name)

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

if strcmp(machine_name,'M7Versa')
    
    scale_factor=0.6201; % 0.253mm/pixel
    
else
    
     scale_factor=0.6127; % 0.250 mm/pixel
    
end 

tmp2=info1.ImagePlanePixelSpacing;

info1.ImagePlanePixelSpacing=tmp2*scale_factor;


dicomwrite(data,dicom_file_name,info1,'CreateMode','copy');


end 

