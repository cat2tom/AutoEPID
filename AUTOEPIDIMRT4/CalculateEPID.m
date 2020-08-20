function [EPIDcal EPIDx EPIDy] = CalculateEPID(EPIDfile, pixcent, pixcal, desiredSDD)
%Reads the image from the specified file and outputs calibrated data
%Input Arguments:
%       EPIDfile: full filename containing the EPID image. Must be in
%       Dicom, HNC or DXF format
%       pixcent: 1x2 numeric array containing centre pixel location of EPID
%       image. First element corresponds to x (columns), second element
%       corresponds to y (rows)
%       pixcal: numeric scalar representing the pixel calibration factor to
%       convert EPID signal to desired dose
%       desiredSDD: numeric scalar representing the Source-detector
%       distance that the image should be scaled to.


    % Check arguments here
    
    [EPIDcal epidheader EPIDframes] = LoadEpidImage(EPIDfile);
    EPIDcal = EPIDcal * EPIDframes .* pixcal;
    
    %Extract info about the image from the header
    params = {'RESOLUTIONX'; 'RESOLUTIONY'; 'SDD'};
    headerparams = GetHeaderInfo(epidheader,params);
    res_x = headerparams{1};
    res_y = headerparams{2};
    SDD = headerparams{3};
    
    % Convert Epid resolution (at image plane) to that at desired SDD
    res_x = res_x * (desiredSDD/SDD);
    res_y = res_y * (desiredSDD/SDD);
    
    nrow = size(EPIDcal,1);
    ncol = size(EPIDcal,2);
    
    EPIDx = ((1:ncol)' - pixcent(1)) .* res_x;
    EPIDy = ((1:nrow)' - pixcent(2)) .* res_y;

end

