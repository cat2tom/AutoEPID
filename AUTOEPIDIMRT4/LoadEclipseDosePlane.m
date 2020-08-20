function [image res] = LoadEclipseDosePlane(EclipseFile, normflag)
% Reads the dose plane image specified and returns the result
% Inputs:

% Outputs:

if ~exist('EclipseFile','var') || isempty(EclipseFile)
    [filename pathname] = uigetfile('*.dcm','Select Eclipse dose plane file');
    if isequal(filename,0)
        % Cancelled
        image = [];
        res = [];
        return;
    end
    EclipseFile = fullfile(pathname,filename);
end

if (~exist('normflag','var')) || (isempty(normflag))
    normflag = false;
end

% Read the header information (dicom format)
fileheader = dicominfo(EclipseFile);

res = fileheader.PixelSpacing;
dosefactor = fileheader.DoseGridScaling;

% Read the information
eclipseimage = dicomread(fileheader);

image = double(eclipseimage) .* dosefactor;

% Normalize if requested
if normflag
    centrex = round(size(image,1)/2);
    centrey = round(size(image,2)/2);
    normvalue = image(centrey,centrex);
    image = image ./ normvalue;
end