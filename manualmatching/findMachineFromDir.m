function machine_name = findMachineFromDir(patient_dir )
% To find the machine name given that the EPID file for Siemens and Log
% file for Elekata.
% Input:  patient_dir-the name of patient dir folder
% Output: machine_name-the name of machine. return 0 if there are no files.

% set machine_name as local global

machine_name='';

all_file_list=getFileList(patient_dir); % list all file in the directory


if length(all_file_list)>=1

% list epid files and log files into cell list



epid_file_list=listEPIDFile(all_file_list);


if isempty(epid_file_list)
    
    machine_name='';
% get file type to see if they are Elekta file or Siemens files
else
    
file_type=fileType(epid_file_list{1});


if strcmp(file_type,'IMA')

    machine_name='M3';
end 

if strcmp(file_type,'HIS')

    
   log_file=findLogFile(all_file_list);
   
   if isempty(log_file)
       
      eventLogger('Could not find machine name as there is no the epid logger file','INFO','AutoEPID');
   
   end 
 
   if ~isempty(log_file) && exist(log_file,'file')
       
        log_structure_list=hisLogToStructure(log_file);
        
        if ~isempty(log_structure_list)
            
             one_his_structure=log_structure_list(1);
             his_station_name=one_his_structure.station_name;
             
                       
            
           if strcmp(his_station_name,' M1_IVIEW')
               
                
              machine_name='M1';
    
           end

           if strcmp(his_station_name,' M2Agility')
    
               machine_name='M2';

           end   
         
		   if strcmp(his_station_name,' M4')
    
               machine_name='M4';

           end

           if strcmp(his_station_name,' M5Versa_iView')
    
               machine_name='M5';

           end	   
            
           % added machine 7 support using station name.
            if strcmp(his_station_name,' M7Versa')
    
               machine_name='M7';

           end	   
           
        end 
      
   else
       
       eventLogger('Could not find machine name as there is no the epid logger file','INFO','AutoEPID');
       
             
   end 
        
end 

end 

else
    
    machine_name='';

end 
end

