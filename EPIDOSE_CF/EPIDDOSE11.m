% This is the main function for converting EPID image to dose image.

% V and H driver dir. If the directoyr is changed, just change the
% following two variables.



disp(' To use EPIDDOSE, the exported EPID file extension must be:')
disp('capital .IMA for Siemens and captial .HIS for Eleckta');
disp('And put all EPID image file in one folder');
disp('After exporting the file for Elekcta, Do not change the file name again');
disp('After exporting the files for Siements, you can change file name');
disp(',but the extention must be.IMA');



v_driver_dir='V:\';
h_driver_dir='H:\IMRT\PatientQA\2013';

cd(v_driver_dir);

current_dir=pwd;


% choose which TPS first
      
      tps=questdlg('Which TPS system was used for this patient IMRT planning?',...
          'Choose TPS','Xio','Pinnacle','Pinnacle');
      

% then chose directory

dir_path=uigetdir(current_dir,'Choose a Patient directory'); % ask user to select directory

%get the last bit of dir and make a patient specific directory in H driver.

tmp_index=findstr('\',dir_path);

last_index=tmp_index(end);
second_last_index=tmp_index(end-1)

last_dir_part=dir_path(second_last_index+1:last_index-1);

v_driver_patient_dir=dir_path;

original_driver_dir=v_driver_patient_dir

v_patient_name_folder=fileparts(dir_path)

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
    
      
      % decide to get new pixel_to_dose factor or use default one
      
      ref_field=questdlg('Did you take image for 10x10 field at same SID as IMRT field image?','Choose Yes or No','Yes','No','Yes');
      
                       
      % the dose at 5.4 cm depth for Siemens
      
      dose_at_54mm_depth=93.4; % cGy
                      
            
      dose_factor=1;
      if strcmp(ref_field,'Yes')
          
          % chose the reference field image file
          
          ref_field_file_name=uigetfile('*.IMA','Choose  file for 10x10 cm reference field .IMA file');
          
          prompt = {'Enter the MU used for reference field :'};
          dlg_title = 'Input the MU for reference field';
          num_lines = 1;
          def = {'20'};
          ref_mu = inputdlg(prompt,dlg_title,num_lines,def);
      
          ref_mu=str2num(ref_mu{1})
      
          if ref_mu==100
            dose_at_54mm_depth=93.4;% cGy
          else
             dose_at_54mm_depth=93.4/100*ref_mu;
          
          end
          
          
          dose_factor=getSiemensDoseFactor(dose_at_54mm_depth,ref_field_file_name);
      end 
        
      dose_at_54mm_depth
      
      if strcmp(ref_field,'No')
          
          disp('The pixel-to-dose factor measured at 145cm SID for M3');
          disp('and measured at 150cm SID for M5 by Phil with ');
          disp('Inverse square correction will be used');
          
          header=dicominfo(epid_file_list{1});
          
          machine=header.RadiationMachineName;
          SID = double(char(header.RTImageSID)); 
          

          M3_145cm_PixelCalFact=0.000043545; %measured 21/5/2012 P. Vial
          M5_150cm_PixelCalFact=0.00005093; %measured 23/5/2012 P.Vial
 
          PixelCalFact=M5_150cm_PixelCalFact; 
         if strcmp(machine,'M3')
    
%            PixelCalFact=M3_145cm_PixelCalFact;
           PixelCalFact=M3_145cm_PixelCalFact*(SID/10/145)*(SID/10/145)
           
         end 

         if strcmp(machine,'M5')
      
%             PixelCalFact=M5_150cm_PixelCalFact;
            
            PixelCalFact=M5_150cm_PixelCalFact*(SID/10/150)*(SID/10/150);
         end 

         dose_factor=PixelCalFact;
      end 
    
      pixel_to_dose_factor=dose_factor
        
  for i=1:length(epid_file_list)
    
    
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
          
          % choose right function for TPS system
          
          if strcmp(tps,'Xio')
        
              epidSiemensToDoseXio5(epid_file_list{i},dose_factor);
              
          end 
          
          if strcmp(tps,'Pinnacle')
              
               epidSiemensToDosePinacle5(epid_file_list{i},dose_factor);
              
          end 
        
          progressbar(double(i)/double(length(epid_file_list)));
          
          progressbar(double(i)/double(length(epid_file_list)));
        
  end 
end

if strcmp(file_type,'HIS')
    
      % copy template file from H driver to v patient directory. change the
      % following variable if the location is changed.
      
       % decide to get new pixel_to_dose factor or use default one
      
      ref_field=questdlg('Did you take image for 10x10 field at same SID as IMRT field image?','Choose Yes or No','Yes','No','Yes');
       
           
      % choose the directory    
      
      h_driver_template_dir='H:\IMRT\PatientQA\Ekekta dicom template\Eleckta_template.dcm'

      copyfile(h_driver_template_dir,dir_path);
      
     % choose reference field
     
      if strcmp(ref_field,'Yes')
          
          % chose the reference field image file
          
          ref_field_file_name=uigetfile('*.HIS','Choose 10x10 cm reference field his file');
          
       end 
          
      
      % choose log file name
      
      [his_log_name, his_log_path] = uigetfile('*.LOG','Choose a his log file'); %select file
        
      dir_log_file_name=[his_log_path his_log_name];
      
      
      % choose dicom template file
      
      [template_name,template_path]=uigetfile('*.dcm','Choose a template dcm file');
      
      dir_dicm_file_name=[template_path template_name];
      
      header=dicominfo(dir_dicm_file_name);
      
      log_structure_list=hisLogToStructure(dir_log_file_name);
      
      % use log_structure_list to get PSF for reference field only if the
      % user say yes.
      
     if strcmp(ref_field,'Yes')
        ref_PSF=1;
      
        machine_name=' ';
       for j=1:length(log_structure_list)
          
          tmp11=log_structure_list(j);
          
          tmp_fname=tmp11.file_name;
          
          if strcmp(tmp_fname,ref_field_file_name)
              
                       
              ref_PSF=tmp11.pixel_factor;
              
              machine_name=tmp11.station_name
          end 
          
      end 
      
     end 
        
       % the dose at 5.4 cm depth for Siemens
      dose_at_54mm_depth=94.2%cGy
          
        
      
      dose_factor=1;
      % yes part can be put here.
      
      if strcmp(ref_field,'Yes')
          
           prompt = {'Enter the MU used for reference field :'};
           dlg_title = 'Input the MU for reference field';
           num_lines = 1;
           def = {'20'};
           ref_mu = inputdlg(prompt,dlg_title,num_lines,def);
      
           ref_mu=str2num(ref_mu{1})
          
           if ref_mu==100
             dose_at_54mm_depth=94.2;% cGy
           else
             dose_at_54mm_depth=94.2/100*ref_mu;
          
           end     
           
           dose_factor=getElektaDoseFactor3(dose_at_54mm_depth,ref_field_file_name,ref_PSF,machine_name);
          
      end 
      
      dose_at_54mm_depth
              
      % it has to be put here as it requires the station name.
      one_his_structure=log_structure_list(1);
      his_station_name=one_his_structure.station_name;

       if strcmp(ref_field,'No')
          
          disp('The default pixel_to_dose measured by phil for M1 and by Sanka for m2');
          disp('will be used');
          M1_PixelCalFact=0.0001045387; %measured 22/5/2012 P.Vial
          M2_PixelCalFact=0.0001044300; % measured  30/01/2013 P.Vial
%M2_PixelCalFact=9.4069e-005; % measured  24/04/2012 Sanka

          PixelCalFact=M1_PixelCalFact;

          if strcmp(his_station_name,' M1-IVIEW')
    
               PixelCalFact=M1_PixelCalFact;
    
          end

          if strcmp(his_station_name,' M2-IVIEW')
    
               PixelCalFact=M2_PixelCalFact;

          end   

         dose_factor=PixelCalFact;
      end 
    
      pixel_to_dose_factor=dose_factor
        
      for j=1:length(log_structure_list)
          
          progress_message1='Converting EPID to Dose for EPID image file: ';
          
          progess_message2=log_structure_list(j).file_name;
          
          whole_message=[progress_message1 progess_message2]; 
          
          disp(whole_message);
          
          %progressbar(progress_bar_lable)
          
          progressbar();
                            
          tmp=log_structure_list(j);
          
          if strcmp(tps,'Xio')
               
                elektaHISToDoseXio5(header,tmp,dose_factor);
                                  
          end 
          
          if strcmp(tps,'Pinnacle')
              
                elektaHISToDosePinnacle5(header,tmp,dose_factor);
              
          end 
        
          progressbar(double(i)/double(length(epid_file_list)));
          
               
          progressbar(double(j)/double(length(log_structure_list)));
          
      end

end

% % after dose conversion copy EPID and dose image to h driver patient directory
% 
all_file_list2=getAllFiles(v_patient_name_folder); % list all file in the directory

% firstly copy all EPID images file from v to h driver

h_driver_patient_dir=[h_driver_patient_dir '\'];

for i=1:length(all_file_list2)
    
       
    copyfile(all_file_list2{i},h_driver_patient_dir);
    
end   



% % open the patient directory folder in H driver for inspection.
% 
winopen(h_driver_patient_dir);

done=strvcat('The conversion from EPID images to dose image was done and saved in',h_driver_patient_dir);

msgbox(done);

   










