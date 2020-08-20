function treatment_name=getHISTreatmentName(file_cell_list)

% input: file_cell_list-cell list containing each line of his log file.
% output: the cell array  of his file name for each field.

           index_list=strmatch('Treatment',file_cell_list);
           
           tmp_treatment_name={};
           
           for i=1:length(index_list)
               
                                      
               tmp1=file_cell_list{index_list(i)};
           
               tmp_index1=findstr(':',tmp1);
           
                    
               tmp_string=tmp1(tmp_index1+1:end);
               
               tmp_treatment_name{i}=tmp_string;
           end 
                                 
           treatment_name=tmp_treatment_name;
           
         
end 
           
           
           
           
       