function [ cal_file_name ] = deleteEPIDCalFactor(output_dir,machine,index_array)
%Write EPID calibration factor to a file called EPID_CALIBRATION.mat.
%   Arguments: Input:  output_dir--the output directory for calibration files.
%                      machine-the name of the machine.
%                      index_array-the index array of elements to be
%                      deleted.
%              Output: cal_file_name--the name of calibration.
%              

tmp1=fullfile(output_dir,'EPID_CALIBRATION.mat')

if exist(tmp1,'file')

    
    load(tmp1);
    
    vars=whos('-file',tmp1);
    
    class({vars.name})
    
       
    % M1 block code
    
    if strcmp(machine,'M1')
        
        
                  
           M1_CAL(index_array)=[];
          
           save(tmp1,'M1_CAL','-append');
        
                    
              
           cal_file_name=tmp1;
        
    end
     
% m2 block code    
  
  if strcmp(machine,'M2')
        
       
                          
                
           M2_CAL(index_array)=[];
     
           save(tmp1,'M2_CAL','-append');
           
           cal_file_name=tmp1;
           
        
      
  end 
     
% M3 block code

if strcmp(machine,'M3')
        
             
    
            
           M3_CAL(index_array)=[];
     
           save(tmp1,'M3_CAL','-append');
           
           cal_file_name=tmp1;
           
               
 end
     

% M4 block code 

if strcmp(machine,'M4')
        
          
        
      
           M4_CAL(index_array)=[];
     
           save(tmp1,'M4_CAL','-append');
           
           cal_file_name=tmp1;
           
              
end
     

% M5 block code

if strcmp(machine,'M5')
        
             
               
           M5_CAL(index_array)=[];
     
           save(tmp1,'M5_CAL','-append');
           
           cal_file_name=tmp1;
           
            
end


% M7 block 
      


if strcmp(machine,'M7')
        
             
               
           M7_CAL(index_array)=[];
     
           save(tmp1,'M7_CAL','-append');
           
           cal_file_name=tmp1;
           
            
end


end

