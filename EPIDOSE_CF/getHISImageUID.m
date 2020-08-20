function his_file_list=getHISImageUID(file_cell_list)

% input: file_cell_list-cell list containing each line of his log file.
% output: the cell array  of his file name for each field.

       index_list=strmatch('Image UID',file_cell_list);
       
       tmp_list={};
       
       for i=1:length(index_list)
           
           tmp1=file_cell_list{index_list(i)};
           
                      
           tmp2=tmp1(end-1:end);
           
           tmp_list{i}= tmp2;
           
       end
       
       his_file_list=tmp_list;
       
end 
           
           
           
           
       