
function Mannual_Callback2_CF(handles)



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



load('H:\IMRT\PatientQA\AUTOEPIDRESOURCE\EPID_CALIBRATION.mat');

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
      
%      tps=questdlg('Which TPS system was used for this patients IMRT planning?',...
%           'Choose TPS','Xio','Pinnacle','Pinnacle');
%       
% then choose directory

dir_path=handles.patient_name;

% dir_path=uigetdir(current_dir,'Choose the patient folder where the subdirectories EPID and TPS are located'); % ask user to select directory

% epid_subdir=[dir_path '\EPID'];
% 
% 
% if ~(exist(epid_subdir,'dir')==7)
%     
% msgbox('Please make sure there is only one EPID subdirectory under the patient folder')
% 
% return;
%     
% end 
% 
% tps_subdir=[dir_path  '\TPS'];

% if ~(exist(tps_subdir,'dir')==7)
%     
% msgbox('Please make sure there is only one TPS subdirectory under the patient folder')
% 
% return;
%     
% end 


% all_file_list_epid=getAllFiles(epid_subdir); % list all file in the directory
% 
% if isempty(all_file_list_epid)
%     
%     msgbox('Please check if there are EPID files in the EPID subdirectory and that the EPID folder is named correctly')
%     
%     return;
%     
% end 
% 
% all_file_list_tps=getAllFiles(tps_subdir);



% if isempty(all_file_list_epid)
%     
%     msgbox('Please check there are TPS files in TPS subdirectory and that the TPS folder is named correctly')
%     
%     fclose('all');
%     
%     return;
%     
% end 

% if ~(length(all_file_list_epid)==length(all_file_list_tps))
%     
% msgbox('Please check if the number of EPID files matches the number of TPS files. Delete the imaging TPS files and any files without TotalDose at the end of the name then restart analysis')
% 
% fclose('all');
% 
% return;
%     
% end 
    
    



% for i=1:length(all_file_list_epid)
%     
%    [status,message]=copyfile(all_file_list_epid{i},dir_path,'f');  
%    
%    if ~isempty(message)
%        
%           msgbox('Please check if the patient directory is readable and accessible')
%           
%           fclose('all');
%           
%           return 
%           
%           
%    end
%     
%         
% end 



% for i=1:length(all_file_list_tps)
%    
%     
%    tmp_file_type=fileType(all_file_list_tps{i}); 
%    
%     if strcmp(tmp_file_type,'txt')
%         
%         tmp_tps_filename=all_file_list_tps{i};
%            
%         tmp_cell=strfind(tmp_tps_filename,'ISO');
%         
%         if isempty(tmp_cell)            
%           
%            copyfile(all_file_list_tps{i},dir_path,'f'); 
%            
%         end 
%       
%       
%     end
%         
%          
% end 



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
          

%           M3_145cm_PixelCalFact=0.000043545; %measured 21/5/2012 P. Vial
%           
%           
%           M5_150cm_PixelCalFact=0.00005093; %measured 23/5/2012 P.Vial
%           
          M3_145cm_PixelCalFact=M3_CAL(end).cal_factor;
          
          M5_150cm_PixelCalFact=M5_CAL(end).cal_factor;
 
          PixelCalFact=M5_150cm_PixelCalFact; 
         if strcmp(machine,'M3')
%            SID=1150

%            invF=(SID/1000.0)^2
    
            %PixelCalFact=M3_145cm_PixelCalFact;
           
           PixelCalFact=M3_145cm_PixelCalFact*(SID/1460.0)*(SID/1460.0);
           
         end 

%          if strcmp(machine,'M5')
%       
%             %PixelCalFact=M5_150cm_PixelCalFact;
%             
%             PixelCalFact=M5_150cm_PixelCalFact*(SID/1500.0)*(SID/1500.0);
% 			
%          end 

         dose_factor=PixelCalFact;
    
    
      pixel_to_dose_factor=dose_factor
  
  % get patient information and machine information for report generation.    
   [family_name,mrn,beam_name2,epid_gantry_angle,machine]=getPatientInformationFromDicom(epid_file_list{1}); 
      
  % report head start
if strcmp( handles.output_option, 'EPID Dose Image+AutoReport')      
     report_file_name=[ 'Patient_' family_name '_MRN ' mrn '_' machine '.doc'];
         
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
               [gamma_image_file_name,profile_image_file_name,beam_name2]=profileGammaAnalysisSiemensPin(tps_file,epid_dicom_file,DTA,tol, dose_factor,coll_angle);
              end
			  epidSiemensToDosePinacle9(epid_file_list{i},dose_factor);
          end 
        
        
      % report body start 
      if strcmp( handles.output_option, 'EPID Dose Image+AutoReport')
        wr.setstyle('Heading 2');
           
           beam_name=['Beam: '  beam_name2];
           
           wr.addtext(beam_name, [0 1]); % line break after text

        
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
      
      h_driver_template_dir='H:\IMRT\PatientQA\Ekekta dicom template\Eleckta_template.dcm'

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

%       
      disp('The default pixel_to_dose measured by Phil for M1 and by Sankar for M2');
      disp('will be used');
          %M1_PixelCalFact=0.00010549;  % measured on 05/12/2013 by Michael.
		  
%           M1_PixelCalFact=0.0001045387; %measured 22/5/2012 P.VialM1_PixelCalFact=0.0001045387; %measured 22/5/2012 P.Vial
          
      M1_PixelCalFact=M1_CAL(end).cal_factor;
		  
          %M2_PixelCalFact=0.0001044300; % measured  30/01/2013 P.Vial
		  %M2_PixelCalFact=0.0001068300;  % measued  30/09/2013  Michael
% 		  M2_PixelCalFact=0.00011822; % Measured by on 29/09/2014 after replacement of pannel.
          
          
      M2_PixelCalFact=M2_CAL(end).cal_factor;
		  
		  %M4_PixelCalFact=  8.7418e-05; % Measured by Alison on 10/09/2014
		  
		  %M4_PixelCalFact=  0.00011822*0.98; % Measured by Alison on 10/09/2014
% 		  M4_PixelCalFact=  1.2012e-004; %Image accquired by Alison 
          
      M4_PixelCalFact=M4_CAL(end).cal_factor;
          
		  
          %M2_PixelCalFact=9.4069e-005; % measured  24/04/2012 Sanka

      PixelCalFact=M1_PixelCalFact;

      if strcmp(his_station_name,' M1-IVIEW')
    
               PixelCalFact=M1_PixelCalFact;
    
      end

      if strcmp(his_station_name,' M2Agility')
    
               PixelCalFact=M2_PixelCalFact;

      end   
         
	  if strcmp(his_station_name,' M4')
    
               PixelCalFact=M4_PixelCalFact;
			   		

      end   
		 
         dose_factor=PixelCalFact;
%       end 
    
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
         
     report_file_name=[ 'Patient_' family_name '_MRN ' mrn '_' machine '.doc'];
         
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
                            
%           tmp=log_structure_list(j);
%           
%           epid_his_file=tmp.file_name; % get HIS file name from structrue.
%           
%           % get field name of this HIS file assumming the field was named
%           % as g245 or G245 or B245, b245,where 245 is gantry angle.
%           
%           his_field_name_tmp=tmp.field_name
%           
%           if isempty(his_field_name_tmp)
%               
%               msgbox('Please open the logfile to check if the typed string in field name is empty or not.')
%               
%               fclose all;
%               
%               return
%           end 
%           
		  % get the gantry angle from log file
		  
		  
%           his_field_name_tmp=deblank(his_field_name_tmp);
% 		  
% 		  tmp_aa=isstrprop(his_field_name_tmp,'digit');
%           
%           tmp_bb=his_field_name_tmp(tmp_aa);
% 		  
% 		  if tmp_TF
% 		    gantry_angle_tmp2=tmp_TF
% 		  
%           else
% 		  
% 		    gantry_angle_temp1=his_field_name_tmp(3:end);
%           
%             gantry_angle_tmp2=str2num(gantry_angle_temp1);
% 		  
%           end 
          
          
          %gantry_angle_temp1=his_field_name_tmp(3:end);
          
%           gantry_angle_tmp2=str2num(gantry_angle_temp1);
          
% 		   gantry_angle_tmp2=str2num(tmp_bb);
% 		  
%           if ~isnumeric(gantry_angle_tmp2)
%               
%               msgbox('Please open the logfile to check if the typed string in field name follows the convention: G270, 270 is the beams gantry angle')
%               
%               fclose all;
%               
%               return
%           end 
          
          
          % find the tps file name for this HIS image.
%           tps_file_dir=dir_path;
%                  
%           epid_gantry_angle= gantry_angle_tmp2  
          
%           machedPin_TPS_file_name=findTPSFileNameFromGantryAngle2(tps_file_dir,epid_gantry_angle)
%           
%           if isempty(machedPin_TPS_file_name)
%               
%               msgbox('Could not find a TPS file to match the EPID image file, please check if the TPS and EPID file names follow the convention')
%               
%               fclose all;
%               
%               return
%           end 
          
          tps_file=tps_file_list{j};
          
          [gang_angle,coll_angle]=findGangtryandCollimatorAngleFromPinTPSFile(tps_file);
        
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
                [gamma_image_file_name,profile_image_file_name]=profileGammaAnalysisElektaPin2(tps_file,epid_his_file,DTA,tol,PSF,pixel_dose_factor,coll_angle);   
              end	
              
                elektaHISToDosePinnacle5(header,tmp,dose_factor);
              
          end 
        
	if strcmp( handles.output_option, 'EPID Dose Image+AutoReport')
        % report body start 
        
      
        wr.setstyle('Heading 2');
           
           beam_name=['Beam: '   num2str(gang_angle)];
           
           wr.addtext(beam_name, [0 1]); % line break after text

        
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
   










