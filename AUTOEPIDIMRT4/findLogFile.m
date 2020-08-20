
function log_file =findLogFile(file_list)

% This function return the postfix of filename
% Input: file_list in one directory
% Output: one cell arrays for epid file


% set log_file name as empty string in case if not file exist. 
log_file='';

for i=1:length(file_list)
    
    [path,name, ext]=fileparts(file_list{i});
             
    if strcmp(ext,'.LOG')
        
        if ~isdir(file_list{i})
          log_file=file_list{i};
        end 
          
                
    end

end 

if isempty(log_file)
    
    eventLogger('There is no EPID log file found','INFO','AutoEPID');
    
end 

end
   
