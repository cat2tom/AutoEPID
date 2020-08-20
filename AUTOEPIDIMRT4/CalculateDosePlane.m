function [doseplane xgrid ygrid] = CalculateDosePlane(DoseFile,SSD, depth)
%CalculateDosePlane reads dose plane from TPS and outputs
%Input Arguments:
%       DoseFile: File containing dicom (RTDose) dose plane image
%       SSD: numeric scalar containing source-surface distance of the dose
%       plane image (cm)
%       depth: numeric scalar containing depth of the dose plane
%Output Arguments:
%       doseplane: mxn array containing the dose plane
%       xgrid: nx1 array containing x values of the dose plane (cm) scaled
%       to the SSD distance
%       ygrid: mx1 array containing y values of the dose plane (cm) scaled
%       to the SSD distance


    % Check arguments here
    
    % Read the doseplane image
    [doseplane res] = LoadEclipseDosePlane(DoseFile);
    res_x = res(2)/10;
    res_y = res(1)/10;
    
    
    nrow = size(doseplane,1);
    ncol = size(doseplane,2);
    centrow = round(nrow/2);
    centcol = round(ncol/2);
    
    % Debugging information
%     display(['TPS x Resolution: ' num2str(res_x) ' cm']);
%     display(['TPS y Resolution: ' num2str(res_y) ' cm']);
%     display(['TPS x pixelss: ' num2str(ncol)]);
%     display(['TPS y pixels: ' num2str(nrow)]);
    
    % Compute the x and y values of the image at the surface based on the 
    % resolution, SDD and depth parameters
    %SSDfactor = (SSD / (SSD + depth));
    SSDfactor = 1;
    xgrid = ((1:ncol)' - centcol) .* res_x .* SSDfactor;
    ygrid = ((1:nrow)' - centrow) .* res_y .* SSDfactor;
    

end

