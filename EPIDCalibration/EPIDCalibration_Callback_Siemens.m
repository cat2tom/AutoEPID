function [ cal_S] = EPIDCalibration_Callback_Siemens(machine,ref_mu,dose,epid_image_file, output_dir,physicist)
%calculate caliration factor and write them to calibraion file. The
%calbiration details saved in a matlab structure array.
% input: machine-machine name eg. M1,M2
%        mus-MU used for calbiration
%        refdose-the reference dose in cGy at 5.4 cm depth
%        epid_image_file--calibration epid image file including the full
%        path
%        output_dir---the directory where to save the calbiraton files
%        physicist-the person who perfomed the calibration
% output: 


cal_S=struct();

% M3 block code

if strcmp(machine,'M3')
    
     M3_CAL=struct([]);
     
     tmp=M3_CAL;
     
     if ref_mu==100
         
           ref_dose=dose;% cGy
     else
           ref_dose=dose/100*ref_mu;
          
     end
    
     dose_factor=getSiemensDoseFactor(ref_dose,epid_image_file);
     
    if isempty(tmp) 
        
       tmp(1).machine_name='M3';
     
       tmp(1).cal_factor=dose_factor;
     
       tmp(1).physicist=physicist;
     
       tmp(1).date=date;
     
       tmp(1).cal_file=fullfile(output_dir,'EPID_CALIBRATION.mat');
       
    else
        
        tmp2=lenght(tmp);
        
        tmp(tmp2+1).machine_name='M3';
     
        tmp(tmp2+1).cal_factor=dose_factor;
     
        tmp(tmp2+1).physicist=physicist;
     
        tmp(tmp2+1).date=date;
     
        tmp(tmp2+1).cal_file=fullfile(output_dir,'EPID_CALIBRATION.mat');
       
           
    end
    
    cal_S=tmp;    
    
    
end 

% M5 block code

if strcmp(machine,'M5')
    
     M5_CAL=struct([]);
     
     tmp=M5_CAL;
    
     if ref_mu==100
         
           ref_dose=dose;% cGy
     else
           ref_dose=dose/100*ref_mu;
          
     end
    
     dose_factor=getSiemensDoseFactor(ref_dose,epid_image_file);
     
     if isempty(tmp) 
        
       tmp(1).machine_name='M5';
     
       tmp(1).cal_factor=dose_factor;
     
       tmp(1).physicist=physicist;
     
       tmp(1).date=date;
     
       tmp(1).cal_file=fullfile(output_dir,'EPID_CALIBRATION.mat');
       
     else
        
        tmp2=lenght(tmp);
        
        tmp(tmp2+1).machine_name='M5';
     
        tmp(tmp2+1).cal_factor=dose_factor;
     
        tmp(tmp2+1).physicist=physicist;
     
        tmp(tmp2+1).date=date;
     
        tmp(tmp2+1).cal_file=fullfile(output_dir,'EPID_CALIBRATION.mat');
       
     end
     
    cal_S=tmp;   
    
end 


end

