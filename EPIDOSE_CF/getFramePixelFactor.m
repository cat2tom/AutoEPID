function FPF_list=getFramePixelFactor(file_cell_list)

% input: file_cell_list-cell list containing each line of his log file
% output: the list of FPF factor for each beam following the order of beam

       index_list=strmatch('FramePixelFactor',file_cell_list);
       
       tmp_list=[];
       
       for i=1:length(index_list)
           
           tmp1=file_cell_list{index_list(i)};
           
           tmp2_index=findstr(':',tmp1);
           
           tmp2b=tmp1(tmp2_index+1:end);
           
           temp3=str2num(tmp2b);
           
           tmp_list=[tmp_list temp3];
           
       end
       
       FPF_list=tmp_list;
       
end 
           
           
           
           
       