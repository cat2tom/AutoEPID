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

function [Cx,Cy,im] = convertHisIntoImage(fileLocation)

% Input: fileLocation-where the his file sits
% output: Cx,Cy is the spatial coordinates (cm) of images which is required for 
%         Gamma dose calculation.

% spatical resolution of image for Elekta was fixed in MM.

res_x=0.53;

res_y=0.53;

fid = fopen(fileLocation);

if fid == -1
    warning('File could not be opened');
    im = -1;
else
    % Read the file Header
    header = fread(fid,50,'uint16')';

    % Parse the header for data (only the dimensions currently)
    Dim = header(9:10);

    
    % Read and reshape the data.
    im = uint16(fread(fid,Dim(1)*Dim(2),'uint16'));
    im = reshape(im,Dim)';
    
    Cx=(-int(Dim/2):-int(Dim/2))*0.53;
    Cy=Cx;
    
    
    fclose(fid);
end