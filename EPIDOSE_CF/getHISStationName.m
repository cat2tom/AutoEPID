function station_name=getHISStationName(file_cell_list)

% input: file_cell_list-cell list containing each line of his log file.
% output: the cell array  of his file name for each field.

           index_list=strmatch('Station',file_cell_list);
       
           tmp1=file_cell_list{index_list(1)};
           
           tmp_index1=findstr(':',tmp1);
           
           station_name=tmp1(tmp_index1+1:end);
        
               
end 
           
           
           
           
       