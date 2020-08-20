function field_name=getHISFieldName(file_cell_list)

% input: file_cell_list-cell list containing each line of his log file.
% output: the cell array  of his file name for each field.

           index_list=strmatch('Field',file_cell_list);
           
           tmp_field_name={};
           
           for i=1:length(index_list)
               
                                     
                tmp1=file_cell_list{index_list(i)};
           
                tmp1_index1=findstr(':',tmp1);
           
           
                tmp1_string=tmp1(tmp1_index1+1:end);
           
          
                tmp_field_name{i}=tmp1_string;
           
           end           
         
          field_name=tmp_field_name;
end 
           
           
           
           
       