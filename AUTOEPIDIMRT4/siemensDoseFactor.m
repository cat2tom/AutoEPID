function pixel_to_dose=siemensDoseFactor(depth_dose,ref_field_IMA)

% get the pixel to dose conversion factor from 10-by-10 field size
% input: depth_dose-the known dose at reference detph, like dose at 5.4cm
%        depth
%        ref_field_IMA-the Siemens' IMA file for 10x10cm field size
% output: pixel_to_dose-dose conversion factor 

pixel_data=dicomread(ref_field_IMA);

[row,col]=size(pixel_data);

% get the matrix of pixel data of 1cm area around the central axis

sub_area_matrix=pixel_data(row/2-20:row/2+20,col/2-20:col/2+20);

size(sub_area_matrix);

% get sub frame number array

[sub_frame_array,frame_number1]=getSiemensSubFrameNumber(ref_field_IMA);

total_frame_number=sum(sub_frame_array);

tmp2=sub_area_matrix*total_frame_number;

average_pixel=mean2(tmp2);

pixel_to_dose=depth_dose/average_pixel;
