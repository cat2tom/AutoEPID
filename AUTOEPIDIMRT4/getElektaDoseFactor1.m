function pixel_to_dose=getElektaDoseFactor(depth_dose,ref_field_HIS,ref_PSF)

% get the pixel to dose conversion factor from 10-by-10 field size
% input: depth_dose-the known dose at reference detph, like dose at 5.4cm
%        depth
%        ref_field_HiS-the Elekta's IMA file for 10x10cm field size
% output: pixel_to_dose-dose conversion factor 


pixel_data=readHISfile(ref_field_HIS);

DI = double(pixel_data);%convert 16bit data to double

%invert and offset data into correct format
DI=-(DI-2^16);

DISum = DI/ref_PSF;


[row,col]=size(DISum);

% get the matrix of pixel data of 1cm area around the central axis

sub_area_matrix=DISum(row/2-20:row/2+20,col/2-20:col/2+20);


% get frame number array

%total_frame_number=1/ref_PSF;

%tmp2=sub_area_matrix*total_frame_number;

average_pixel=mean2(sub_area_matrix);

pixel_to_dose=depth_dose/average_pixel;
