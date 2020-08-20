% This is the main function for converting EPID image to dose image.

% V and H driver dir. If the directoyr is changed, just change the
% following two variables.


v_driver_dir='V:\';
h_driver_dir='H:\IMRT\PatientQA\2012';

cd(v_driver_dir);

current_dir=pwd;

dir_path=uigetdir(current_dir,'Choose a Patient directory'); % ask user to select directory

%get the last bit of dir and make a patient specific directory in H driver.

tmp_index=findstr('\',dir_path);

last_index=tmp_index(end);

last_dir_part=dir_path(last_index+1:end);

v_driver_patient_dir=dir_path;

original_driver_dir=v_driver_patient_dir

h_driver_patient_dir=[h_driver_dir '\' last_dir_part];

destination_patient_dir=h_driver_patient_dir

mkdir(h_driver_patient_dir);

cd(dir_path);


all_file_list=getFileList(dir_path); % list all file in the directory


% list epid files and log files into cell list

epid_file_list=listEPIDFile(all_file_list);


% get file type to see if they are Elekta file or Siemens files

file_type=fileType(epid_file_list{1});

progress_bar_lable='EPID to Dose image conversion';

if strcmp(file_type,'IMA')
  for i=1:length(epid_file_list)
    
       
  %if strcmp(file_type,'IMA')
  
         % turn off the warning message for Siemens EPID conversion.
         warning off 
        
        % direclty call Siments EPID2dose function
          progressbar();
          progress_message1='Converting EPID to Dose for EPID image file: ';
          
          [dir_path_tmp,filename_tmp,ext_tmp]=fileparts(epid_file_list{i});
          
          ima_file_name=[filename_tmp ext_tmp];
          
          progess_message2=ima_file_name;
          
          whole_message=strvcat(progress_message1,progess_message2); 
          
          disp(whole_message);
        
          epidSiemensToDosePinacle(epid_file_list{i});
        
          progressbar(double(i)/double(length(epid_file_list)));
        
        
  end 
end

if strcmp(file_type,'HIS')
    
      % copy template file from H driver to v patient directory. change the
      % following variable if the location is changed.
      
      h_driver_template_dir='H:\IMRT\PatientQA\Ekekta dicom template\Eleckta_template.dcm'

      copyfile(h_driver_template_dir,dir_path)

      [his_log_name, his_log_path] = uigetfile('*.HIS','Choose a his log file'); %select file
        
      dir_log_file_name=[his_log_path his_log_name];
      
      [template_name,template_path]=uigetfile('.dcm','Choose a template dcm file');
      
      dir_dicm_file_name=[template_path template_name];
      
      header=dicominfo(dir_dicm_file_name);
      
      log_structure_list=hisLogToStructure(dir_log_file_name);
      
      for j=1:length(log_structure_list)
          
          progress_message1='Converting EPID to Dose for EPID image file: ';
          
          progess_message2=log_structure_list(j).file_name;
          
          whole_message=[progress_message1 progess_message2]; 
          
          disp(whole_message);
          
          %progressbar(progress_bar_lable)
          
          progressbar();
                            
          tmp=log_structure_list(j);
          
          elektaHISToDosePinacle(header,tmp);
                  
          
          progressbar(double(j)/double(length(log_structure_list)));
          
      end

end

% after dose conversion copy EPID and dose image to h driver patient directory

all_file_list2=getFileList(dir_path); % list all file in the directory

% firstly copy all EPID images file from v to h driver

for i=1:length(all_file_list2)
    
    copyfile(all_file_list2{i},h_driver_patient_dir)
    
end   


% open the patient directory folder in H driver for inspection.

winopen(destination_patient_dir);

done=strvcat('The conversion from EPID images to dose image was done and saved in',h_driver_patient_dir);

msgbox(done);



 
      
 

      
      
     
     
     
     
     
     
     
    

    










