function  matched_HIS_file_name=matchElektaHIS2PinTPSFile(pin_tps_file_name)

% function: Given one pinnacle TPS file, find the matched HIS file. 
%           The HIS file name has to be renamed as Gantry angle.HIS,
%           eg.   153.HIS, assuming that the Pinnacle dose file name like,
%           '1176592_Beam_204-TotalDose.txt'
%
%           input: the pin_tps_file_name-the exported Pinnalce TPS file
%           name.
%           output: the mached HIS_file_name 

% find the index of char '-'

hyphen_index=findstr(pin_tps_file_name);

% find second underline index

underline_index=findstr(pin_tps_file_name)

second_underline_index=underline_index(2);

% the gantry angle

gangtry_angle=pin_tps_file_name(second_underline_index+1:hyphen_index-1);

% new HIS file name

matched_HIS_file_name=[gantry_angle  '.HIS'];




