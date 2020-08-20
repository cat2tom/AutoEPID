function patient_name=getHISPatientName3(file_cell_list)

% input: file_cell_list-cell list containing each line of his log file.
% output: the cell array  of his file name for each field.

           index_list=strmatch('Patient',file_cell_list);
           
           tmp_patient_name={};
           
           for i=1:length(index_list)
               
                                      
               tmp1=file_cell_list{index_list(i)};
           
               tmp_index1=findstr(':',tmp1);
               
                                              
               tmp2=tmp1(tmp_index1+1:end);
           
               tmp2_index=findstr(',',tmp2);
               
               tmp2_part1=tmp2(1:tmp2_index-1);
               
               tmp2_part2=tmp2(tmp2_index+1:end);
               
               tmp3_string=[tmp2_part1 tmp2_part2];
               
               tmp_patient_name{i}=tmp3_string;
           end 
                                 
           patient_name=tmp_patient_name;
           
         
end 
           
           
           
           
       