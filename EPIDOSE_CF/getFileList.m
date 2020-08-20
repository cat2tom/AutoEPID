
function fileList = getFileList(dirName)

% This function return the list of filename including the directory
% Input: dirName: the name of directory
% Output: the list of file names in all directory

dirData = dir(dirName);      
dirIndex = [dirData.isdir];   
fileList = {dirData(~dirIndex).name}';  
if ~isempty(fileList)   
    fileList = cellfun(@(x) fullfile(dirName,x),...                     
        fileList,'UniformOutput',false);  
end
subDirs = {dirData(dirIndex).name};   
validIndex = ~ismember(subDirs,{'.','..'});                                                  %#   that are not '.' or '..'  
for iDir = find(validIndex)                     
    nextDir = fullfile(dirName,subDirs{iDir});        
    fileList = [fileList; getFileList(nextDir)];    
end

end
    