
function EPIDose_Callback(handles)

load('H:\IMRT\PatientQA\AUTOEPIDRESOURCE\EPID_CALIBRATION.mat')

whos

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


% The global Gamma criteria

DTA=3; % distance tolerance
tol=3; % dose tolerance


% The directory on V and H driver.

v_driver_dir=handles.patient_list_dir;
h_driver_dir=handles.output_dir;

% v_driver_dir=[v_driver_dir  '\' 'EPID'];

% v_driver_dir='V:\';
% h_driver_dir='H:\IMRT\PatientQA\2013';

% cd(v_driver_dir);

% current_dir=pwd;


% choose which TPS first
      
      tps=handles.which_tps;
      
%      tps=questdlg('Which TPS system was used for this patient IMRT planning?',...
%           'Choose TPS','Xio','Pinnacle','Pinnacle');
%       
% then chose directory

dir_path=handles.patient_name

% dir_path=uigetdir(current_dir,'Choose a Patient directory where subdir EPID and TPS sit'); % ask user to select directory

epid_subdir=[dir_path '\EPID'];

tps_subdir=[dir_path  '\TPS'];

cd(epid_subdir);

all_file_list_epid=getAllFiles(epid_subdir); % list all file in the directory
all_file_list_tps=getAllFiles(tps_subdir);


for i=1:length(all_file_list_epid)
    
    copyfile(all_file_list_epid{i},dir_path);  
    
        
end 



for i=1:length(all_file_list_tps)
   
    
   tmp_file_type=fileType(all_file_list_tps{i}); 
   
    if strcmp(tmp_file_type,'txt')
        
        a=all_file_list_tps{i};
           
        bb=findstr(a,'-');
        
        dd=findstr(a,'_');
        
        ee=a(dd(end)+1:bb-1);
        
        if strcmp(ee,'ISO')
            
        else
            
          
           copyfile(all_file_list_tps{i},dir_path); 
           
        end 
      
      
    else
        
        copyfile(all_file_list_tps{i},dir_path);
        
    end 
    
end 



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


all_file_list=getFileList(dir_path); % list all file in the directory


% list epid files and log files into cell list

epid_file_list=listEPIDFile(all_file_list);


% get file type to see if they are Elekta file or Siemens files

file_type=fileType(epid_file_list{1});

progress_bar_lable='EPID to Dose image conversion';


if strcmp(file_type,'IMA')
    
      
      % decide to get new pixel_to_dose factor or use default one
      
%       ref_field=questdlg('Did you take image for 10x10 field at same SID as IMRT field image?','Choose Yes or No','Yes','No','Yes');
      
          
      ref_field=handles.reference_epid;
      
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
%            SID=1150

%            invF=(SID/1000.0)^2
    
            PixelCalFact=M3_145cm_PixelCalFact;
           
%            PixelCalFact=M3_145cm_PixelCalFact*(SID/1460.0)*(SID/1460.0);
           
         end 

         if strcmp(machine,'M5')
      
            PixelCalFact=M5_150cm_PixelCalFact;
            
%             PixelCalFact=M5_150cm_PixelCalFact*(SID/1500.0)*(SID/1500.0);
         end 

         dose_factor=PixelCalFact;
      end 
    
      pixel_to_dose_factor=dose_factor
  
  % get patient information and machine information for report generation.    
%    [family_name,mrn,beam_name2,epid_gantry_angle,machine]=getPatientInformationFromDicom(epid_file_list{1}); 
      
  % report head start
         
%      report_file_name=[ 'Patient_' family_name '_MRN ' mrn '_' machine '.doc'];
%          
%      % Create a new report in current directory, discarding any existing content
%      reportFilename = report_file_name;
%      if exist(reportFilename, 'file')
%         delete(reportFilename);
%      end
%      reportFilename = fullfile(pwd,reportFilename);
%      wr = wordreport5(reportFilename);
%      headingString = 'Patient Specific IMRT  QA  report ';
% try
%     % Set style to 'Heading 1' for top level titles
%     wr.setstyle([headingString '1']);
%     % Define title
%     textString = 'Patient Specific IMRT QA report';
%     % Insert title in the document
%     wr.addtext(textString, [0 15]); % two line breaks after text
% catch
%     % Error when trying to insert first heading. The generic name for
%     % heading styles must be wrong, problably due to Microsoft Office
%     % language. Resetting to default: ENGLISH (see above for more details)
%     warning('Resetting generic name for heading styles to default ''Heading '''); %#ok<WNTAG>
%     headingString = 'Heading ';
%     wr.setstyle([headingString '1']);
%     textString = 'Patient IMRT QA report';
%     wr.addtext(textString, [0 15]); % two line breaks after text
%     
%     patient_name_st=['Patient Name: '  family_name];
%     mrn_st=['MRN:  '  mrn];
%     machine_st=['Machine: '  machine];
%     
%     wr.setstyle('Heading 2');
%     wr.addtext(patient_name_st);
%     wr.addtext(mrn_st);
%     wr.addtext(machine_st);
%     
%     perform_str=['Performed by:   '  '   '  physcist_name];
%     approval_str=['Approved by:   '  '    '  physcist_name];
%     
%     wr.addtext(perform_str,[4,1])
%     wr.addtext(approval_str);
%     date_string=['Date:     ' date];
%     wr.addtext(date_string);
%     
% end
     
%      wr.setstyle('Heading 1');
%      wr.addpagebreak()
%      wr.addtext('Table of Content', [1 2]); % line break before and after text
%      wr.createtoc(1, 3);
% %      wr.addpagebreak();   
     
     % 
%      wr.addtext(' ',[10,3]);
%      wr.setstyle('Heading 1');
%      wr.addtext('Gamma and profile analysis', [1 1]); % line break before and after text
     % ---

 % report head end        
      
      
         
  for i=1:length(epid_file_list)
          
%          wr.addpagebreak() % add page break for each beam.
%          wr.setstyle('Heading 1');
%          wr.addtext('Gamma and profile analysis', [0 1]); % line break before and after text
%          
         
    
         % turn off the warning message for Siemens EPID conversion.
         warning off 
        
        % direclty call Siments EPID2dose function
          progressbar();
          progress_message1='Converting EPID to Dose for EPID image file: ';
          
          [dir_path_tmp,filename_tmp,ext_tmp]=fileparts(epid_file_list{i});
          
          ima_file_name=[filename_tmp ext_tmp];
          
          progess_message2=ima_file_name;
          
          whole_message=strvcat(progress_message1,progess_message2); 
          
%           disp(whole_message);
          
            whole_message_cell{i}=whole_message;
          
%           disp(whole_message);
          
           set(handles.progress,'String',whole_message_cell);
          
                   
                
          
          % get the EPID dicom file.
          
%           tps_file_dir=dir_path;
%           
%           epid_dicom_file=epid_file_list{i};
%           
%           [family_name,mrn,beam_name2,epid_gantry_angle,machine]=getPatientInformationFromDicom(epid_dicom_file);
%           
%           epid_gantry_angle=str2num(epid_gantry_angle);
%                            
%           
%           machedPin_TPS_file_name=findTPSFileNameFromGantryAngle2(tps_file_dir,epid_gantry_angle);
%          
%           tps_file=machedPin_TPS_file_name;
%           
%           [gang_angle,coll_angle]=findGangtryandCollimatorAngleFromPinTPSFile(tps_file);
%           
          
          % choose right function for TPS system
          
          if strcmp(tps,'Xio')
              
%               [gamma_image_file_name,profile_image_file_name,beam_name2]=profileGammaAnalysisSiemensPin(tps_file,epid_dicom_file,DTA,tol, dose_factor,coll_angle);
              
              epidSiemensToDoseXio6(epid_file_list{i},dose_factor);
        
          end 
          
          if strcmp(tps,'Pinnacle')
              
%               [gamma_image_file_name,profile_image_file_name,beam_name2]=profileGammaAnalysisSiemensPin(tps_file,epid_dicom_file,DTA,tol, dose_factor,coll_angle);
              epidSiemensToDosePinacle6(epid_file_list{i},dose_factor);
          end 
        
        
      % report body start 
      
%         wr.setstyle('Heading 2');
%            
%            beam_name=['Beam: '  beam_name2];
%            
%            wr.addtext(beam_name, [0 1]); % line break after text
% 
%         
%            cur_dir=pwd;
%            
%            fnam1=[cur_dir '\' gamma_image_file_name];
%            
%            fnam2=[cur_dir '\' profile_image_file_name];
%            
%                
%            wr.addfigure(fnam2,fnam1);
%       
%            wr.addpagebreak()
           
      % report body ends
      
            
          progressbar(double(i)/double(length(epid_file_list)));
          
          progressbar(double(i)/double(length(epid_file_list)));
        
  end 

% report tail start
%   wr.addpagenumbers('wdAlignPageNumberRight');
%      
%      
%   wr.updatetoc();
%      
%   wr.close();
  

% report tail end

end % end for Simens machine.

%--------------------------------------------------------------------------
%---------------


if strcmp(file_type,'HIS')
    
      % copy template file from H driver to v patient directory. change the
      % following variable if the location is changed.
      
       % decide to get new pixel_to_dose factor or use default one
      
%       ref_field=questdlg('Did you take image for 10x10 field at same SID as IMRT field image?','Choose Yes or No','Yes','No','Yes');
       
      ref_field=handles.reference_epid;    
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
		  M1_PixelCalFact=0.00010549;  % measured on 05/12/2013 by Michael.
		  
          %M1_PixelCalFact=0.0001045387; %measured 22/5/2012 P.Vial
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
      
      
   % use his log structure to get  patient informaton and machien
   % information
   
   
   family_name=one_his_structure.patient_name;
   
%   beam_name2=one_his_structure.field_name;
   
   epid_gantry_angle=beam_name2;
   
   machine=one_his_structure.station_name;
   
   mrn=one_his_structure.treatment_name;
   
   
      
%   % report head start
%          
%      report_file_name=[ 'Patient_' family_name '_MRN ' mrn '_' machine '.doc'];
%          
%      % Create a new report in current directory, discarding any existing content
%      reportFilename = report_file_name;
%      if exist(reportFilename, 'file')
%         delete(reportFilename);
%      end
%      reportFilename = fullfile(pwd,reportFilename);
%      wr = wordreport5(reportFilename);
%      headingString = 'Patient Specific IMRT  QA  report ';
% try
%     % Set style to 'Heading 1' for top level titles
%     wr.setstyle([headingString '1']);
%     % Define title
%     textString = 'Patient Specific IMRT QA report';
%     % Insert title in the document
%     wr.addtext(textString, [0 15]); % two line breaks after text
% catch
%     % Error when trying to insert first heading. The generic name for
%     % heading styles must be wrong, problably due to Microsoft Office
%     % language. Resetting to default: ENGLISH (see above for more details)
%     warning('Resetting generic name for heading styles to default ''Heading '''); %#ok<WNTAG>
%     headingString = 'Heading ';
%     wr.setstyle([headingString '1']);
%     textString = 'Patient IMRT QA report';
%     wr.addtext(textString, [0 15]); % two line breaks after text
%     
%     patient_name_st=['Patient Name: '  family_name];
%     mrn_st=['MRN:  '  mrn];
%     machine_st=['Machine: '  machine];
%     
%     wr.setstyle('Heading 2');
%     wr.addtext(patient_name_st);
%     wr.addtext(mrn_st);
%     wr.addtext(machine_st);
%     
%     perform_str=['Performed by:   '  '   '  physcist_name];
%     approval_str=['Approved by:   '  '    '  physcist_name];
%     
%     wr.addtext(perform_str,[4,1])
%     wr.addtext(approval_str);
%     
%     date_string=['Date:   ' date];
%     wr.addtext(date_string);
%     
% end
%      
%      wr.setstyle('Heading 1');
%      wr.addpagebreak()
%      wr.addtext('Table of Content', [1 2]); % line break before and after text
%      wr.createtoc(1, 3);
% %      wr.addpagebreak();   
     
     % 
%      wr.addtext(' ',[10,3]);
%      wr.setstyle('Heading 1');
%      wr.addtext('Gamma and profile analysis', [1 1]); % line break before and after text
%      % ---

 % report head end        
         
      
            
        
      for j=1:length(log_structure_list)
          
%           wr.addpagebreak()% add page break for each image.
%           
% %           wr.addtext(' ',[10,3]);
%           wr.setstyle('Heading 1');
%           wr.addtext('Gamma and profile analysis', [0 1]); % line break before and after text
          
%           progress_message1='Converting EPID to Dose for EPID image file: ';
%           
%           progess_message2=log_structure_list(j).file_name;
%           
%           whole_message=[progress_message1 progess_message2]; 
%           
%           disp(whole_message);
%           
          progress_message1='Converting EPID to Dose for EPID image file: ';
          
          progess_message2=log_structure_list(j).file_name;
          
         whole_message=strvcat(progress_message1,progess_message2); 
          
          
%           whole_message=[progress_message1 progess_message2]; 
          
          whole_message_cell{i}=whole_message;
          
%           disp(whole_message);
          
           set(handles.progress,'String',whole_message_cell);
          
      
          %progressbar(progress_bar_lable)
          
          progressbar();
                            
          tmp=log_structure_list(j);
          
%           epid_his_file=tmp.file_name; % get HIS file name from structrue.
%           
%           % get field name of this HIS file assumming the field was named
%           % as g245 or G245 or B245, b245,where 245 is gantry angle.
%           
%           his_field_name_tmp=tmp.field_name
%           
%           his_field_name_tmp=deblank(his_field_name_tmp);
%           
%           gantry_angle_temp1=his_field_name_tmp(3:end);
%           
%           gantry_angle_tmp2=str2num(gantry_angle_temp1);
%           
%           % find the tps file name for this HIS image.
%           tps_file_dir=dir_path;
%                  
%           epid_gantry_angle= gantry_angle_tmp2  
%           
%           machedPin_TPS_file_name=findTPSFileNameFromGantryAngle2(tps_file_dir,epid_gantry_angle);
%           
%           tps_file=machedPin_TPS_file_name
%           
%           [gang_angle,coll_angle]=findGangtryandCollimatorAngleFromPinTPSFile(tps_file);
%         
%           
%           PSF=tmp.pixel_factor;
%           
%           pixel_dose_factor=dose_factor
          
          if strcmp(tps,'Xio')
              
%                 [gamma_image_file_name,profile_image_file_name]=profileGammaAnalysisElektaPin2(tps_file,epid_his_file,DTA,tol,PSF,pixel_dose_factor,coll_angle);              
                elektaHISToDoseXio5(header,tmp,dose_factor);
                                  
          end 
          
          if strcmp(tps,'Pinnacle')
              
%                 [gamma_image_file_name,profile_image_file_name]=profileGammaAnalysisElektaPin2(tps_file,epid_his_file,DTA,tol,PSF,pixel_dose_factor,coll_angle);              
                elektaHISToDosePinnacle5(header,tmp,dose_factor);
              
          end 
        
        % report body start 
        
%       
%         wr.setstyle('Heading 2');
%            
%            beam_name=['Beam: '   his_field_name_tmp];
%            
%            wr.addtext(beam_name, [0 1]); % line break after text
% 
%         
%            cur_dir=pwd;
%            
%            fnam1=[cur_dir '\' gamma_image_file_name];
%            
%            fnam2=[cur_dir '\' profile_image_file_name];
%            
%                
%            wr.addfigure(fnam2,fnam1);
%       
           
      % report body ends
         
                   
          progressbar(double(i)/double(length(epid_file_list)));
          
          progressbar(double(j)/double(length(log_structure_list)));
          
      end
      
% report tail start
%   wr.addpagenumbers('wdAlignPageNumberRight');
%      
%      
%   wr.updatetoc();
%      
%   wr.close();
%   
% 
% % report tail end
      
       

end % end of elekta machine.

% % after dose conversion copy EPID and dose image to h driver patient directory
% 
v_patient_name_folder=original_driver_dir;

all_file_list2=getAllFiles(v_patient_name_folder); % list all file in the directory

% firstly copy all EPID images file from v to h driver

h_driver_patient_dir=[h_driver_patient_dir '\'];

epid_dir=[h_driver_patient_dir '\EPID'];
tps_dir=[h_driver_patient_dir '\TPS'];
ana_dir=[h_driver_patient_dir '\Analyzed'];

% auto_report_dir=[h_driver_patient_dir  '\AutoReport'];

mkdir(epid_dir);

mkdir(tps_dir);

mkdir(ana_dir);

% mkdir(auto_report_dir);


for i=1:length(all_file_list2)
    
    disp('Please wait, the program is doing cleaning up and copying');
    
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
      
      [pathstr, name, ext, versn] = fileparts(all_file_list2{i}); 
      
      
      report_file_name=fullfile(auto_report_dir,[name ext versn]);
        
     end 
     
%     copyfile(all_file_list2{i},h_driver_patient_dir);
%     
   
    
end   

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


% % open the patient directory folder in H driver for inspection.

winopen(h_driver_patient_dir);

done=strvcat('The conversion from EPID images to dose image was done and saved in',h_driver_patient_dir);

msgbox(done);

% open Report for inspection.

% open(report_file_name);
   










