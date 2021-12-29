% This is the main function for converting EPID image to dose image.

% V and H driver dir. If the directoyr is changed, just change the
% following two variables.

function EPIDDOSE_CF(handles)

% disp(' To use EPIDDOSE, the exported EPID file extension must be:')
% disp('capital .IMA for Siemens and captial .HIS for Eleckta');
% disp('And put all EPID image file in one folder');
% disp('After exporting the file for Elekcta, Do not change the file name again');
% disp('After exporting the files for Siements, you can change file name');
% disp(',but the extention must be.IMA');



% v_driver_dir='V:\IMRT_Patient_QA';
% h_driver_dir='H:\IMRT\PatientQA\2015\IMRT';

v_driver_dir=handles.patient_list_dir;


h_driver_dir=handles.output_dir;


h_driver_dir=get(handles.all_output_dir,'string');

cd(v_driver_dir);

current_dir=pwd;


tps='Pinnacle';
      

% then chose directory

% dir_path=uigetdir(current_dir,'Choose a Patient directory'); % ask user to select directory

dir_path=get(handles.patient_folder,'string');

%get the last bit of dir and make a patient specific directory in H driver.

tmp_index=findstr('\',dir_path);

last_index=tmp_index(end);
second_last_index=tmp_index(end-1)

last_dir_part=dir_path(second_last_index+1:last_index-1);

v_driver_patient_dir=dir_path;

original_driver_dir=v_driver_patient_dir

v_patient_name_folder=fileparts(dir_path)

last_dir_part=handles.output_pat_name;

h_driver_patient_dir=[h_driver_dir '\' last_dir_part];

destination_patient_dir=h_driver_patient_dir;

mkdir(h_driver_patient_dir);

cd(dir_path);


epid_dir=get(handles.epid_folder,'string');


all_file_list=getFileList(dir_path); % list all file in the directory


% list epid files and log files into cell list

epid_file_list=listEPIDFile(all_file_list);

% get file type to see if they are Elekta file or Siemens files

file_type=fileType(epid_file_list{1});

progress_bar_lable='EPID to Dose image conversion';

% get dose factor main windows. 

def_cf=get(handles.default_cf,'string');

def_cf=str2double(def_cf);

def_machine_name=get(handles.machine_name);

% %% For Siemens machine
% if strcmp(file_type,'IMA')
%     
%       
%       % decide to get new pixel_to_dose factor or use default one
%       
%       ref_field=questdlg('Did you take image for 10x10 field at same SID as IMRT field image?','Choose Yes or No','Yes','No','Yes');
%       
%                        
%       % the dose at 5.4 cm depth for Siemens
%       
%       dose_at_54mm_depth=93.4; % cGy
%                       
%             
%       dose_factor=1;
%       if strcmp(ref_field,'Yes')
%           
%           % chose the reference field image file
%           
%           ref_field_file_name=uigetfile('*.IMA','Choose  file for 10x10 cm reference field .IMA file');
%           
%           prompt = {'Enter the MU used for reference field :'};
%           dlg_title = 'Input the MU for reference field';
%           num_lines = 1;
%           def = {'20'};
%           ref_mu = inputdlg(prompt,dlg_title,num_lines,def);
%       
%           ref_mu=str2num(ref_mu{1})
%       
%           if ref_mu==100
%             dose_at_54mm_depth=93.4;% cGy
%           else
%              dose_at_54mm_depth=93.4/100*ref_mu;
%           
%           end
%           
%           
%           dose_factor=getSiemensDoseFactor(dose_at_54mm_depth,ref_field_file_name);
%       end 
%         
%       dose_at_54mm_depth
%       
%       
%  if strcmp(ref_field,'No')
%           
%           disp('The pixel-to-dose factor measured at 145cm SID for M3');
%           disp('and measured at 150cm SID for M5 by Phil with ');
%           disp('Inverse square correction will be used');
%           
%           header=dicominfo(epid_file_list{1});
%           
%           machine=header.RadiationMachineName;
%           SID = double(char(header.RTImageSID)); 
% 		  
% 		  SID=SID/10;
%           
% 
%           M3_145cm_PixelCalFact=def_cf; %measured 21/5/2012 P. Vial
%         
%        
%          if strcmp(machine,'M3')
%     
%            %PixelCalFact=M3_145cm_PixelCalFact;
%            
%            PixelCalFact=M3_145cm_PixelCalFact*(SID/145)*(SID/145)
%            
%          end 
% 
%         
%          dose_factor=def_cf;
%       
%     
%          pixel_to_dose_factor=dose_factor
%         
%   for i=1:length(epid_file_list)
%     
%     
%          % turn off the warning message for Siemens EPID conversion.
%          warning off 
%         
%         % direclty call Siments EPID2dose function
%           progressbar();
%           progress_message1='Converting EPID to Dose for EPID image file: ';
%           
%           [dir_path_tmp,filename_tmp,ext_tmp]=fileparts(epid_file_list{i});
%           
%           ima_file_name=[filename_tmp ext_tmp];
%           
%           progess_message2=ima_file_name;
%           
%           whole_message=strvcat(progress_message1,progess_message2); 
%           
%           disp(whole_message);
%           
%           % choose right function for TPS system
%           
%           if strcmp(tps,'Xio')
%         
%               epidSiemensToDoseXio6(epid_file_list{i},dose_factor);
%               
%           end 
%           
%           if strcmp(tps,'Pinnacle')
%               
%                epidSiemensToDosePinacle6(epid_file_list{i},dose_factor);
%               
%           end 
%         
%           progressbar(double(i)/double(length(epid_file_list)));
%           
%           progressbar(double(i)/double(length(epid_file_list)));
%         
%   end 
% end
% 
% end % End code for Siemens machines.

%% For Elekta machine.

if strcmp(file_type,'HIS')
    
      %
      
      % decide to get new pixel_to_dose factor or use default one
      
      ref_field=questdlg('Did you take image for 10x10 field at same SID as IMRT field image?','Choose Yes or No','Yes','No','Yes');
       
           
      % copy template to patient directory  
      
          
      
      copyfile(handles.dicom_template_dir,dir_path);

%    
%       
    
      
      %% 1. User choose yes for reference field.
      
      if strcmp(ref_field,'Yes')
          
    
          
          % choose log file name for referencde field.
          
          [his_log_name, his_log_path] = uigetfile('*.LOG','Choose a his log file for reference field'); %select file
          
          % chose the reference field image file
          
          
          [path,file_name,ext]=uigetfile('*.HIS','Choose 10x10 cm reference field his file')
          
          ref_field_file_name=fullfile(file_name,path);
          
          
          calibration_dir_log_file_name=[his_log_path his_log_name];
          
          calibration_log_structure_list=hisLogToStructure(calibration_dir_log_file_name);
          
          
          
          
          % get one struct for calibration file  to other parameters.
          
          one_his_structure=calibration_log_structure_list(1);
          
          ref_PSF=one_his_structure.pixel_factor;
          
          machine_name=one_his_structure.station_name;
          
          % adde more
          
          prompt = {'Enter the MU used for reference field :'};
          dlg_title = 'Input the MU for reference field';
          num_lines = 1;
          def = {'20'};
          ref_mu = inputdlg(prompt,dlg_title,num_lines,def);
          
          ref_mu=str2num(ref_mu{1});
          
          if ref_mu==100
              dose_at_54mm_depth=93.9;% cGy
          else
              dose_at_54mm_depth=93.9/100*ref_mu;
              
          end
          
          
          dose_factor=getElektaDoseFactor3(dose_at_54mm_depth,ref_field_file_name,ref_PSF,machine_name);
          
          
          disp('The pixel-to-dose factor got from 10x10 field  is: ')  
          
          dose_factor
       
                  
          %%  Section converting patient EPID images to dose images.
          
          % choose log file name for patient field.
          
          [his_log_name, his_log_path] = uigetfile('*.LOG','Choose a his log file for patiend epid files'); %select file
          
          dir_log_file_name=[his_log_path his_log_name];
          
          
          % choose dicom template file
          
          [template_name,template_path]=uigetfile('*.dcm','Choose a template dcm file');
          
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
              
              if strcmp(tps,'Xio')
                  
                  elektaHISToDoseXio5_CF(header,tmp,dose_factor,epid_dir);
                  
              end
              
              if strcmp(tps,'Pinnacle')
                  
                  
                  elektaHISToDosePinnacle5_CF(header,tmp,dose_factor,epid_dir);
                  
              end
              
              
              progressbar(double(j)/double(length(log_structure_list)));
              
          end
          

      end % end session for Yes.
          
          
      
                   
   %% user choose no for reference field.
   
   if strcmp(ref_field,'No')
          
       disp('The default pixel_to_dose factor from database will be used.');
              
       disp('The pixel-to-dose factor used is: ')  
       
       
       dose_factor=def_cf
       
       
       %%  Section converting patient EPID images to dose images.
       
       % choose log file name for patient field.
       
       [his_log_name, his_log_path] = uigetfile('*.LOG','Choose a his log file for patiend epid files'); %select file
       
       dir_log_file_name=[his_log_path his_log_name];
       
       
       % choose dicom template file
       
       [template_name,template_path]=uigetfile('*.dcm','Choose a template dcm file');
       
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
           
           if strcmp(tps,'Xio')
               
               elektaHISToDoseXio5_CF(header,tmp,dose_factor,epid_dir);
               
           end
           
           if strcmp(tps,'Pinnacle')
               
               
               elektaHISToDosePinnacle5_CF(header,tmp,dose_factor,epid_dir);
               
           end
           
           %           progressbar(double(j)/double(length(epid_file_list)));
           
           
           progressbar(double(j)/double(length(log_structure_list)));
           
       end
       
       
       
     
   end % end NO.
   
     
    
  %%  Section converting patient EPID images to dose images.
      
      % choose log file name for patient field.
      
%       [his_log_name, his_log_path] = uigetfile('*.LOG','Choose a his log file for patiend epid files'); %select file
%         
%       dir_log_file_name=[his_log_path his_log_name];
%       
%       
%       % choose dicom template file
%       
%       [template_name,template_path]=uigetfile('*.dcm','Choose a template dcm file');
%       
%       dir_dicm_file_name=[template_path template_name];
%       
%       header=dicominfo(dir_dicm_file_name);
%       
%       log_structure_list=hisLogToStructure(dir_log_file_name);
%        
%            
%      for j=1:length(log_structure_list)
%           
%           progress_message1='Converting EPID to Dose for EPID image file: ';
%           
%           progess_message2=log_structure_list(j).file_name;
%           
%           whole_message=[progress_message1 progess_message2]; 
%           
%           disp(whole_message);
%           
%           %progressbar(progress_bar_lable)
%           
%           progressbar();
%                             
%           tmp=log_structure_list(j);
%           
%           if strcmp(tps,'Xio')
%                
%               elektaHISToDoseXio5_CF(header,tmp,dose_factor,epid_dir);
%                                   
%           end 
%           
%           if strcmp(tps,'Pinnacle')
%               
%              
%               elektaHISToDosePinnacle5_CF(header,tmp,dose_factor,epid_dir);
%               
%           end 
%         
% %           progressbar(double(j)/double(length(epid_file_list)));
%           
%                
%           progressbar(double(j)/double(length(log_structure_list)));
%           
%       end

 

end % end for Eleke parts.



%% after dose conversion copy EPID and dose image to h driver patient directory
 
all_file_list2=getAllFiles(dir_path); % list all file in the directory

% firstly copy all EPID images file from v to h driver

h_driver_patient_dir=[h_driver_patient_dir '\'];

% h_driver_patient_dir=[h_driver_patient_dir]


epid_dir=[h_driver_patient_dir '\EPID'];
tps_dir=[h_driver_patient_dir '\TPS'];
ana_dir=[h_driver_patient_dir '\Analyzed'];


mkdir(epid_dir);

mkdir(tps_dir);

mkdir(ana_dir);

% 
h_final = waitbar(0,'Please wait, copying report and EPID and TPS file from U driver to H driver');

for i=1:length(all_file_list2)
    
    waitbar(i/length(all_file_list2));
    
%     disp('Please wait, the program is doing cleaning up and copying');
%     
    tmp_file_type=fileType(all_file_list2{i});
    
    if strcmp(tmp_file_type,'txt')
        
      copyfile(all_file_list2{i},tps_dir); 
      
        
    end 
     
    if strcmp(tmp_file_type,'LOG')
        
      copyfile(all_file_list2{i},epid_dir); 
        
    end 
    
    if strcmp(tmp_file_type,'HIS')
        
      copyfile(all_file_list2{i},epid_dir);  
        
    end 
    
     if strcmp(tmp_file_type,'dcm')
        
      copyfile(all_file_list2{i},epid_dir);  
%           
     end 
    
     if strcmp(tmp_file_type,'IMA')
        
      copyfile(all_file_list2{i},epid_dir); 
        
     end 
       
    
end   

close(h_final)
% close all files opened.

fclose('all');

fclose('all');

% % open the patient directory folder in H driver for inspection.

winopen(h_driver_patient_dir);

done=strvcat('The conversion from EPID images to dose image was done and saved in',h_driver_patient_dir);

msgbox(done);








