
function Mannual_Callback3_CF(hObject,handles)



% This is the main function for converting EPID image to dose image.

% V and H driver dir. If the directoyr is changed, just change the
% following two variables.

% starting from this version, the program takes  the new file format and corrects collimator angle.
% This is the first workable version for non-zero collimator angle and for
% the new pinnacle TPS format.
% the issue related to different SID were also resolved using epidSimentstodose6.

global gamma_image_file_name
global profile_image_file_name
global beam_name2

% get treatment type

treatment_type=getappdata(0,'treatment_type');

% treatment_type='VMAT'
% load('H:\IMRT\PatientQA\AUTOEPIDRESOURCE\EPID_CALIBRATION.mat');

% The global Gamma criteria

DTA=3; % distance tolerance
tol=3; % dose tolerance

% Physicist
  

physcist_name =handles.selected_physicist;

% physcist_name=getappdata(0,'physicist');

% physcist_name = input('Enter the name of Physicist doing analysis: ', 's');


% The directory on V and H driver.

if ~(exist(handles.patient_list_dir,'dir')==7)
    
    msgbox('Patient directory does not exist, please set patient directory')
    
    return;
    
end 

if ~(exist(handles.output_dir,'dir')==7)
    
    msgbox('output  directory does not exist, set directory for output results')
    
    return;
    
end 



v_driver_dir=handles.patient_list_dir;


h_driver_dir=handles.output_dir;





% v_driver_dir='V:\';
% h_driver_dir='H:\IMRT\PatientQA\2013';

cd(v_driver_dir);

current_dir=pwd;


% choose which TPS first
      
 tps=handles.which_tps;
      


dir_path=handles.patient_name;

% get factor

common_cf=getappdata(0,'default_cf')

epid_dir=getappdata(0,'epid_dir');

%get the last bit of dir and make a patient specific directory in H driver.

tmp_index=findstr('\',dir_path);

last_index=tmp_index(end);
% second_last_index=tmp_index(end-1);

last_dir_part=dir_path(last_index+1:end);


% make the patient folder in H driver.

v_driver_patient_dir=dir_path;

original_driver_dir=v_driver_patient_dir

[path,name,ext]=fileparts(v_driver_patient_dir)

% v_patient_name_folder=original_driver_dir

% v_patient_name_folder=fileparts(dir_path)

h_driver_patient_dir=[h_driver_dir '\' name];

% destination_patient_dir=h_driver_patient_dir

destination_patient_dir=h_driver_patient_dir

mkdir(h_driver_patient_dir);

cd(dir_path);


% all_file_list=getFileList(dir_path); % list all file in the directory


% list epid files and log files into cell list

% epid_file_list=listEPIDFile(all_file_list);

% %%%%%%%%%%%%%%get matched epid file name

epid_file_list=handles.matched_epid_file_list;

%%%%%%% get matched tps file name

tps_file_list=handles.matched_tps_file_list;

% get file type to see if they are Elekta file or Siemens files

% get machine type

file_type=handles.which_machine

% get machine type

progress_bar_lable='EPID to Dose image conversion';


if strcmp(file_type,'M3')
    
                   
          
          disp('The pixel-to-dose factor measured at 145cm SID for M3');
          disp('and measured at 150cm SID for M5 by Phil with ');
          disp('Inverse square correction will be used');
          
          header=dicominfo(epid_file_list{1});
          
          machine=header.RadiationMachineName;
          SID = double(char(header.RTImageSID)); 
          
           
          M3_145cm_PixelCalFact=common_cf;
          
        
         
           PixelCalFact=M3_145cm_PixelCalFact*(SID/1460.0)*(SID/1460.0);
           
      
           dose_factor=PixelCalFact;
    
    
           pixel_to_dose_factor=dose_factor
  
  % get patient information and machine information for report generation.    
   [family_name,mrn,beam_name2,epid_gantry_angle,machine]=getPatientInformationFromDicom(epid_file_list{1}); 
      
  % report head start
if strcmp( handles.output_option, 'EPID Dose Image+AutoReport')      
     report_file_name=[ 'AutoEPID_' family_name '_' mrn '_' machine '.doc'];
         
     % Create a new report in current directory, discarding any existing content
     reportFilename = report_file_name;
     if exist(reportFilename, 'file')
        delete(reportFilename);
     end
     reportFilename = fullfile(pwd,reportFilename);
     wr = wordreport5(reportFilename);
     headingString = 'Patient Specific IMRT  QA  report ';
try
    % Set style to 'Heading 1' for top level titles
    wr.setstyle([headingString '1']);
    % Define title
    textString = 'Patient Specific IMRT QA report';
    % Insert title in the document
    wr.addtext(textString, [0 15]); % two line breaks after text
catch
    % Error when trying to insert first heading. The generic name for
    % heading styles must be wrong, problably due to Microsoft Office
    % language. Resetting to default: ENGLISH (see above for more details)
    warning('Resetting generic name for heading styles to default ''Heading '''); %#ok<WNTAG>
    headingString = 'Heading ';
    wr.setstyle([headingString '1']);
    textString = 'Patient IMRT QA report';
    wr.addtext(textString, [0 15]); % two line breaks after text
    
    patient_name_st=['Patient Name: '  family_name];
    mrn_st=['MRN:  '  mrn];
    machine_st=['Machine: '  machine];
    
    wr.setstyle('Heading 2');
    wr.addtext(patient_name_st);
    wr.addtext(mrn_st);
    wr.addtext(machine_st);
    
    perform_str=['Performed by:   '  '   '  physcist_name];
    approval_str=['Approved by:   '  '    '  physcist_name];
    
    wr.addtext(perform_str,[4,1])
    wr.addtext(approval_str);
    date_string=['Date:     ' date];
    wr.addtext(date_string);
    
end
     
     wr.setstyle('Heading 1');
     wr.addpagebreak()
     wr.addtext('Table of Content', [1 2]); % line break before and after text
     wr.createtoc(1, 3);
%      wr.addpagebreak();   
     
     % 
%      wr.addtext(' ',[10,3]);
%      wr.setstyle('Heading 1');
%      wr.addtext('Gamma and profile analysis', [1 1]); % line break before and after text
     % ---

% report head end        
      
end    
         
  for i=1:length(epid_file_list)
        if strcmp( handles.output_option, 'EPID Dose Image+AutoReport')  
         wr.addpagebreak() % add page break for each beam.
         wr.setstyle('Heading 1');
         wr.addtext('Gamma and profile analysis', [0 1]); % line break before and after text
        end 
         
    
         % turn off the warning message for Siemens EPID conversion.
         warning off 
        
        % direclty call Siments EPID2dose function
          progressbar();
          progress_message1='Converting EPID Images to Dose Images';
          
          [dir_path_tmp,filename_tmp,ext_tmp]=fileparts(epid_file_list{i});
          
          ima_file_name=[filename_tmp ext_tmp];
          
          progess_message2=ima_file_name;
          
          whole_message=strvcat(progress_message1,progess_message2); 
          
%           disp(whole_message);
          
            whole_message_cell{i}=whole_message;
          
%           disp(whole_message);
          
           hfig=findobj('Tag','progess');
           set(hfig,'String',whole_message_cell);
          
                   
          
          
          
          % get the EPID dicom file.
          
          tps_file_dir=dir_path;
          
          epid_dicom_file=epid_file_list{i};
          
          [family_name,mrn,beam_name2,epid_gantry_angle,machine]=getPatientInformationFromDicom(epid_dicom_file);
          
                           
          tps_file=tps_file_list{i}
          
          [gang_angle,coll_angle]=findGangtryandCollimatorAngleFromPinTPSFile(tps_file);
          
          
          % choose right function for TPS system
          
          if strcmp(tps,'Xio')
             if strcmp( handles.output_option, 'EPID Dose Image+AutoReport') 
              [gamma_image_file_name,profile_image_file_name,beam_name2]=profileGammaAnalysisSiemensPin(tps_file,epid_dicom_file,DTA,tol, dose_factor,coll_angle);
             end
              epidSiemensToDoseXio9(epid_file_list{i},dose_factor);
             
          end 
          
          if strcmp(tps,'Pinnacle')
              if strcmp( handles.output_option, 'EPID Dose Image+AutoReport')
                  
                if strcmp(treatment_type,'IMRT')  
                    
                 [gamma_image_file_name,profile_image_file_name,beam_name2]=profileGammaAnalysisSiemensPin(tps_file,epid_dicom_file,DTA,tol, dose_factor,coll_angle);
                 
                  epidSiemensToDosePinacle9(epid_file_list{i},dose_factor);
                 
                end 
               
                if strcmp(treatment_type,'VMAT')
                    
                    [gamma_image_file_name,profile_image_file_name,beam_name2]=profileGammaAnalysisSiemensPin2_Vmat(tps_file,epid_dicom_file,DTA,tol, dose_factor);
                    
                    epidSiemensToDosePinacle(epid_file_list{i},dose_factor);
                    
                end 
              end
              
               if strcmp( handles.output_option, 'EPID Dose Image Only')
                   
                   epidSiemensToDosePinacle(epid_file_list{i},dose_factor);
                
               end 
              
			 
          end 
        
        
      % report body start 
      if strcmp( handles.output_option, 'EPID Dose Image+AutoReport')
        wr.setstyle('Heading 2');
           
           beam_name=['Beam: '  beam_name2];
           
           wr.addtext(beam_name, [0 1]); % line break after text
% comment out for IMRT manual matching.
%            gamma_2mm1=['2%/2m Gamma pass rate: ' num2str(npass2*100)  '%'];
%            
%            gamma_2mm2=['Mean Gamma for 2%/2mm: '  num2str(gmean2)];
%            
%                      
%            gamma_3mm1=['3%/3m Gamma pass rate: ' num2str(npass*100)  '%'];
%            
%            gamma_3mm2=['Mean Gamma for 3%/3mm: '  num2str(gmean)];
%            
           
           % 6-red, 4-green, 7-yellow
%            if npass*100>=95
%                
%             wr.addtext(gamma_3mm1,[0 1],4);
%             
%            end
%            
%            if npass*100<95
%                
%             wr.addtext(gamma_3mm1,[0 1],6);
%             
%            end
%            
%            if npass2*100>=90
%              wr.addtext(gamma_2mm1,[0 1],4);
%              
%            end 
%            
%             if npass2*100<90
%              wr.addtext(gamma_2mm1,[0 1],6);
%              
%            end 
%            
%                       
%            wr.addtext(gamma_3mm2,[0 1]);
%            wr.addtext(gamma_2mm2,[0 1]);
           
        
           cur_dir=pwd;
           
           fnam1=[cur_dir '\' gamma_image_file_name];
           
           fnam2=[cur_dir '\' profile_image_file_name];
           
               
           wr.addfigure(fnam2,fnam1);
      
%            wr.addpagebreak()
           
      % report body ends
      end
            
%         progressbar(double(i)/double(length(epid_file_list)/2));
          
          progressbar(double(i)/double(length(epid_file_list)));
        
  end 

% report tail start
if strcmp( handles.output_option, 'EPID Dose Image+AutoReport') 
    
  wr.addpagenumbers('wdAlignPageNumberRight');
     
     
  wr.updatetoc();
     
  wr.close();
end  

% report tail end

end % end for Simens machine.

%--------------------------------------------------------------------------
%---------------


if strcmp(file_type,'M1')||strcmp(file_type,'M2')||strcmp(file_type,'M5')||strcmp(file_type,'M4')
    
      % copy template file from H driver to v patient directory. change the
      % following variable if the location is changed.
      
       % decide to get new pixel_to_dose factor or use default one
      
%       ref_field=questdlg('Did you take an image for a 10x10 field at same SID as IMRT field images?','Choose Yes or No','Yes','No','Yes');
    
      % choose the directory    
      
      h_driver_template_dir='H:\IMRT\PatientQA\Ekekta dicom template\Eleckta_template.dcm';

      copyfile(h_driver_template_dir,dir_path);
     
      
      
      % choose log file name
      
      [his_log_name, his_log_path] = uigetfile('*.LOG','Choose a .his log file'); %select file
        
      dir_log_file_name=[his_log_path his_log_name];
      
      
      % choose dicom template file
      
      [template_name,template_path]=uigetfile('*.dcm','Choose a template .dcm file');
      
      dir_dicm_file_name=[template_path template_name];
      
      header=dicominfo(dir_dicm_file_name);
      
      log_structure_list=hisLogToStructure(dir_log_file_name);
      
      % use log_structure_list to get PSF for reference field only if the
      % user say yes.
      
                    
      % it has to be put here as it requires the station name.
      one_his_structure=log_structure_list(1);
      his_station_name=one_his_structure.station_name;

      dose_factor=common_cf;  
     
      	
      pixel_to_dose_factor=dose_factor
      
      
   % use his log structure to get  patient informaton and machien
   % information
   
   
   family_name=one_his_structure.patient_name;
   
   beam_name3=one_his_structure.field_name;
   
   epid_gantry_angle=beam_name3;
   
   machine=one_his_structure.station_name;
   
   mrn=one_his_structure.treatment_name;
  
   
   
 if strcmp( handles.output_option, 'EPID Dose Image+AutoReport')   
  % report head start
         
     report_file_name=[ 'AutoEPID_' family_name '_' mrn '_' machine '.doc'];
     
      % add mat file name to hold all patient-related data
     
     handles.patient_mat_file=[ 'AutoEPID_' family_name '_' mrn '_' machine '.mat'];
     guidata(hObject,handles);
     
     
         
     % Create a new report in current directory, discarding any existing content
     reportFilename = report_file_name;
     if exist(reportFilename, 'file')
        delete(reportFilename);
     end
     reportFilename = fullfile(pwd,reportFilename);
     wr = wordreport5(reportFilename);
     headingString = 'Patient Specific IMRT  QA  report ';
try
    % Set style to 'Heading 1' for top level titles
    wr.setstyle([headingString '1']);
    % Define title
    textString = 'Patient Specific IMRT QA report';
    % Insert title in the document
    wr.addtext(textString, [0 15]); % two line breaks after text
catch
    % Error when trying to insert first heading. The generic name for
    % heading styles must be wrong, problably due to Microsoft Office
    % language. Resetting to default: ENGLISH (see above for more details)
    warning('Resetting generic name for heading styles to default ''Heading '''); %#ok<WNTAG>
    headingString = 'Heading ';
    wr.setstyle([headingString '1']);
    textString = 'Patient IMRT QA report';
    wr.addtext(textString, [0 15]); % two line breaks after text
    
    patient_name_st=['Patient Name: '  family_name];
    mrn_st=['MRN:  '  mrn];
    machine_st=['Machine: '  machine];
    
    wr.setstyle('Heading 2');
    wr.addtext(patient_name_st);
    wr.addtext(mrn_st);
    wr.addtext(machine_st);
    
    perform_str=['Performed by:   '  '   '  physcist_name];
    approval_str=['Approved by:   '  '    '  physcist_name];
    
    wr.addtext(perform_str,[4,1])
    wr.addtext(approval_str);
    
    date_string=['Date:   ' date];
    wr.addtext(date_string);
    
end
     
     wr.setstyle('Heading 1');
     wr.addpagebreak()
     wr.addtext('Table of Content', [1 2]); % line break before and after text
     wr.createtoc(1, 3);
%      wr.addpagebreak();   
     
     % 
%      wr.addtext(' ',[10,3]);
%      wr.setstyle('Heading 1');
%      wr.addtext('Gamma and profile analysis', [1 1]); % line break before and after text
%      % ---

 % report head end        
end         
      
            
        
 for j=1:length(tps_file_list)
       
        
        tps_file=tps_file_list{j};
        
  
   if strcmp( handles.output_option, 'EPID Dose Image+AutoReport')
          wr.addpagebreak()% add page break for each image.
          
%           wr.addtext(' ',[10,3]);
          wr.setstyle('Heading 1');
          wr.addtext('Gamma and profile analysis', [0 1]); % line break before and after text
   end  
%           progress_message1='Converting EPID Images to Dose Images: ';
%           
%           progess_message2=log_structure_list(j).file_name;
%           
%           whole_message=[progress_message1 progess_message2]; 
%           
%           disp(whole_message);
%           
          progress_message1='Converting EPID Images to Dose Images: ';
          
          progess_message2=epid_file_list(j)
          
          whole_message=[progress_message1 progess_message2]; 
          
          whole_message_cell{j}=whole_message;
          
%           disp(whole_message);

          hprogress=findobj('Tag','progress');
          
          set(hprogress,'String',whole_message);
          
                      
          
          %progressbar(progress_bar_lable)
          
          progressbar();
                            

          
          tps_file=tps_file_list{j};
        
          
%           gang_angle=strcat('Arc',num2str(j));
          
          
          if strcmp(treatment_type,'IMRT')
              
            [gang_angle,coll_angle]=findGangtryandCollimatorAngleFromPinTPSFile(tps_file);
            
          end
          
           if strcmp(treatment_type,'VMAT')
              
            gang_angle=strcat('Arc',num2str(j));
            
          end
          
              
       
         
          % from EPID file list to get PSF
          
          epid_his_file=epid_file_list{j}
          
          [path,name,ext]=fileparts(epid_his_file);
          
          given_epid_file_name=strcat(name,ext);
          
          PSF= getPSFFromLog(dir_log_file_name,given_epid_file_name );
          
          tmp=hisLogToStructure(dir_log_file_name);
            
          pixel_dose_factor=dose_factor
          
          if strcmp(tps,'Xio')
              if strcmp( handles.output_option, 'EPID Dose Image+AutoReport')
                [gamma_image_file_name,profile_image_file_name]=profileGammaAnalysisElektaPin2(tps_file,epid_his_file,DTA,tol,PSF,pixel_dose_factor,coll_angle);              
              end 
                elektaHISToDoseXio5(header,tmp,dose_factor);
                            
          end 
          
          if strcmp(tps,'Pinnacle')
              
              if strcmp( handles.output_option, 'EPID Dose Image+AutoReport')
                  
                if strcmp(treatment_type,'IMRT')  
                  
                   %[gamma_image_file_name,profile_image_file_name]=profileGammaAnalysisElektaPin2(tps_file,epid_his_file,DTA,tol,PSF,pixel_dose_factor,coll_angle);  
                   
                   [gamma_image_file_name,profile_image_file_name,numpass3,avg3,numpass2,avg2,beam_name2]=profileGammaAnalysisElektaPin2(tps_file,epid_his_file,DTA,tol,PSF,pixel_dose_factor,coll_angle);
                                    
                    elektaHISToDosePinnacle5_CFM(header,tmp,dose_factor,epid_his_file);
                    
                    
                   
                   
                    % calculate the GLCM features and save into file.
              
                    [tps_glcm,tps_dose]=getGLCMFromTPS(tps_file);
                    
                    [epid_glcm,epid_dose]=getGLCMFromEPID(epid_his_file);
                    
                    handles.patient_database(j).tps_dose=tps_dose;
                    
                    handles.patient_database(j).epid_dose=epid_dose;
                    
                    handles.patient_database(j).epid_glcm=epid_glcm;
                    
                    handles.patient_database(j).tps_glcm=tps_glcm;
                    
                    handles.patient_database(j).gamma_3mm3p_mean=avg3;
                    
                    handles.patient_database(j).gamma_3mm3p_pass=numpass3;
                    
                    handles.patient_database(j).gamma_2mm2p_mean=avg2;
                    
                    handles.patient_database(j).gamma_2mm2p_pass=numpass2;
                    
                    guidata(hObject,handles);
                    
                    % save to matfile
                    
                    patient_matfile_dir=getappdata(0,'patient_matfile_dir');
                       
                   
                    patient_database=handles.patient_database;                        
                    
                    patient_mat_file=fullfile(patient_matfile_dir,handles.patient_mat_file)
                    
                    save(patient_mat_file,'patient_database');
                    
                   
                end 
                
                if strcmp(treatment_type,'VMAT')  
                    
                     [gamma_image_file_name,profile_image_file_name,numpass3,avg3,numpass2,avg2]=profileGammaAnalysisElektaPin2_Vmat(tps_file,epid_his_file,DTA,tol,PSF,pixel_dose_factor);                
                     
                     %[gamma_image_file_name,profile_image_file_name]=profileGammaAnalysisElektaPin2_Vmat(tps_file,epid_his_file,DTA,tol,PSF,pixel_dose_factor);  
                   
                      gmean=numpass3;
                      
                      elektaHISToDosePinnacle5_CFM(header,tmp,dose_factor,epid_his_file);
                      
                       % calculate the GLCM features and save into file.
              
                       [tps_glcm,tps_dose]=getGLCMFromTPS(tps_file);
                       
                       [epid_glcm,epid_dose]=getGLCMFromEPID(epid_his_file);
                       
                       handles.patient_database(j).tps_dose=tps_dose;
                       
                       handles.patient_database(j).epid_dose=epid_dose;
                       
                       handles.patient_database(j).epid_glcm=epid_glcm;
                       
                       handles.patient_database(j).tps_glcm=tps_glcm;
                       
                       handles.patient_database(j).gamma_3mm3p_mean=avg3;
                       
                       handles.patient_database(j).gamma_3mm3p_pass=numpass3;
                       
                       handles.patient_database(j).gamma_2mm2p_mean=avg2;
                       
                       handles.patient_database(j).gamma_2mm2p_pass=numpass2;
                       
                       guidata(hObject,handles);
                       
                       % save to matfile
                       
                       patient_matfile_dir=getappdata(0,'patient_mat_file_dir');
                       
                       patient_database=handles.patient_database;      
                       
                       patient_mat_file=fullfile(patient_matfile_dir,handles.patient_mat_file)
                       
                       save(patient_mat_file,'patient_database');
                       
                       
                      
                end 
                
              end	
              
               if strcmp( handles.output_option, 'EPID Dose Image Only')
                   
                  elektaHISToDosePinnacle5_CFM(header,tmp,dose_factor,epid_his_file);
                
               end 
              
          end 
        
	if strcmp( handles.output_option, 'EPID Dose Image+AutoReport')
        % report body start 
        
      
           wr.setstyle('Heading 2');
           
           beam_name=['Beam: '   num2str(gang_angle)];
           
           wr.addtext(beam_name, [0 1]); % line break after text

           gamma_2mm1=['2%/2m Gamma pass rate: ' num2str(numpass2*100)  '%'];
           
           gamma_2mm2=['Mean Gamma for 2%/2mm: '  num2str(avg2)];
           
                     
           gamma_3mm1=['3%/3m Gamma pass rate: ' num2str(numpass3*100)  '%'];
           
           gamma_3mm2=['Mean Gamma for 3%/3mm: '  num2str(avg3)];
           
           % 6-red, 4-green, 7-yellow
           if numpass3*100>=95
               
            wr.addtext(gamma_3mm1,[0 1],4);
            
           end
           
           if numpass3*100<95
               
            wr.addtext(gamma_3mm1,[0 1],6);
            
           end
           
           if numpass2*100>=90
             wr.addtext(gamma_2mm1,[0 1],4);
             
           end 
           
            if numpass2*100<90
             wr.addtext(gamma_2mm1,[0 1],6);
             
            end 
           
           wr.addtext(gamma_3mm2,[0 1]);
           wr.addtext(gamma_2mm2,[0 1]); 
           
            % Add the Gamma map to structure
           
           
          handles.gamma_sumary(j).mrn=mrn;
          
          handles.gamma_sumary(j).treatment_type=handles.treatment_type;
          
          handles.gamma_sumary(j).beam_name= epid_gantry_angle;
          
          
          handles.gamma_sumary(j).gamma_pass_3mm_3Per=numpass3*100;
          
          handles.gamma_sumary(j).gamma_pass_2mm_2Per=numpass2*100;
          
          handles.gamma_sumary(j).gamma_mean_3mm_3Per=avg3;
          
          handles.gamma_sumary(j).gamma_mean_2mm_2Per=avg2;
           
                      
            
           
           cur_dir=pwd;
         
           fnam1=[cur_dir '\' gamma_image_file_name];
           
           fnam2=[cur_dir '\' profile_image_file_name];
           
               
           wr.addfigure(fnam2,fnam1);
      
   end     
      % report body ends
         
                   
          progressbar(double(j)/double(length(epid_file_list)));
          
%           progressbar(double(j)/double(length(log_structure_list)));
          

 end 
 
if strcmp( handles.output_option, 'EPID Dose Image+AutoReport') 
% report tail start
  wr.addpagenumbers('wdAlignPageNumberRight');
     
     
  wr.updatetoc();
     
  wr.close();
  
end
% report tail end
  
end % end of elekta machine.

% % after dose conversion copy EPID and dose image to h drive patient directory
% 
v_patient_name_folder=original_driver_dir;

all_file_list2=getAllFiles(v_patient_name_folder); % list all file in the directory

% firstly copy all EPID images file from v to h drive

h_driver_patient_dir=[h_driver_patient_dir '\'];

epid_dir=[h_driver_patient_dir '\EPID'];
tps_dir=[h_driver_patient_dir '\TPS'];
ana_dir=[h_driver_patient_dir '\Analyzed'];

auto_report_dir=[h_driver_patient_dir  '\AutoReport'];

mkdir(epid_dir);

mkdir(tps_dir);

mkdir(ana_dir);

mkdir(auto_report_dir);

h_final = waitbar(0,'Please wait, copying report and EPID and TPS files from V drive to H drive');

for i=1:length(all_file_list2)
    
    waitbar(i/length(all_file_list2));
    
%     disp('Please wait, the program is cleaning up and copying files');
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
    
     if strcmp(tmp_file_type,'jpg')
        
%        copyfile(all_file_list2{i},auto_report_dir);  

        
     end 
     
     if strcmp(tmp_file_type,'doc')
        
      copyfile(all_file_list2{i},auto_report_dir);
      
      %[pathstr, name, ext, versn] = fileparts(all_file_list2{i}); before
      %matlab 2013 version
      
      [pathstr, name, ext] = fileparts(all_file_list2{i}); 
      %report_file_name=fullfile(auto_report_dir,[name ext versn]);
      report_file_name=fullfile(auto_report_dir,[name ext]);
        
     end 
     
%     copyfile(all_file_list2{i},h_driver_patient_dir);
%     
   
    
end   

close(h_final)
% close all files opened.

fclose('all');

% delete all temporary files

all_things_under_dir=dir(dir_path);

for j=1:length(all_things_under_dir)
    
    
    tmp=all_things_under_dir(j);
    
    if ~tmp.isdir
        
        delete(tmp.name)
    end 
    
    
    
end 



fclose('all');

hManualFig=findobj('Tag','manual_figure');

delete(hManualFig);


% % open the patient directory folder in H driver for inspection.

winopen(h_driver_patient_dir);

% done=strvcat('The conversion from EPID images to dose images was completed and saved in ',H_drive_patient_dir);
% 
% msgbox(done);

% open Report for inspection.

%open(report_file_name);
   
% saved into database

database_path='N:\PROJECTS\IMRT implementation\EPID Dosimetry Commissioning\AutoEPIDDatabase\';

patient_file=[database_path  mrn];
 

% do it only if the field exist as for M3 there is no gamma_smmary.

if isfield(handles,'gamma_summary')
struc2xls(patient_file,handles.gamma_sumary);

end 


% convert to pdf and copy to escan

% rename the doc file 

% rename the doc file 

[pathstr, name, ext] = fileparts(report_file_name); 
test_file_name=fullfile(pathstr,'test.doc');



copyfile(report_file_name,test_file_name);

pdf_exe=['OfficeToPDF  ', test_file_name];

system(pdf_exe)

% move pdf file to escan.

[pathstr, name, ext] = fileparts(report_file_name); 

pdf_file_name=[name,'.pdf'];

escan_pdf=fullfile('S:\escan\Med Phys',pdf_file_name);

% get test pdf file name

[pathstr,name,exe]=fileparts(test_file_name);

test_pdf_file=fullfile(pathstr,'test.pdf');

movefile(test_pdf_file,escan_pdf);
% delete tmp file.
delete(test_file_name); 

 
 








