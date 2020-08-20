function [dir_path, ext_cell] = getEPIDFileExtCell( given_dir )
%   Convert the file extension into a cell given a directory
%   Input: given_dir-the input directory
%   output: dir_path-the parth of directory
%           ext_cell-the cell of file extension for all the files found in
%           the folder.
% 

tmp1=getFileList(given_dir);

tmp2=listEPIDFile(tmp1);

tmp3={};

for k=1:length(tmp2)
   
    [path,name,ext]=fileparts(tmp2{k});
    
    dir_path=path;
    
    tmp3{k}=strcat(name,ext);
    
end

ext_cell=tmp3;

end

