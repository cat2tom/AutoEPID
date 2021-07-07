function [ cal_S ] = EPIDCalibration_Callback_Elekta(machine,ref_mu,dose,epid_image_file, dir_log_file_name, output_dir,physicist)
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

% general cal_S


cal_S=struct();

% M1 block code

if strcmp(machine,'M1')
    
     M1_CAL=struct([]);
     
     tmp=M1_CAL;
    
     log_structure_list=hisLogToStructure(dir_log_file_name);
      
      % use log_structure_list to get PSF for reference field only if the
      % user say yes.
      
    
       ref_PSF=1;
      
       machine_name=' ';
       
       [path, filename,ext]=fileparts(epid_image_file);
       
       ref_field_file_name=strcat(filename,ext);
       
       %ref_field_file_name=fullfile(path,ref_field_file_name1)
       
       for j=1:length(log_structure_list)
          
          tmp11=log_structure_list(j);
          
          tmp_fname=tmp11.file_name;
          
          if strcmp(tmp_fname,ref_field_file_name)
              
                       
              ref_PSF=tmp11.pixel_factor
              
              machine_name=tmp11.station_name;
          end 
          
       end 
      
       if ref_mu==100
             dose_at_54mm_depth=dose;% cGy
       else
             dose_at_54mm_depth=dose/100*ref_mu;
          
       end
       
      
      % use full path to EPID images 
      
       dose_factor=getElektaDoseFactor3(dose_at_54mm_depth,epid_image_file,ref_PSF,machine_name);
       
       
       if isempty(tmp) 
        
       tmp(1).machine_name='M1';
     
       tmp(1).cal_factor=dose_factor;
     
       tmp(1).physicist=physicist;
     
       tmp(1).date=date;
     
       tmp(1).cal_file=fullfile(output_dir,'EPID_CALIBRATION.mat');
       
       else
        
        tmp2=lenght(tmp);
        
        tmp(tmp2+1).machine_name='M1';
     
        tmp(tmp2+1).cal_factor=dose_factor;
     
        tmp(tmp2+1).physicist=physicist;
     
        tmp(tmp2+1).date=date;
     
        tmp(tmp2+1).cal_file=fullfile(output_dir,'EPID_CALIBRATION.mat');
        
       end 
       
       cal_S=tmp;
               
end
  
% m2 block code

if strcmp(machine,'M2')
    
     M2_CAL=struct([]);
     
     tmp=M2_CAL;
    
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
              
                       
              ref_PSF=tmp11.pixel_factor
              
              machine_name=tmp11.station_name;
          end 
          
       end 
      
       if ref_mu==100
             dose_at_54mm_depth=dose;% cGy
       else
             dose_at_54mm_depth=dose/100*ref_mu;
          
       end
       
       
       dose_factor=getElektaDoseFactor3(dose_at_54mm_depth,epid_image_file,ref_PSF,machine_name);
       
       
       if isempty(tmp) 
        
         tmp(1).machine_name='M2';
     
         tmp(1).cal_factor=dose_factor;
     
         tmp(1).physicist=physicist;
     
         tmp(1).date=date;
     
         tmp(1).cal_file=fullfile(output_dir,'EPID_CALIBRATION.mat');
       
       else
        
        tmp2=lenght(tmp);
        
        tmp(tmp2+1).machine_name='M2';
     
        tmp(tmp2+1).cal_factor=dose_factor;
     
        tmp(tmp2+1).physicist=physicist;
     
        tmp(tmp2+1).date=date;
     
        tmp(tmp2+1).cal_file=fullfile(output_dir,'EPID_CALIBRATION.mat');
        
       end 
       
       cal_S=tmp;
end
   
% M4 block code

if strcmp(machine,'M4')
    
     M4_CAL=struct([]);
     
     tmp=M4_CAL;
    
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
              
                       
              ref_PSF=tmp11.pixel_factor
              
              machine_name=tmp11.station_name;
          end 
          
       end 
      
       if ref_mu==100
             dose_at_54mm_depth=dose;% cGy
       else
             dose_at_54mm_depth=dose/100*ref_mu;
          
       end
       
       
       dose_factor=getElektaDoseFactor3(dose_at_54mm_depth,epid_image_file,ref_PSF,machine_name);
       
       
       if isempty(tmp) 
        
         tmp(1).machine_name='M4';
     
         tmp(1).cal_factor=dose_factor;
     
         tmp(1).physicist=physicist;
     
         tmp(1).date=date;
     
         tmp(1).cal_file=fullfile(output_dir,'EPID_CALIBRATION.mat');
       
       else
        
        tmp2=lenght(tmp);
        
        tmp(tmp2+1).machine_name='M4';
     
        tmp(tmp2+1).cal_factor=dose_factor;
     
        tmp(tmp2+1).physicist=physicist;
     
        tmp(tmp2+1).date=date;
     
        tmp(tmp2+1).cal_file=fullfile(output_dir,'EPID_CALIBRATION.mat');
        
       end 
     
       cal_S=tmp;
end

if strcmp(machine,'M5')
    
     M5_CAL=struct([]);
     
     tmp=M5_CAL;
    
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
              
                       
              ref_PSF=tmp11.pixel_factor
              
              machine_name=tmp11.station_name;
          end 
          
       end 
      
       if ref_mu==100
             dose_at_54mm_depth=dose;% cGy
       else
             dose_at_54mm_depth=dose/100*ref_mu;
          
       end
       
       
       dose_factor=getElektaDoseFactor3(dose_at_54mm_depth,epid_image_file,ref_PSF,machine_name);
       
       
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

% M7 block 

if strcmp(machine,'M7')
    
     M7_CAL=struct([]);
     
     tmp=M7_CAL;
    
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
       
       
       dose_factor=getElektaDoseFactor3(dose_at_54mm_depth,epid_image_file,ref_PSF,machine_name);
       
       
       if isempty(tmp) 
        
         tmp(1).machine_name='M7';
     
         tmp(1).cal_factor=dose_factor;
     
         tmp(1).physicist=physicist;
     
         tmp(1).date=date;
     
         tmp(1).cal_file=fullfile(output_dir,'EPID_CALIBRATION.mat');
       
       else
        
        tmp2=lenght(tmp);
        
        tmp(tmp2+1).machine_name='M7';
     
        tmp(tmp2+1).cal_factor=dose_factor;
     
        tmp(tmp2+1).physicist=physicist;
     
        tmp(tmp2+1).date=date;
     
        tmp(tmp2+1).cal_file=fullfile(output_dir,'EPID_CALIBRATION.mat');
        
       end 
     
       cal_S=tmp;
end

% M3 MCTC 

if strcmp(machine,'M3')
    
     M3_CAL=struct([]);
     
     tmp=M3_CAL;
    
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
       
       
       dose_factor=getElektaDoseFactor3(dose_at_54mm_depth,epid_image_file,ref_PSF,machine_name);
       
       
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


             
end 




