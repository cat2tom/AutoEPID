function [ tmp ] = EPIDCalibration_Callback(machine,ref_mu,dose,epid_image_file, output_dir,physicist)
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

tmp=struct([]);


if strcmp(machine,'M3')
    
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
     
       tmp(1).cal_file=fullfile(output_dir,'M3.mat');
       
    else
        
        tmp2=lenght(tmp);
        
        tmp(tmp2+1).machine_name='M3';
     
        tmp(tmp2+1).cal_factor=dose_factor;
     
        tmp(tmp2+1).physicist=physicist;
     
        tmp(tmp2+1).date=date;
     
        tmp(tmp2+1).cal_file=fullfile(output_dir,'M3.mat');
       
           
    end
    
        
    
    
end 

if strcmp(machine,'M5')
    
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
     
       tmp(1).cal_file=fullfile(output_dir,'M5.mat');
       
    else
        
        tmp2=lenght(tmp);
        
        tmp(tmp2+1).machine_name='M5';
     
        tmp(tmp2+1).cal_factor=dose_factor;
     
        tmp(tmp2+1).physicist=physicist;
     
        tmp(tmp2+1).date=date;
     
        tmp(tmp2+1).cal_file=fullfile(output_dir,'M5.mat');
       
           
    end
     
     
     
    
end 


if strcmp(machine,'M1')
    
     log_structure_list=hisLogToStructure(dir_log_file_name);
      
      % use log_structure_list to get PSF for reference field only if the
      % user say yes.
      
    
       ref_PSF=1;
      
       machine_name=' ';
       
       [path, filename,ext]=fileparts(epid_image_file);
       
       ref_field_file_name=strcat(filename,ext);
       
       for j=1:length(log_structure_list)
          
          tmp11=log_structure_list(j);
          
          tmp_fname=tmp11.file_name;
          
          if strcmp(tmp_fname,ref_field_file_name)
              
                       
              ref_PSF=tmp11.pixel_factor;
              
              machine_name=tmp11.station_name;
          end 
          
       end 
      
       if ref_mu==100
             dose_at_54mm_depth=dose;% cGy
       else
             dose_at_54mm_depth=dose/100*ref_mu;
          
       end
       
       
       dose_factor=getElektaDoseFactor3(dose_at_54mm_depth,ref_field_file_name,ref_PSF,machine_name);
    
       tmp.machine_name='M1';
     
       tmp.cal_factor=dose_factor;
     
       tmp.physicist=physicist;
     
       tmp.date=date;
     
       tmp.cal_file=fullfile(output_dir,'M1.mat');
    
end 


end

