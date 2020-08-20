
function [epid_file_list,log_file_list] =listEPIDLogFile(file_list)

% This function return the postfix of filename
% Input: file_list in one directory
% Output: two cell arrays for epid and log_file_list

tmp_epid_file_list={};
tmp_log_file_list={};

for i=1:length(file_list)
    
    tmp=fileType(file_list{i});
    
    if strcmp(tmp,'LOG')
        
        tmp_log_file_list=[tmp_log_file_list  file_list{i}];
        
    end
        
    if strcmp(tmp,'dcm')||strcmp(tmp,'IMA')
        tmp_epid_file_list=[tmp_epid_file_list file_list{i}];
    end
        
    epid_file_list=tmp_epid_file_list(1:end);
    
    log_file_list=tmp_log_file_list(1:end);
end
   
