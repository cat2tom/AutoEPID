
function  dicomMoveOrigin(scaled_dicom_file_name)

% This function is to move the orgin of the scaled dicom dose image as did in IMRT
% OmniPro.
% input: dicom_file_name
% output: write the scaled image into the same name as input.

info1=dicominfo(scaled_dicom_file_name);
data=dicomread(scaled_dicom_file_name);

% scaled image size

[row,col]=size(data);

% get image resolution
% 

resolution=info1.ImagePlanePixelSpacing;


% x and y dimesion for scaled image

x=row*resolution;
y=col*resolution;

% set the new origin for scaled images


info1.RTImagePosition=[-x/2.0; x/2.0];

disp('x,y=');
-x/2.0
x/2.0

dicomwrite(data,scaled_dicom_file_name,info1,'CreateMode','copy')




end 

