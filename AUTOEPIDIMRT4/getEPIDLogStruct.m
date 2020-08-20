function epid_log_struct= getEPIDLogStruct(log_struct_array,epid_full_file_name )
%  getEPIDLogStruct return struct for a given epid file name from log struct array.

%  @epid_full_file_name[string]: full epid file name
%  @log_struct_array[struct array]: struct array created from epid log
%  file.
%  @@ epid_log_struct[struct]: struct element containing log info for this epid file.


%  author: aitang xing



% epid_log_struct=log_struct_array(strcmp({log_struct_array.file_name},epid_full_file_name));

% get full path to epid file name to convert the file name in log struct
% into full path name.



[epid_file_path, epid_file_name, ext]=fileparts(epid_full_file_name);


for k=1:length(log_struct_array)
    
    epid_his_struct=log_struct_array(k);
    
    % get epid file name and reconstruct the full path file namme
    
    
    epid_file_name=epid_his_struct.file_name;
    
    epid_path_file_name=fullfile(epid_file_path,epid_file_name);
    
       
    
    if strcmp(epid_path_file_name,epid_full_file_name)
        
        epid_log_struct=epid_his_struct;
        
    end 
    
end 


end

