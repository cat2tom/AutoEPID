function [ImageMatrix, header, Nframes, filetype] = LoadEpidImage(FILENAME,invert,pixeloffset,headeronly)
% This is a general purpose function to load an epid image into Matlab
% variables. It will read dicom, hna, hnc, or dxf (portal dosimetry) 
% images. If a filename is not specified in the input arguments, the user 
% will be prompted to select one.
%
% Calling syntax:
% [ImageMatrix, header, Nframes, filetype] = LoadEpidImage(FILENAME,invert,
%       pixeloffset,headeronly)
%
% Keywords:
%   Epid, header, dicom
%
% Input arguments:
%   *FILENAME: A character array containing the full file name containing 
%   the image to open. If not specified or empty, a dialog box is presented
%   where the user can select the file to open. If the user clicks cancel 
%   in this dialog box, the function returns all empty arguments. 
%   Otherwise, the specified file is read and the outputs returned.
%
%   *invert: A character array, either 'on' or 'off'. Defaults to 'on'. If 
%   'on', inverts the image data from the file. This value is only used if 
%   the proper setting can not be determined from the file.
%
%   *pixeloffset: offset to use when interpreting the images. If not 
%   specified, defaults to 2^14. This value is only used if the pixel 
%   offset is not specified in the file.
%
%   *headeronly: logical scalar that determines whether to store the image 
%   or just read the header information. If not specified or empty defaults
%   to false. If set to true, the image will not be read. This is a time 
%   saving feature for cases where the actual image is not required. 
%
% Output arguments:
%   *ImageMatrix: The image stored in the file.
%
%   *header: The image header stored in the file. This is a structure 
%   variable. The elements of the structure vary depending on what type of 
%   image file was read.
%
%   *Nframes: The number of frames from the image header. To get a true 
%   integrated image, multiply each element of ImageMatrix by Nframes
%
%   *filetype: A string containing file type read. Either 'dcm', 'hna', 
%   'hnc', 'dxf' or 'xim' 
%
% Notes: 
% No information regarding number of frames is present in HNA files.
% Nframes in this case will be set to 1. Number of frames for HNC files is
% actually the elapsed time for the image (min). It serves the same purpose as
% the number of frames but differs by a scaling factor of frames per minute
% from the number of frames. When comparing images of the same type, this
% difference is not important but will cause differences when intermixing
% dicom files with HNC files
%
% The function attempts to read the required data from the header to ensure
% that all images are output "right side up" (ie. all pixel values are 
% positive, with regions of higher dose having a larger pixel value). If 
% this information is not present, the pixeloffset and invert arguments can
% be used to manually adjust the output. In typical usage, only the input 
% file name needs to be specified.
%
% XIM files are read with the function XIMReader supplied by Varian. This
% function is not allowed to be included in the MPRG software repository.
% The LoadEpidImage function therefore checks if the function is present
% and only offers the option of reading this type of file if it exists
%
% Known bugs:
%
% See also:
%   [[GetHeaderInfo]], [[GetIntegratedImage]]
%
% Maintainer(s):
% [[Brian King]]
%

ImageMatrix = [];
header = [];
Nframes = [];
filetype = [];

ximpath = which('XIMReader');
ximvalid = true;
if isempty(ximpath)
    % No XIMReader function found
    ximvalid = false;
end

%Select the file, if not specified
if ~exist('FILENAME','var') || isempty(FILENAME)
    extfilter = {'*.dcm' '(*.dcm) Dicom'; '*.hna' '(*.hna) Varian HNA'; ...
        '*.hnc' '(*.hnc) Varian HNC'; '*.dxf' '(*.dxf) Varian Text'};
    if ximvalid
        extfilter = [extfilter; {'*.xim' '(*.xim) Varian XIM'}];
    end
    [fname pname] = uigetfile(extfilter,'Select EPID file','C:\_Repo_WINNIPEG\trunk\Data');
    if isequal(fname,0)
        % Cancelled
        return;
    end
    FILENAME = fullfile(pname,fname);
end
% Set default values
if ~exist('invert','var') || isempty(invert)
    invert = 'on';
end

if ~exist('pixeloffset','var') || isempty(pixeloffset)
    pixeloffset = 2^14;
end

if ~exist('headeronly','var') || isempty(headeronly)
    headeronly = false;
end

% Check that the specified file exists
if ~exist(FILENAME,'file')
    error('Specified file not found: %s',FILENAME);
end

% Check arguments here

% Load the Image. Try dicom format first. If fails, try HNA, HNC. If still
% fails try DXF
try
    header=dicominfo(FILENAME);
    if ~headeronly
        DI=double(dicomread(header));
    else
        ImageMatrix = [];
    end
    filemode = 1;
    filetype = 'dcm';
catch
    try
        header = Read_HNA_header(FILENAME);
        ftypestring = deblank(header.FileType);
        HNAstring = 'VARIAN_VA_INTERNAL_1.0';
        HNCstring = 'VARIAN_VA_INTERNAL_HNCU_1.0';
        switch(ftypestring)
            case(HNAstring)
                filetype = 'hna';
                filemode = 2;
            case(HNCstring)
                filetype = 'hnc';
                header = Read_HNC_header(FILENAME);
                filemode = 3;
            otherwise
                % Can not read this type of file
                error(['Unable to read file type: ' ftypestring]);
        end
        if ~headeronly
            DI = double(read_image_hna(FILENAME));
        else
            ImageMatrix = [];
        end
    catch
        % Not a Varian HNx file
        try
            % If headeronly is set, DI will be an empty matrix
            [~,~,~,~,DI,header] = OpenVisionDose(FILENAME, headeronly);
            filemode = 4;
            filetype = 'dxf';
        catch
            if ximvalid
                try 
                    [DI, header] = XIMReader(FILENAME);
                    filemode = 5;
                    filetype = 'xim';
                    if isfield(header,'MVDoseStop') && isfield(header,'MVDoseStart')
                        if (header.MVDoseStop - header.MVDoseStart) > 0  
                          DI = DI ./ (header.MVDoseStop - header.MVDoseStart);
                        end
                    end
                catch
                    error('Unrecognized file format');
                end
            else
                error('Unrecognized file format');
            end
        end
    end

end
% At this point, have determined which type of file and have defined the
% variables header and DI. Header contains different information depending
% on which type of file is being read. Need to treat the cases differently
% below.
% Filemode tells which type of file: 1 - dicom, 2 - hna, 3 - hnc, 4 - dxf

switch filemode
    case 1
        % find which EPID
        switch(header.Manufacturer)
            case {'Varian Medical Systems','Varian'}
                temp = strfind(header.RTImageDescription,'Avg''s');
                if isempty(temp) % IAS3
                    temp = strfind(header.RTImageDescription,'Frames');
                    Nframes=sscanf(header.RTImageDescription(temp+6:end),'%f');
                    if ~headeronly
                        if strcmp(header.RTImageLabel(1:3),'MFF')  % if a FF acquisition
                            ImageMatrix = DI;
                        else
                            ImageMatrix = 2^14 - DI;
                        end
                    end
                else % IAS2
                    Nframes=sscanf(header.RTImageDescription(temp+5 : end),'%f');
                    if ~headeronly
                        if strcmp(header.RTImageLabel(1:3),'MFF')  % if a FF acquisition
                            ImageMatrix = DI - 2^15;
                        else
                            ImageMatrix = 2^15 - DI;
                        end
                    end
                end
            case ('Siemens Oncology Care Systems')
                if ~headeronly
                    ImageMatrix = DI;
                end
                Nframes = str2double(char(header.Private_0039_1577));
            case ('ELEKTA')
                if ~headeronly
                    Offset = 2^16;
                    ImageMatrix = Offset - DI;
                end
                Nframes = 1;
            case ('IBA Dosimetry')
                if ~headeronly
                    ImageMatrix = DI;
                end
                Nframes = 1;
            otherwise
%                 fprintf('No EPID type identified\n')
%                 ImageMatrix = 0;
%                 Nframes = 0;
                error('No EPID type identified');
        end
    case 2
        % HNA file - Header does not include information about pixel offset
        % or inversion. Use values supplied in arguments
        Nframes = 1;
        if ~headeronly
            ImageMatrix = DI - pixeloffset;
            if strcmp(invert,'on')
                ImageMatrix = -ImageMatrix;
            end
        end
    case 3
        % HNC file - Header contains information about pixel offset and
        % file type. Flood field images not inverted, others are
        Nframes = header.MetersetExposure;
        if ~headeronly
            pixeloffset = double(header.PixelOffset);
            ImageMatrix = DI - pixeloffset;
            imtype = deblank(header.ImageType);
            switch imtype
                case 'MFF'
                    % No inversion for flood field
                otherwise
                    ImageMatrix = -ImageMatrix;
            end
        end
    case 4
        Nframes = 1;
        % If headeronly was specified, DI is empty from OpenVisionDose
        % function so just assign to ImageMatrix
        ImageMatrix = DI;
    case 5
        Nframes = 1;
        if ~headeronly
            if isfield(header,'DataOffset')
                pixeloffset = double(header.DataOffset);
            end
            if isfield(header,'ImageFlipped')
                if header.ImageFlipped
                    invert = 'on';
                else
                    invert = 'off';
                end
            end
            switch invert
                case 'on'
                    ImageMatrix = pixeloffset - DI;
                case 'off'
                    ImageMatrix = DI - pixeloffset;
            end
        end

end

% if strcmp(header.Manufacturer,'Varian Medical Systems')
%     temp = strfind(header.RTImageDescription,'Avg''s');
%     if isempty(temp) % IAS3
%         temp = strfind(header.RTImageDescription,'Frames');
%         Nframes=sscanf(header.RTImageDescription(temp+6:end),'%f');
%         if strcmp(header.RTImageLabel(1:3),'MFF')  % if a FF acquisition
%             ImageMatrix = DI;
%         else
%             ImageMatrix = 2^14 - DI;
%         end
%     else % IAS2
%         Nframes=sscanf(header.RTImageDescription(temp+5 : end),'%f');
%         if strcmp(header.RTImageLabel(1:3),'MFF')  % if a FF acquisition
%             ImageMatrix = DI - 2^15;
%         else
%             ImageMatrix = 2^15 - DI;
%         end
%     end
% else
%     if strcmp(header.Manufacturer,'Siemens Oncology Care Systems')
%         ImageMatrix = DI;
%         Nframes = str2double(char(header.Private_0039_1577));
%     else
%         if strcmp(header.Manufacturer,'ELEKTA')
%             Offset = 2^16;
%             ImageMatrix = Offset - DI;
%             Nframes = 1;
%         else
%             fprintf('No EPID type identified\n')
%         end
%     end
% end




