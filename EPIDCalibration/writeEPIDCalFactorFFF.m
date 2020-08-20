function [ cal_file_name ] = writeEPIDCalFactorFFF(output_dir,machine,beam_type,cal_struct)
%Write EPID calibration factor to a file called EPID_CALIBRATION.mat.
%   Arguments: Input:  output_dir--the output directory for calibration files.
%                      machine-the name of the machine.
%                      beam_type: the type of beam-FFF or None FFF
%
%              Output: cal_file_name--the name of calibration.
%              
% function was modified to incoporate the FFF beam. calibration.
tmp1=fullfile(output_dir,'EPID_CALIBRATION.mat');


if exist(tmp1,'file')

    
    load(tmp1);
    
    vars=whos('-file',tmp1);
    
    % M1 block code
    
    if strcmp(machine,'M1')
        
        
        if ~ismember('M1_CAL',{vars.name})       
                  
           M1_CAL(1).machine_name=cal_struct.machine_name;
     
           M1_CAL(1).cal_factor=cal_struct.cal_factor;
     
           M1_CAL(1).physicist=cal_struct.physicist;
     
           if strcmp(beam_type,'fff')
           
              % write FFF into date string.
               old_date=cal_struct.date;
               
               new_date=strcat(old_date,'_FFF');
               
               M1_CAL(1).date=new_date;
               
           else
               
               M1_CAL(1).date=cal_struct.date;
               
           end 
     
           M1_CAL(1).cal_file=cal_struct.cal_file;
            
        
        else
            
           tmp2=length(M1_CAL); 
           M1_CAL(tmp2+1).machine_name=cal_struct.machine_name;
     
           M1_CAL(tmp2+1).cal_factor=cal_struct.cal_factor;
     
           M1_CAL(tmp2+1).physicist=cal_struct.physicist;
     
           if strcmp(beam_type,'fff')
               
              % write FFF into date string.
               old_date=cal_struct.date;
               
               new_date=strcat(old_date,'_FFF') 
               
               M1_CAL(tmp2+1).date=new_date;
              
           else
               
               M1_CAL(1).date=cal_struct.date;
               
           end 
     
           M1_CAL(tmp2+1).cal_file=cal_struct.cal_file;
           
        end
        
        save(tmp1,'M1_CAL','-append');
        
        cal_file_name=tmp1;
        
    end
     
% m2 block code    
  
  if strcmp(machine,'M2')
        
       
                          
       if ~ismember('M2_CAL',{vars.name})  
            
           M2_CAL(1).machine_name=cal_struct.machine_name;
     
           M2_CAL(1).cal_factor=cal_struct.cal_factor;
     
           M2_CAL(1).physicist=cal_struct.physicist;
     
           
           if strcmp(beam_type,'fff')
               
              % write FFF into date string.
              old_date=cal_struct.date;
               
              new_date=strcat(old_date,'_FFF'); 
               
              M2_CAL(1).date=new_date;
           
           else
               
              M2_CAL(1).date=cal_struct.date;;
           end 
     
           M2_CAL(1).cal_file=cal_struct.cal_file;
            
        
        else
            
           tmp2=length(M2_CAL); 
           M2_CAL(tmp2+1).machine_name=cal_struct.machine_name;
     
           M2_CAL(tmp2+1).cal_factor=cal_struct.cal_factor;
     
           M2_CAL(tmp2+1).physicist=cal_struct.physicist;
           
           if strcmp(beam_type,'fff')
               
              % write FFF into date string.
              old_date=cal_struct.date;
               
              new_date=strcat(old_date,'_FFF'); 
               
              M2_CAL(tmp2+1).date=new_date;
           
           else
               
              M2_CAL(tmp2+1).date=cal_struct.date;
           end 
           
             
           M2_CAL(tmp2+1).cal_file=cal_struct.cal_file;
           
        end
        
        save(tmp1,'M2_CAL','-append');
        
        cal_file_name=tmp1;
        
    end
     
% M3 block code

if strcmp(machine,'M3')
        
             
        if ~ismember('M3_CAL',{vars.name})  
            
           M3_CAL(1).machine_name=cal_struct.machine_name;
     
           M3_CAL(1).cal_factor=cal_struct.cal_factor;
     
           M3_CAL(1).physicist=cal_struct.physicist;
     
           M3_CAL(1).date=cal_struct.date;
     
           M3_CAL(1).cal_file=cal_struct.cal_file;
            
        
        else
            
           tmp2=length(M3_CAL); 
           
           M3_CAL(tmp2+1).machine_name=cal_struct.machine_name;
     
           M3_CAL(tmp2+1).cal_factor=cal_struct.cal_factor;
     
           M3_CAL(tmp2+1).physicist=cal_struct.physicist;
     
           M3_CAL(tmp2+1).date=cal_struct.date;
     
           M3_CAL(tmp2+1).cal_file=cal_struct.cal_file;
           
        end
        
        save(tmp1,'M3_CAL','-append');
        
        cal_file_name=tmp1;
        
    end
     

% M4 block code 

if strcmp(machine,'M4')
        
          
        
        if ~ismember('M4_CAL',{vars.name})   
           M4_CAL(1).machine_name=cal_struct.machine_name;
     
           M4_CAL(1).cal_factor=cal_struct.cal_factor;
     
           M4_CAL(1).physicist=cal_struct.physicist;
     
           if strcmp(beam_type,'FFF')
               
             % write FFF into date string.
              old_date=cal_struct.date;
               
              new_date=strcat(old_date,'_FFF'); 
              
              M4_CAL(1).date=new_date;
               
               
           else
               
              M4_CAL(1).date=cal_struct.date;
               
           end 
           
              
           M4_CAL(1).cal_file=cal_struct.cal_file;
            
        
        else
            
           tmp2=length(M4_CAL); 
           M4_CAL(tmp2+1).machine_name=cal_struct.machine_name;
     
           M4_CAL(tmp2+1).cal_factor=cal_struct.cal_factor;
     
           M4_CAL(tmp2+1).physicist=cal_struct.physicist;
           
           if strcmp(beam_type,'fff')
               
             % write FFF into date string.
              old_date=cal_struct.date;
               
              new_date=strcat(old_date,'_FFF'); 
              
              M4_CAL(tmp2+1).date=new_date;
               
               
           else
               
              M4_CAL(tmp2+1).date=cal_struct.date;
               
           end 
           
     
            
           M4_CAL(tmp2+1).cal_file=cal_struct.cal_file;
           
        end
        
        save(tmp1,'M4_CAL','-append');
        
        cal_file_name=tmp1;
        
end
     

% M5 block code

if strcmp(machine,'M5')
        
             
       if ~ismember('M5_CAL',{vars.name})  
            
           M5_CAL(1).machine_name=cal_struct.machine_name;
     
           M5_CAL(1).cal_factor=cal_struct.cal_factor;
     
           M5_CAL(1).physicist=cal_struct.physicist;
           
           if strcmp(beam_type,'fff')
               
              % write FFF into date string.
              old_date=cal_struct.date;
               
              new_date=strcat(old_date,'_FFF'); 
              
              M5_CAL(1).date=new_date;
              
              
           else
               
              M5_CAL(1).date=cal_struct.date;  
               
           end 
           
     
               
           M5_CAL(1).cal_file=cal_struct.cal_file;
            
        
        else
            
           tmp2=length(M5_CAL); 
           M5_CAL(tmp2+1).machine_name=cal_struct.machine_name;
     
           M5_CAL(tmp2+1).cal_factor=cal_struct.cal_factor;
     
           M5_CAL(tmp2+1).physicist=cal_struct.physicist;
           
           if strcmp(beam_type,'fff')
               
              % write FFF into date string.
              old_date=cal_struct.date;
               
              new_date=strcat(old_date,'_FFF'); 
              
              M5_CAL(tmp2+1).date=new_date;
              
              
           else
               
              M5_CAL(tmp2+1).date=cal_struct.date;  
               
           end 
           
                  
           M5_CAL(tmp2+1).cal_file=cal_struct.cal_file;
           
        end
        
        save(tmp1,'M5_CAL','-append');
        
        cal_file_name=tmp1;
        
end


%% 


        
else
 
    
    if strcmp(machine,'M1')
    
       M1_CAL=cal_struct;
 
       save(tmp1,'M1_CAL');
       
       cal_file_name=tmp1;
       
    end 
       
    
    if strcmp(machine,'M2')
    
       M2_CAL=cal_struct;
 
       save(tmp1,'M2_CAL');
       
       cal_file_name=tmp1;
       
    end 
    
     if strcmp(machine,'M3')
    
       M3_CAL=cal_struct;
 
       save(tmp1,'M3_CAL');
       
       cal_file_name=tmp1;
       
     end 
         
    
     if strcmp(machine,'M4')
    
       M4_CAL=cal_struct;
 
       save(tmp1,'M4_CAL');
       
       cal_file_name=tmp1;
       
     end 
         
    if strcmp(machine,'M5')
    
       M5_CAL=cal_struct;
 
       save(tmp1,'M5_CAL');
       
       cal_file_name=tmp1;
       
    end 
         
         
end 



end

