function [ x, y, z, dose ] = dicomDoseTOmat(dicom_file, offset)
% Converts a dicom 3D dose file to matlab-usable variables

[ x, y, z, dose ] = read3DDicomDose(dicom_file,offset);

end 


function [ x, y, z, dose ] = read3DDicomDose(dicom_file,offset)
% Read dicom dose and coordinates from RT dicom dose.

% Converts a dicom 3D dose file to matlab-usable variables

filename=dicom_file;

% Read header and pixel map
info = dicominfo(filename);
I = dicomread(filename);

% Elements in X
cols = double(info.Columns); 

% Elements in Y
rows = double(info.Rows);

% Elemetns in Z
deps = double(info.NumberOfFrames);

% Establish Coordinate System [in cm]
% Note: PixelSpacing indices do not match ImagePositionPatient indicies.
x = (info.ImagePositionPatient(1) + info.PixelSpacing(2)*(0:(cols-1)))/10 - offset(1);
y = (info.ImagePositionPatient(2) + info.PixelSpacing(1)*(0:(rows-1)))/10 - offset(2);
z = (info.ImagePositionPatient(3) + info.GridFrameOffsetVector)/10 - offset(3);

% Remove 4th Dimension from Dose Grid
J = reshape(I(:,:,1,:),[rows cols deps]);

% Scale Dose Grid Using Stored Factor
dose = double(J)*info.DoseGridScaling;

% figure
% imshow(reshape(dose(77,:,:),[length(x),length(z)]));
if strcmp(info.DoseUnits,'CGY')
    dose = dose/100;
end

end 

