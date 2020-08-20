function PSF = getPSFFromLog(dir_log_file_name,given_his_file_name )
% Return PSF for a given log_file_name
%   Input:  dir_log_file_name--the name of log file including path
%           given_his_file_name--the name of epid file name only.
    log_structure_list=hisLogToStructure(dir_log_file_name);
    
    for k=1:length(log_structure_list)
        
        tmp1=log_structure_list(k).file_name;
        
        if strcmp(tmp1,given_his_file_name)
            
            PSF=log_structure_list(k).pixel_factor;
            
        end 
        
    end 


end

