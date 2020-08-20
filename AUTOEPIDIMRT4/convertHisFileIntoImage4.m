% Author:   Nick Rawluk
%
% Function: readHISfile
%
% Inputs:   fileLocation    File name and path of VFF file
%
% Outputs:  im              Image contained in HIS file
%
% Purpose:  To open/read a HIS file from the PerkinElmer HIS data type
%
% Notes:
% - Header is 100 bytes (50 uint16's)
% - # of Columns/Rows is at uint16 number 9 & 10 (by inspection), not sure
%   which is which at this point, but doesn't really matter
%
% Changelog:
% March 17, 2010 - Initial creation
% March 19, 2010 - Properly fail is file does not exist

function [Ex,Ey,im,beam_name2] = convertHisFileIntoImage4(fileLocation,PSF,pixel_to_dose_factor)

% Input: fileLocation-where the his file sits
% output: Cx,Cy is the spatial coordinates (cm) of images which is required for 
%         Gamma dose calculation.

% spatical resolution of image for Elekta was fixed in MM.

res_x=0.255;

res_y=0.255;


% open HIS file for readings.

fid = fopen(fileLocation);

% genereate the beam name using HIS file name

%[pathstr, name, ext, versn] = fileparts(fileLocation); before matlat 2013
%version.

[pathstr, name, ext] = fileparts(fileLocation);
 
 beam_name2=name; % get the beam name from the name of HIS file name. 

header = fread(fid,50,'uint16')';

% Parse the header for data (only the dimensions currently)
Dim = header(9:10);


% Read and reshape the data.
im = uint16(fread(fid,Dim(1)*Dim(2),'uint16'));
im = reshape(im,Dim)';
%   Cx=(-uint16(Dim/2):uint16(Dim/2))*0.53;
low=-double(Dim(1)/2);
up=-low;
Ex=(low+1:up)*res_x;
Ey=(low+1:up)*res_y;
Ex=double(Ex);
Ey=double(Ey');


im=double(im);
im=-(im-2^16);
im=im/PSF;
im=im*pixel_to_dose_factor;
im=imrotate(im,-180,'bilinear','loose');
fclose(fid);
end

