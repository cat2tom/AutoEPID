
function epid_file_list =listEPIDDicomFile(file_list)

% This function return the postfix of filename
% Input: file_list in one directory
% Output: one cell arrays for epid file

tmp_epid_file_list={};

for i=1:length(file_list)
    
    tmp=fileType(file_list{i});
             
    if strcmp(tmp,'dcm')||strcmp(tmp,'IMA')
        tmp_epid_file_list=[tmp_epid_file_list file_list{i}];
    end

end 

 epid_file_list=tmp_epid_file_list(1:end);
    
    
end
   
