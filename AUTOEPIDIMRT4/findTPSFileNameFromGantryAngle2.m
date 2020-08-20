function machedPin_TPS_file_name=findTPSFileNameFromGantryAngle2(tps_file_dir,epid_gantry_angle)

% rename Pinacle TPS file to be named with beam gantry angle only.
% input: tps_file_dir-the directory where TPS files sit.
% output: the tps file name renamed.
% Requirements: the tps file has to be named as: '0279385_Beam_1.02_100-TotalDose.txt'
% For XIO, the tpsfile has to be named like this.

% list all tps file

 tmp='';

chdir(tps_file_dir);

tps_file_list=dir('*.txt');

for i=1:length(tps_file_list)
    
    pin_tps_file_name=tps_file_list(i).name;
    
    
    [gantry_angle,coll_angle]=findGangtryandCollimatorAngleFromPinTPSFile(pin_tps_file_name);

      
    if  abs(epid_gantry_angle-gantry_angle)<=0.3
        
     tmp=tps_file_list(i).name;
            
    end 
      
end 
    
 machedPin_TPS_file_name=tmp;
