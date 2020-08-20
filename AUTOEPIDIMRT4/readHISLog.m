
function  cell_list=readHISLog(his_log_file_name)

% input:  his_log_file_name-one his log file name for his images.
% output: read each line into a cell list 
 
               
        s={}; 
        fid = fopen(his_log_file_name); 
        
        tline = fgetl(fid);
        while ischar(tline)    
        s=[s;tline];    
        tline = fgetl(fid); 
        end 
      
       cell_list=s;
       
       fclose(fid);
end 
 