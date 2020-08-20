function [xgrid,ygrid, dose_plane2]=readDicomDose(dicom_dose_file)

% Extract the plane dsoe at given depth. 

offset=[0 0 0];

% The EPID plane is located at y=6.92.
loc=6.92;%cm
orient='y';

% Judge if the file is 2D or 3D dicom file.

info=dicominfo(dicom_dose_file);

is3DDicomFile=isfield(info,'NumberOfFrames');

if is3DDicomFile
    
    [ dicm_x, dicm_y,dicm_z, dose3d ] = dicomDoseTOmat(dicom_dose_file, offset);
    
    
    dose_plane= getPlaneAt(dicm_x, dicm_y,dicm_z,dose3d,loc,orient);
    
       
    xgridTemp=dicm_x';
    
    ygridTemp=dicm_z;
    
    dose_plane2b=dose_plane';
    
    [xTemp,yTemp,interploagedDose2D]=interploateDose2D(xgridTemp,ygridTemp,dose_plane2b);
    
%     dose_plane2= dose_plane2b;
    
    dose_plane2c=interploagedDose2D;
    
    
    % swap the x and y axis.
    
    dose_plane2=flipud(dose_plane2c);
    
    xgrid=xTemp';
    ygrid=yTemp';
    
       
else
    
    
    [ dicom_x, dicom_y,dose2D ] = read2DDicomDose(dicom_dose_file,offset);
    
    xgrid=dicom_x';
    
    ygrid=dicom_y;
    
    dose_plane2=dose2D;
    

end 


end

function [xTemp,yTemp,interploagedDose2D]=interploateDose2D(xgrid,ygrid,dose2D)

% Interpolated 2D dose extrapolated dose from 3D dose dicom into 1mm
% resolution. 

[X,Y]=meshgrid(xgrid,ygrid);

xTemp=xgrid(1):0.1:xgrid(end);

yTemp=ygrid(1):0.1:ygrid(end);


[Xq,Yq]=meshgrid(xTemp,yTemp);


interploagedDose2D=interp2(X,Y,dose2D,Xq,Yq);


end 
