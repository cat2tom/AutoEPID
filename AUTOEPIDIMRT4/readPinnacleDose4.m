function [xgrid,ygrid, dose_plane2]=readPinnacleDose4(tps_dose_file,pixel_to_dose_factor)

% input: pin_dose_file_name-the name of xio dose file
% output: dose_plane-a matlab matrix containg the dose plane data in Gy 
%         row1 and col1 -the number of points in x and y directions.

fileExt=fileType(tps_dose_file);

%% Process dose file exported from Pinnacle. 
if strcmp(fileExt,'txt')
    
    
   [xgrid,ygrid, dose_plane2]=readPinnacleDose4b(tps_dose_file,1);
    
    
end 
%% Process opg file exported from RS 
if strcmp(fileExt,'opg')
    
    
   [xgrid,ygrid, dose_plane2]=readOPG(tps_dose_file);
    
    
end 
%%
% Process 3D dicom  file exported from RS 
if strcmp(fileExt,'dcm')
    
    
   [xgrid,ygrid, dose_plane2]=readDicomDose(tps_dose_file);
    
    
end 

end 

