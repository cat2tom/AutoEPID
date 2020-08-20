function [frame_number,sub_frame_number]=getSiemensFrameNumber(IMA_image_name)

% To get the frame number and subframe number from Simens dicom file
% Input: IMA_image_name-the name of dicom image
% Output: frame_number array  and sub_frame_number

info=dicominfo(IMA_image_name);

tmp1_field=getFieldName(info,'SIEMENS MED OCS NUMBER OF SUB FRAMES');

tmp3_field=getFielfNmae(info,'SIEMENS MED OCS NUMBER OF FRAMES');

frame_number=0;
sub_frame_number=0;
if ~isempty(tmp1_field)
    
    tmp2=findstr('xx',tmp1_field);
    
    tmp2_sub_string=tmp1_field(1:tmp2-1);
    
    sub_frame_number=matchFieldName(info,tmp2_sub_string);
    
end 
if ~isempty(tmp3_field)
    tmp4=findstr('xx',tmp1_field);
    
    tmp4_sub_string=tmp1_field(1:tmp4-1);
    
    frame_number=matchFieldName(info,tmp4_sub_string);
    
end 
    
    
    
    
    
 
    
    

