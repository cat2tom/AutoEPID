function [xgrid,ygrid, dose_plane2]=readPinnacleDose3(tps_dose_file)

%{
  This function servers as an interface to read files export from TPS. 
%}

% input: pin_dose_file_name-the name of xio dose file
% output: dose_plane-a matlab matrix containg the dose plane data in Gy 
%         row1 and col1 -the number of points in x and y directions.

fileExt=fileType(tps_dose_file);

%% Process dose file exported from Pinnacle. 
if strcmp(fileExt,'txt')
    
    
   [xgrid,ygrid, dose_plane2]=readPinnacleDose3b(tps_dose_file);
    
    
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