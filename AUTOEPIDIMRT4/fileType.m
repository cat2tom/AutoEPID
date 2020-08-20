
function file_type =fileType(file_name)

% This function return the postfix of filename
% Input: file_name
% Output: file_type

[dirpath,file,ext]=fileparts(file_name);

file_type=ext(2:end);

end
   
