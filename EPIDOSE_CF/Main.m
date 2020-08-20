

dir_path=uigetdir('C:\aitang research\EPID IMRT commisioning\AitangLogandEPIDdose\Elketa','Choose Patient directory'); % ask user to select directory

cd(dir_path);

all_file_list=getFileList(dir_path); % list all file in the directory

% list epid files and log files into cell list

[epid_file_list,log_file_list]=listEPIDLogFile(all_file_list);

% get file type to see if they are Elekta file or Siemens files

file_type=fileType(epid_file_list{1});

for i=1:length(epid_file_list)
    
  if strcmp(file_type,'dcm')
      
      % get the log file corresponding to the Ekekta EPID file
      
      epid_log_file_name=matchEPIDLogFile(epid_file_list{i},log_file_list);
      
      % call Elekta EPId2dose function to convert it into dose image
      
      epidElektaToDose(epid_file_list{i},epid_log_file_name);
  end 
      
  if strcmp(file_type,'IMA')
        
        % direclty call Siments EPID2dose function
        
        epidSiemensToDose(epid_file_list{i});
  end 
        
  
end 
      
 

      
      
     
     
     
     
     
     
     
    

    










