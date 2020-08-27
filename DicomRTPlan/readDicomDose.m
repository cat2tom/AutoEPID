function [xgrid,ygrid, dose_plane2]=readDicomDose(dicom_dose_file)

% Extract coordinate and the 2D plane dose at given depth (eg. 5.4cm depth) from a 3D Dicom Dose file 

offset=[0 0 0];

% The EPID plane is located at y=6.92.
loc=6.69;%cm
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
    
    
  
    % flip left right 
    
    dose_plane2d=fliplr(dose_plane2c);
    
    % make sure the center of image matrix is at (0,0)
    
    
    dose_plane2=dose_plane2d;
    [m,n]=size(dose_plane2);
    
    ygrid=(-m/2+1:m/2)';
    xgrid=(-n/2+1:n/2)';
%     
       
else
    
    
    [ dicom_x, dicom_y,dose2D ] = read2DDicomDose(dicom_dose_file,offset);
    

    % flip up and down the image data
    dose2DTemp=dose2D;
    
    dose2DTemp1=flipud(dose2DTemp);
    dose2DTemp2=fliplr(dose2DTemp1);
    
    % make the image center at (0,0).
    dose_plane2=dose2DTemp2;
    
    [m,n]=size(dose_plane2);
    
    ygrid=(-m/2+1:m/2)';
    xgrid=(-n/2+1:n/2)';
     
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
