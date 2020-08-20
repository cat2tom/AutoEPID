function  renameTPSFiles

% rename Pinacle TPS file to be named with beam gantry angle only.
% input: tps_file_dir-the directory where TPS files sit.
% output: the tps file name renamed.
% Requirements: the tps file has to be named as: '0279385_Beam_1.02_100-TotalDose.txt'


% list all tps file



tps_file_list=dir('*.txt');


for i=length(tps_file_list)
    
    pin_tps_file_name=tps_file_list(1).name

   % find the index of char '-'

    hyphen_index=findstr(pin_tps_file_name,'-');

    % find second underline index

    underline_index=findstr(pin_tps_file_name,'_');

     second_underline_index=underline_index(end);

    % the gantry angle

     gantry_angle=pin_tps_file_name(second_underline_index+1:hyphen_index-1);
     
     new_name=[gantry_angle,'*.txt'];
     
%      tmp_dir_file_name=[tps_file_dir   '/'  pin_tps_file_name]
     
     movefile(pin_tps_file_name,new_name);
     
end 
    

