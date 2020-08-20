


classdef PatientValidator
    % Validate patient folder and associated files.
    
        
    properties
        
        patient_folder
        
    end
    
    methods
        
        % constructor 
        
        function  obj=PatientValidator(patient_folder)
            
            obj.patient_folder=patient_folder;
                       
            
        end 
        
        % get patient folder 
        
        function patient_folder=get.patient_folder(obj)
            
            patient_folder=obj.patient_folder;
            
        end 
            
        % check if there are two subfolder EPID and TPS exist
        
        function  is_exist=subFoldersExist(obj)
            
            % Check if the patient folder has two subfolder named EPID and
            % TPS.
            
            % get all subfolders
            
            dir_list=dir(obj.patient_folder);
            
            dir_flag=[dir_list.isdir] & ...
                     ~strcmp({dir_list.name},'.') & ...
                     ~strcmp({dir_list.name},'..') & ...
                     strcmp({dir_list.name},'EPID') & ~strcmp({dir_list.name},'TPS');
            
            dir_list=dir_list( dir_flag);
            
            
            if isempty(dir_list)
                
                is_exist=true;
                
            else
                
                is_exist=false;
                           
            end
        end 
        
            
        % check if HIS file exist or file ends not with .HIS, such as .his or His etc.
        
       function HIS_exist=hisExist(obj)
           
       % Check if HIS   file exist or file ends with.His or his ect. 
       
       
       
                      
       
       
       end 
          
            
      
                
        
        
        
        
    end
    
end

