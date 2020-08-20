function [sub_frame_number_array,frame_number]=getSiemensSubFrameNumber(IMA_image_name)

% To get the frame number and subframe number from Simens dicom file
% Input: IMA_image_name-the name of dicom image
% Output: sub_frame_number_array--the array of sub frame number
%         frame_number-total frame number for composite image.

info=dicominfo(IMA_image_name);

tmp1_field=getFieldName(info,'SIEMENS MED OCS NUMBER OF SUB FRAMES');


sub_frame_number=0;
if (~isempty(tmp1_field))
    
    tmp2=findstr('xx',tmp1_field);
    
    tmp2_sub_string=tmp1_field(1:tmp2-1);
    
    field_list=fieldnames(info);
    
    for i=1:length(field_list)
        
        tmp3_field_name=field_list{i};
        
        index=findstr(tmp2_sub_string,tmp3_field_name);
        
        if (~isempty(index))
           
            sub_frame_number=getfield(info,tmp3_field_name);
            
        end 
    end 
end 

sub_frame_number_array=sub_frame_number;

frame_number=length(sub_frame_number_array);
end 

    
    
    
    
    
 
    
    

