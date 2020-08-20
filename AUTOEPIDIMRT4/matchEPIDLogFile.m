function log_file=matchEPIDLogFile(epid_file,log_file_list)

% return a epid_file name and corresponding log file for Elekta epid image.
% Input: epid_file: epid dicom image
% output: log_file corresponding to epid file

% get imageUID from Elekta EPID

head_data=dicominfo(epid_file);

epid_image_uid=head_data.SOPInstanceUID;

for i=1:length(log_file_list)
    
    log_file_name=log_file_list{i};
    log_image_uid=getImageUID(log_file_name);
    
    if strcmp(epid_image_uid,log_image_uid)
        
        log_file=log_file_list{i};
    end
    
end 

end 


