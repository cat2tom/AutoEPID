
function handles=Mannual_Callback3_CF_PDF(hObject,handles)



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

% h_driver_dir=handles.output_dir;

h_driver_dir=getappdata(0,'output_dir')

class(h_driver_dir)


% Physicist
  

physcist_name =handles.selected_physicist;

% physcist_name=getappdata(0,'physicist');

% physcist_name = input('Enter the name of Physicist doing analysis: ', 's');


% The directory on V and H driver.

if ~(exist(handles.patient_list_dir,'dir')==7)
    
    msgbox('Patient directory does not exist, please set patient directory')
    
    return;
    
end 

if ~(exist(h_driver_dir,'dir')==7)
    
    msgbox('output  directory does not exist, set directory for output results')
    
    return;
    
end 



v_driver_dir=handles.patient_list_dir;


% h_driver_dir=handles.output_dir;

% h_driver_dir=getappdata(0,'output_dir');



% h_driver_dir=handles.vmat_output_dir;



% v_driver_dir='V:\';
% h_driver_dir='H:\IMRT\PatientQA\2013';

cd(v_driver_dir);

current_dir=pwd;


% choose which TPS first
      
 tps=handles.which_tps;
 
 tps='Pinnacle'; % present tps to be Pinnacle.
      


dir_path=handles.patient_name;

% get factor

% common_cf=getappdata(0,'default_cf');

% get factor direclty from main windows

main_figure_cf_handle=findobj('Tag','default_cf');

common_cf2=get(main_figure_cf_handle,'String');

common_cf=str2double(common_cf2)


epid_dir=getappdata(0,'epid_dir');

%get the last bit of dir and make a patient specific directory in H driver.

tmp_index=findstr('\',dir_path);

last_index=tmp_index(end);
% second_last_index=tmp_index(end-1);

last_dir_part=dir_path(last_index+1:end);


% make the patient folder in H driver.

v_driver_patient_dir=dir_path;

original_driver_dir=v_driver_patient_dir;

[path,name,ext]=fileparts(v_driver_patient_dir);

% v_patient_name_folder=original_driver_dir

% v_patient_name_folder=fileparts(dir_path)

h_driver_patient_dir=fullfile(h_driver_dir,name);

% h_driver_patient_dir=[h_driver_dir '\' name];

% destination_patient_dir=h_driver_patient_dir

destination_patient_dir=h_driver_patient_dir;

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

file_type=handles.which_machine;

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
    
    
           pixel_to_dose_factor=dose_factor;
  
  % get patient information and machine information for report generation.    
   [family_name,mrn,beam_name2,epid_gantry_angle,machine]=getPatientInformationFromDicom(epid_file_list{1}); 
      
  % report head start
if strcmp( handles.output_option, 'EPID Dose Image+AutoReport')      
     
      % pdf report file name
         
     report_file_name=strcat( 'AutoEPID_',family_name, '_',mrn,'_', machine, '.pdf');
     
     auto_report_dir_file=fullfile(h_driver_patient_dir,'AutoReport',report_file_name);
         
     handles.pdf_report_file_name=auto_report_dir_file;
     
     guidata(hObject,handles);
     
         
      
end    
         
  for k=1:length(epid_file_list)
               
    
         % turn off the warning message for Siemens EPID conversion.
         warning off 
        
        % direclty call Siments EPID2dose function
          progressbar();
          progress_message1='Converting EPID Images to Dose Images';
          
          [dir_path_tmp,filename_tmp,ext_tmp]=fileparts(epid_file_list{k});
          
          ima_file_name=[filename_tmp ext_tmp];
          
          progess_message2=ima_file_name;
          
          whole_message=strvcat(progress_message1,progess_message2); 
          
%           disp(whole_message);
          
            whole_message_cell{k}=whole_message;
          
%           disp(whole_message);
          
           hfig=findobj('Tag','progess');
           set(hfig,'String',whole_message_cell);
          
     
          
          % get the EPID dicom file.
          
          tps_file_dir=dir_path;
          
          epid_dicom_file=epid_file_list{k};
          
          [family_name,mrn,beam_name2,epid_gantry_angle,machine]=getPatientInformationFromDicom(epid_dicom_file);
          
                
          % prepare patient infor for pdf generation 
   
          handles.patient_name=family_name;
          
          handles.machine=machine;
          
          handles.mrn=mrn;
          
          guidata(hObject,handles);
          
          
          tps_file=tps_file_list{k};
          
          [gang_angle,coll_angle]=findGangtryandCollimatorAngleFromPinTPSFile(tps_file);
          
          
          % choose right function for TPS system
          
          if strcmp(tps,'Xio')
             if strcmp( handles.output_option, 'EPID Dose Image+AutoReport') 
              [gamma_image_file_name,profile_image_file_name,beam_name2]=profileGammaAnalysisSiemensPin(tps_file,epid_dicom_file,DTA,tol, dose_factor,coll_angle);
             end
              epidSiemensToDoseXio9(epid_file_list{k},dose_factor);
             
          end 
          
          if strcmp(tps,'Pinnacle')
              
              if strcmp( handles.output_option, 'EPID Dose Image+AutoReport')
                  
                if strcmp(treatment_type,'IMRT')  
                  
%                  [gamma_image_file_name,profile_image_file_name,npass,gmean,npass2,gmean2,beam_name2]=profileGammaAnalysisSiemensPin2(tps_file,epid_dicom_file,DTA,tol, dose_factor,coll_angle);
               
                 [gamma_image_file_name,profile_image_file_name,npass,gmean,npass2,gmean2,beam_name2]=profileGammaAnalysisSiemensPin2(tps_file,epid_dicom_file,DTA,tol, dose_factor,coll_angle);
                 
                  epidSiemensToDosePinacle9(epid_file_list{k},dose_factor);
                 
                end 
               
                if strcmp(treatment_type,'VMAT')
                    
                    [gamma_image_file_name,profile_image_file_name,beam_name2]=profileGammaAnalysisSiemensPin2_Vmat(tps_file,epid_dicom_file,DTA,tol, dose_factor);
                    
                    epidSiemensToDosePinacle(epid_file_list{k},dose_factor);
                    
                end 
              end
              
               if strcmp( handles.output_option, 'EPID Dose Image Only')
                   
                   epidSiemensToDosePinacle(epid_file_list{k},dose_factor);
                
               end 
              
			 
          end 
        
        
      % report body start 
      if strcmp( handles.output_option, 'EPID Dose Image+AutoReport')
       
                  
          % prepare patient infor for pdf generate
          beam_name=strcat('Beam: ',beam_name2);
          handles.gammaSummaryS(k).beam_name= beam_name;
          handles.gammaSummaryS(k).m3p3_gamma=npass*100;  
          handles.gammaSummaryS(k).m2p2_gamma=npass2*100;  
          handles.gammaSummaryS(k).mean_gamma_m3p3=gmean;  
          handles.gammaSummaryS(k).mean_gamma_m2p2=gmean2;  
           
          %get full file name
           cur_dir=pwd;
           fnam1=fullfile(cur_dir, gamma_image_file_name);
           fnam2=fullfile(cur_dir, profile_image_file_name);
           
                   
           % copy the file to local user tempfolder.
           
           copyfile(fnam1,tempdir);
           
           copyfile(fnam2,tempdir);
           
           profile_image_file=fullfile(tempdir, profile_image_file_name);
           gamma_image_file=fullfile(tempdir, gamma_image_file_name);
           
           
             % prepare gammaProfileS
           
           
           handles.gammaProfileS(k).beam_name=beam_name;
           handles.gammaProfileS(k).profile_image_file_name=profile_image_file;
           handles.gammaProfileS(k).gamma_image_file_name=gamma_image_file;
           
           guidata(hObject,handles);
      
      % report body ends
      
      end
            
        
  end 


end % end for Simens machine.

%--------------------------------------------------------------------------
%---------------


if strcmp(file_type,'M1')||strcmp(file_type,'M2')||strcmp(file_type,'M5')||strcmp(file_type,'M4')...
    ||strcmp(file_type,'M7')    
    
      % copy template file from H driver to v patient directory. change the
      % following variable if the location is changed.
      
       % decide to get new pixel_to_dose factor or use default one
      
%       ref_field=questdlg('Did you take an image for a 10x10 field at same SID as IMRT field images?','Choose Yes or No','Yes','No','Yes');
    
      % choose the directory    
      
      h_driver_template_dir='V:\CTC-LiverpoolOncology-Physics\IMRT\PatientQA\Ekekta dicom template\Eleckta_template.dcm';

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
          	
      pixel_to_dose_factor=dose_factor;
      
      
   % use his log structure to get  patient informaton and machien
   % information
   
   
   family_name=one_his_structure.patient_name;
   
   beam_name3=one_his_structure.field_name;
   
   epid_gantry_angle=beam_name3;
   
   machine=one_his_structure.station_name;
   
   mrn=one_his_structure.treatment_name;
  
   % prepare patient infor for pdf generation 
   
   handles.patient_name=family_name;
   
   handles.machine=machine;
   
   handles.mrn=mrn;
   
   guidata(hObject,handles);
   
% prepare the pdf report file name

 if strcmp(handles.output_option, 'EPID Dose Image+AutoReport')   
  % report head start
  
      % pdf report file name
         
%      report_file_name=strcat( 'AutoEPID_',family_name, '_',mrn,'_', machine, '.pdf');
     
     report_file_name=strcat( 'AutoEPID_',mrn,'_', machine, '.pdf');
     
     
     auto_report_dir_file=fullfile(h_driver_patient_dir,'AutoReport',report_file_name);
     
       
     handles.pdf_report_file_name=auto_report_dir_file;
     
     guidata(hObject,handles);
     

     % add mat file name to hold all patient-related data
     
     handles.patient_mat_file=strcat('AutoEPID_', family_name, '_', mrn ,'_' ,machine, '.mat');
     
     guidata(hObject,handles);
 
end         
      
  
 for k=1:length(tps_file_list)
       
        
         tps_file=tps_file_list{k};
        
  
   %           
          progress_message1='Converting EPID Images to Dose Images: ';
          
          progess_message2=epid_file_list(k);
          
          whole_message=[progress_message1 progess_message2]; 
          
          whole_message_cell{k}=whole_message;
          
%           disp(whole_message);

          hprogress=findobj('Tag','progress');
          
          set(hprogress,'String',whole_message);
          
                      
          
          %progressbar(progress_bar_lable)
          
          progressbar();
                            

          
          tps_file=tps_file_list{k};
        
          
%           gang_angle=strcat('Arc',num2str(j));
          
          
          if strcmp(treatment_type,'IMRT')
              
            [gang_angle,coll_angle]=findGangtryandCollimatorAngleFromPinTPSFile(tps_file);
            
          end
          
           if strcmp(treatment_type,'VMAT')
              
            gang_angle=strcat('Arc',num2str(k));
            
          end
          
              
          % from EPID file list to get PSF
          
          epid_his_file=epid_file_list{k};
          
          [path,name,ext]=fileparts(epid_his_file);
          
          given_epid_file_name=strcat(name,ext);
          
          PSF= getPSFFromLog(dir_log_file_name,given_epid_file_name );
          
          tmp=hisLogToStructure(dir_log_file_name);
            
          pixel_dose_factor=dose_factor;
          
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
                   
                   [gamma_image_file_name,profile_image_file_name,npass,gmean,npass2,gmean2,beam_name2]=profileGammaAnalysisElektaPin2_manual(tps_file,epid_his_file,DTA,tol,PSF,pixel_dose_factor,coll_angle);
                                    
                   % disable the dose generate for IMRT
                   
                   elektaHISToDosePinnacle5_CFM(header,tmp,pixel_dose_factor,epid_his_file);
               
                   
                    % calculate the GLCM features and save into file.
              
                    [tps_glcm,tps_dose]=getGLCMFromTPS(tps_file);
                    
                    [epid_glcm,epid_dose]=getGLCMFromEPID(epid_his_file);
                    
                    handles.patient_database(k).tps_dose=tps_dose;
                    
                    handles.patient_database(k).epid_dose=epid_dose;
                    
                    handles.patient_database(k).epid_glcm=epid_glcm;
                    
                    handles.patient_database(k).tps_glcm=tps_glcm;
                    
                    handles.patient_database(k).gamma_3mm3p_mean=gmean;
                    
                    handles.patient_database(k).gamma_3mm3p_pass=npass;
                    
                    handles.patient_database(k).gamma_2mm2p_mean=gmean2;
                    
                    handles.patient_database(k).gamma_2mm2p_pass=npass2;
                    
                    guidata(hObject,handles);
                    
                    % save to matfile
                    
                    patient_matfile_dir=getappdata(0,'patient_matfile_dir');
                       
                   
                    patient_database=handles.patient_database;                        
                    
                    patient_mat_file=fullfile(patient_matfile_dir,handles.patient_mat_file);
                    
                    save(patient_mat_file,'patient_database');
                    
                    
                    % add other stuff
                    
                    % only perform on this selection.
        
%                     if strcmp( handles.output_option, 'EPID Dose Image+AutoReport')
                        
                        % prepare patient infor for pdf generate
                        
                   
                        
                        beam_name=strcat('Beam: ',num2str(gang_angle));
                        handles.gammaSummaryS(k).beam_name= beam_name;
                        handles.gammaSummaryS(k).m3p3_gamma=npass*100;
                        handles.gammaSummaryS(k).m2p2_gamma=npass2*100;
                        handles.gammaSummaryS(k).mean_gamma_m3p3=gmean;
                        handles.gammaSummaryS(k).mean_gamma_m2p2=gmean2;
                        
                        
                        
                        
                        % Add the Gamma map to structure
                        
                        
                        handles.gamma_sumary(k).mrn=mrn;
                        
                        handles.gamma_sumary(k).treatment_type=handles.treatment_type;
                        
                        handles.gamma_sumary(k).beam_name=gang_angle;
                        
                        
                        handles.gamma_sumary(k).gamma_pass_3mm_3Per=npass*100;
                        
                        handles.gamma_sumary(k).gamma_pass_2mm_2Per=npass2*100;
                        
                        handles.gamma_sumary(k).gamma_mean_3mm_3Per=gmean;
                        
                        handles.gamma_sumary(k).gamma_mean_2mm_2Per=gmean2;
                        
                        guidata(hObject,handles)
                        
                      
                        %get full file name
                        cur_dir=pwd;
                        fnam1=fullfile(cur_dir, gamma_image_file_name);
                        fnam2=fullfile(cur_dir, profile_image_file_name);
                        
                        % copy the file to local user tempfolder.
                        
                        copyfile(fnam1,tempdir);
                        
                        copyfile(fnam2,tempdir);
                        
                        profile_image_file=fullfile(tempdir, profile_image_file_name);
                        gamma_image_file=fullfile(tempdir, gamma_image_file_name);
                        
                        % prepare gammaProfileS
                        
                        
                        handles.gammaProfileS(k).beam_name=beam_name;
                        handles.gammaProfileS(k).profile_image_file_name=profile_image_file;
                        handles.gammaProfileS(k).gamma_image_file_name=gamma_image_file;
                        
                        guidata(hObject,handles);
                        
                        
                        
%                     end
                    
                         
                   
                end % IMRT loop
                
                % Vmat sesssion starts.
                
                if strcmp(treatment_type,'VMAT')  
                    
                    
                     if strcmp( handles.output_option, 'EPID Dose Image+AutoReport')
                         
                     [gamma_image_file_name,profile_image_file_name,numpass3,avg3,numpass2,avg2]=profileGammaAnalysisElektaPin2_Vmat(tps_file,epid_his_file,DTA,tol,PSF,pixel_dose_factor); 
                     
                     end 
                     
                     %[gamma_image_file_name,profile_image_file_name]=profileGammaAnalysisElektaPin2_Vmat(tps_file,epid_his_file,DTA,tol,PSF,pixel_dose_factor);  
                   
                     %dose_factor=getappdata(0,'default_cf');
                     
                     % disable the image conversion.
                     elektaHISToDosePinnacle5_CFM(header,tmp,dose_factor,epid_his_file);
                     
                     npass=numpass3;
                     
                     gmean=avg3;
                     
                     npass2=numpass2;
                     
                     gmean2=avg2;
                      
                     
                                       
                      
                       % calculate the GLCM features and save into file.
              
                       [tps_glcm,tps_dose]=getGLCMFromTPS(tps_file);
                       
                       [epid_glcm,epid_dose]=getGLCMFromEPID(epid_his_file);
                       
                       handles.patient_database(k).tps_dose=tps_dose;
                       
                       handles.patient_database(k).epid_dose=epid_dose;
                       
                       handles.patient_database(k).epid_glcm=epid_glcm;
                       
                       handles.patient_database(k).tps_glcm=tps_glcm;
                       
                       handles.patient_database(k).gamma_3mm3p_mean=avg3;
                       
                       handles.patient_database(k).gamma_3mm3p_pass=numpass3;
                       
                       handles.patient_database(k).gamma_2mm2p_mean=avg2;
                       
                       handles.patient_database(k).gamma_2mm2p_pass=numpass2;
                       
                       guidata(hObject,handles);
                       
                       % save to matfile
                       
                       patient_matfile_dir=getappdata(0,'patient_mat_file_dir');
                       
                       patient_database=handles.patient_database;      
                       
                       patient_mat_file=fullfile(patient_matfile_dir,handles.patient_mat_file);
                       
                       save(patient_mat_file,'patient_database');
                       
                       
                     % only perform on this selection.
                      if strcmp( handles.output_option, 'EPID Dose Image+AutoReport')
                         
                         % prepare patient infor for pdf generate
                         
                         beam_name=strcat('Beam: ',   num2str(gang_angle));
                         handles.gammaSummaryS(k).beam_name= beam_name;
                         handles.gammaSummaryS(k).m3p3_gamma=npass*100;
                         handles.gammaSummaryS(k).m2p2_gamma=npass2*100;
                         handles.gammaSummaryS(k).mean_gamma_m3p3=gmean;
                         handles.gammaSummaryS(k).mean_gamma_m2p2=gmean2;
                         
                         
                         
                         
                         % Add the Gamma map to structure
                         
                         
                         handles.gamma_sumary(k).mrn=mrn;
                         
                         handles.gamma_sumary(k).treatment_type=handles.treatment_type;
                         
                         handles.gamma_sumary(k).beam_name=gang_angle;
                         
                         
                         handles.gamma_sumary(k).gamma_pass_3mm_3Per=npass*100;
                         
                         handles.gamma_sumary(k).gamma_pass_2mm_2Per=npass2*100;
                         
                         handles.gamma_sumary(k).gamma_mean_3mm_3Per=gmean;
                         
                         handles.gamma_sumary(k).gamma_mean_2mm_2Per=gmean2;
                         
                         guidata(hObject,handles)
                         
                         
                         %get full file name
                         cur_dir=pwd;
                         fnam1=fullfile(cur_dir, gamma_image_file_name);
                         fnam2=fullfile(cur_dir, profile_image_file_name);
                         
                         % copy the file to local user tempfolder.
                         
                         copyfile(fnam1,tempdir);
                         
                         copyfile(fnam2,tempdir);
                         
                         profile_image_file=fullfile(tempdir, profile_image_file_name);
                         gamma_image_file=fullfile(tempdir, gamma_image_file_name);
                         
                         % prepare gammaProfileS
                         
                         
                         handles.gammaProfileS(k).beam_name=beam_name;
                         handles.gammaProfileS(k).profile_image_file_name=profile_image_file;
                         handles.gammaProfileS(k).gamma_image_file_name=gamma_image_file;
                         
                         guidata(hObject,handles);
                         
                         
                         
                      end % epid dose
                               
                      
                end % vmat loop
                
                
              end % outer epid dose loop.	
              
%                if strcmp( handles.output_option, 'EPID Dose Image Only')
%                    
%                   elektaHISToDosePinnacle5_CFM(header,tmp,dose_factor,epid_his_file);
%                 
%                end 
%               
          end % pinnalce loop 
    
          
% 	 if strcmp( handles.output_option, 'EPID Dose Image+AutoReport')
%         
%                      % Add the Gamma map to structure
%            
%            
%           handles.gamma_sumary(k).mrn=mrn;
%           
%           handles.gamma_sumary(k).treatment_type=handles.treatment_type;
%           
%           handles.gamma_sumary(k).beam_name= epid_gantry_angle;
%      
%           handles.gamma_sumary(k).gamma_pass_3mm_3Per=npass*100;
%           
%           handles.gamma_sumary(k).gamma_pass_2mm_2Per=npass2*100;
%           
%           handles.gamma_sumary(k).gamma_mean_3mm_3Per=gmean;
%           
%           handles.gamma_sumary(k).gamma_mean_2mm_2Per=gmean2;
%           
%           
%           guidata(hObject,handles);
%           
% end 
%  

  progressbar(double(k)/double(length(epid_file_list)));

             
 end       
               
      
      
                        
          progressbar(double(k)/double(length(epid_file_list)));
          
          
          % once enter the loop, convert into EPID image only  anyway
          
          
 

end % end of elekta machine.

% % after dose conversion copy EPID and dose image to h drive patient directory
% 
v_patient_name_folder=original_driver_dir;

all_file_list2=getAllFiles(v_patient_name_folder); % list all file in the directory

% firstly copy all EPID images file from v to h drive

% h_driver_patient_dir=[h_driver_patient_dir '\'];

% epid_dir=[h_driver_patient_dir '\EPID'];
% tps_dir=[h_driver_patient_dir '\TPS'];
% ana_dir=[h_driver_patient_dir '\Analyzed'];
% 
% auto_report_dir=[h_driver_patient_dir  '\AutoReport'];

epid_dir=fullfile(h_driver_patient_dir,'EPID');
tps_dir=fullfile(h_driver_patient_dir ,'TPS');
ana_dir=fullfile(h_driver_patient_dir ,'Analyzed');

auto_report_dir=fullfile(h_driver_patient_dir ,'AutoReport');


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
     
     if strcmp(tmp_file_type,'pdf')
        
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


end  % function end 





 
 








