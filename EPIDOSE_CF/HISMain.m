

dir_path=uigetdir('C:\aitang research\EPID IMRT commisioning\AitangLogandEPIDdose\Elketa','Choose Patient directory'); % ask user to select directory

cd(dir_path);

all_file_list=getFileList(dir_path) % list all file in the directory

% list epid files and log files into cell list

epid_file_list=listEPIDFile(all_file_list)

epid_file_list{1}

% get file type to see if they are Elekta file or Siemens files

file_type=fileType(epid_file_list{1})


if strcmp(file_type,'IMA')
  for i=1:length(epid_file_list)
    
       
  %if strcmp(file_type,'IMA')
        
        % direclty call Siments EPID2dose function
        
        epidSiemensToDose(epid_file_list{i});
  end 
end

if strcmp(file_type,'HIS')
      
      [his_log_name, his_log_path] = uigetfile('*.HIS','Choose a his log file'); %select file
        
      dir_log_file_name=[his_log_path his_log_name];
      
      [template_name,template_path]=uigetfile('.dcm','Choose a template dcm file');
      
      dir_dicm_file_name=[template_path template_name];
      
      header=dicominfo(dir_dicm_file_name);
      
      log_structure_list=hisLogToStructure(dir_log_file_name);
      
      for j=1:length(log_structure_list)
          
          tmp=log_structure_list(j);
          
          elektaHISToDose(header,tmp);
          
      end 
      
end 
 

      
 

      
      
     
     
     
     
     
     
     
    

    










