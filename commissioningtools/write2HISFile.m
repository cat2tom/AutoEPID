function new_hisfile = write2HISFile(old_hisfile,new_hisfile,data)
%{

Write a matrix of unint16 data into a His file.

Input: 
    old_hisfile-old his file name
    new_hisfile-new his file name
    data-the matrix of uint16 (usually 1024x1024).

ouput: 
    new_hisfile-the new his file name.

%}

% get file handlers

old_fid = fopen(old_hisfile);

new_fid=fopen(new_hisfile,'w');

if old_fid == -1
    warning('File could not be opened');
    im = -1;
else
    % Read the file Header
    header = fread(old_fid,50,'uint16');
    
       
    % first write the same header to new file
    
    fwrite(new_fid,header,'uint16');
    
    
    % write the data
    
    
    data=data'; % rotate the image data to get same as original one.
    
    data_temp=uint16(data(:));
           
    fwrite(new_fid,data_temp,'uint16'); % no need to offset by 50. 
    
     
     
   % close the fid 

    fclose(old_fid);
    fclose(new_fid);

end

