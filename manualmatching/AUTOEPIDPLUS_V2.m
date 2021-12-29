  function varargout = AUTOEPIDPLUS_V2(varargin)
% AUTOEPIDIMRTQA2 MATLAB code for AutoEPIDIMRTQA2.fig
%      AUTOEPIDIMRTQA2, by itself, creates a new AUTOEPIDIMRTQA2 or raises the existing
%      singleton*.
%
%      H = AUTOEPIDIMRTQA2 returns the handle to a new AUTOEPIDIMRTQA2 or the handle to
%      the existing singleton*.
%
%      AUTOEPIDIMRTQA2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AUTOEPIDIMRTQA2.M with the given input arguments.
%
%      AUTOEPIDIMRTQA2('Property','Value',...) creates a new AUTOEPIDIMRTQA2 or r
%
  
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AutoEPIDIMRTQA2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AutoEPIDIMRTQA2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AutoEPIDIMRTQA2

% Last Modified by GUIDE v2.5 29-Oct-2018 14:14:56

% Begin initialization code - DO NOT EDIT

global gamma_image_file_name
global profile_image_file_name
global beam_name2



gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AutoEPIDIMRTQA2_OpeningFcn, ...
                   'gui_OutputFcn',  @AutoEPIDIMRTQA2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before AutoEPIDIMRTQA2 is made visible.
function AutoEPIDIMRTQA2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has autoreport output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AutoEPIDIMRTQA2 (see VARARGIN)

% Choose default command line output for AutoEPIDIMRTQA2
handles.output = hObject;

% only for removing the 10x10 field reference code block.

handles.reference_epid='No';


% read configration file from N driver. It is a configure file.


epidRootConfigFile='C:\autoEPIDConfigfile\autoEPIDRootConfig.ini';

% epidConfigFile='C:\temp\temp51\autoEPIDDirConfigBeta.ini';

% epidConfigFile='C:\autoEPIDConfigfile\autoEPIDDirConfig.ini';

%epidConfigFile='C:\autoEPIDConfigfile\autoEPIDDirConfig_beta.ini';



 [clinical_configFile,beta_configFile] = readAutoEPIDRootConfigFile(epidRootConfigFile);
 
 % Clinical version or beta version.
 
 epidConfigFile=beta_configFile; 

if exist(epidConfigFile,'file')
    
    % logging event
    
    eventLogger('The dir configure file exists','INFO','AutoEPID');
    
else
    
    eventLogger('The dir configure file does exists or could not be found.','INFO','AutoEPID');
    
end 
    

[deleteNetWork,mapNetWork,patientInputDir,dicomTemplateDir,imrtOutputDir,vmatOutputDir,epidCalFile,version_info,escan_dir,backupPatientInputDir,patient_mat_dir] = readAutoEPIDConfigFile(epidConfigFile );

% set program vesion 

set(handles.auto_epid_main,'name',version_info);


eventLogger('Started to map U driver','INFO','AutoEPID');

delete_status=system(deleteNetWork);
map_status=system(mapNetWork);


if map_status==0
    
    
    eventLogger('Udriver was sucessfully mapped','INFO','AutoEPID');
    
    
else
    
    eventLogger('U driver is already in use or Could not be mapped.','INFO','AutoEPID');
  
        
end 

% to see if U driver exist on server. 
if exist(patientInputDir,'dir')
    
    handles.patient_list_dir=patientInputDir;
    
else
    
    if ~exist(backupPatientInputDir,'dir')
        
        % make dir 
        
        mkdir(backupPatientInputDir);
        
        handles.patient_list_dir=backupPatientInputDir;
        
    else
    
    handles.patient_list_dir=backupPatientInputDir;
    
    end 
    
    msgbox(['Udriver is not accessible on server. Please copy the patient folder to ' {} backupPatientInputDir ])
    
    
end


handles.dicom_template_dir=dicomTemplateDir; 

setappdata(0,'dicom_template',handles.dicom_template_dir);


handles.output_dir=imrtOutputDir; 
handles.output_dir_vmat=vmatOutputDir; 

handles.escan_dir=escan_dir;

setappdata(0,'escan_dir',handles.escan_dir);


guidata(hObject, handles); 

patient_list_dir=handles.patient_list_dir;
output_dir=handles.output_dir;
dicom_template_dir=handles.dicom_template_dir;

   
save(epidCalFile, 'patient_list_dir','-append');
save(epidCalFile, 'output_dir','-append');
save(epidCalFile, 'dicom_template_dir','-append');

% set default patient director and dicom template directory
   


eventLogger('Just before loading resource file','INFO','AutoEPID');

load(epidCalFile);


eventLogger('Resource file was loaded suscefully','INFO','AutoEPID');



% reload the patient


handles.patient_list_dir=patient_list_dir;
handles.dicom_template_dir=dicom_template_dir;

handles.output_dir=output_dir;

guidata(hObject, handles);

% set the patient list and out directory box

set(handles.all_input_dir,'string',patient_list_dir);

% set(handles.all_input_dir,'string',patientInputDir);

set(handles.all_output_dir,'string',output_dir);


setappdata(0,'patient_list_dir',handles.patient_list_dir);

all_output_dir=get(handles.all_output_dir);
setappdata(0,'output_dir',all_output_dir);

setappdata(0,'dicom_template_dir',handles.dicom_template_dir);

setappdata(0,'cal_file',epidCalFile);


% disp(handles.all_input_dir);
% UIWAIT makes AutoEPIDIMRTQA2 wait for user response (see UIRESUME)
% uiwait(handles.auto_epid_main);

% list patient name
patient_root_dir=get(handles.all_input_dir,'string');

% if isdir(patient_root_dir)
if exist(patient_root_dir,'dir')==7
    
 handles.patient_list_dir=patient_root_dir;
 
 guidata(hObject,handles);
    
% use MRN to list patient.

pat_list=listPatientByDate( handles.patient_list_dir);

  
set(handles.listbox1,'String',pat_list);

set(handles.progress,'Visible','off');

else
    
    set(handles.all_input_dir,'string','Please Check if your V drive was mapped.');
    
end 

% update output dir from output box

handles.output_dir=get(handles.all_output_dir,'string');



if ~isdir(handles.output_dir)
    
    set(handles.all_output_dir,'string','Please selected a root directory for EPID resutls report');
    
end 
    

guidata(hObject,handles);


% axes(handles.logo1);


imdata1=imread('liverpool_hospital.png');

%imdata1=imread(liverpool_logfile);

% X = load('clown');
% imdata=ind2rgb(X.X,X.map);
% % image_data=imread('clown');

axes(handles.logo1);

image(imdata1);

set(handles.logo1,'XTick',[],'YTick',[])

set(handles.logo1,'XTickLabel',[],'YTickLabel',[]);

axes(handles.logo2);
imdata2=imread('macarthur2.png');
% X = load('clown');
% imdata=ind2rgb(X.X,X.map);
% % image_data=imread('clown');

% xx=load('macarthur.png');
% imdata2=ind2rgb(xx.X,xx.map);

image(imdata2);

set(handles.logo2,'XTick',[],'YTick',[])

set(handles.logo2,'XTickLabel',[],'YTickLabel',[]);

set(handles.tps_pannel,'SelectedObject',[]);
set(handles.epid_pannel,'SelectedObject',[]);

physicist_list={'Radiation therapist';'Richard Short';'Alison Gray';'Pradush Peethambaran';'Armia George';'Jarrad Begg';...
    'Philip Vial';'Sankar Arumugam';'Satya Rajapakse';'Shrikant Deshpande';...
    'Tania Erven';'Aitang Xing';'Tony Young';'Vinod Nelson';'Virendra Patel';...
    'Gary Goozee';'Michael Jameson';'Martin Butson';'Bradley Beeksma';...
	'Daniel Truant';'James Hellyer';'Guest'};

set(handles.physicist,'String',physicist_list);

%load CF files

eventLogger('Just before loading calbiration file.','INFO','AutoEPID');



load(epidCalFile);


eventLogger('The calibration file was sucesfully loaded.','INFO','AutoEPID');


handles.M1_CAL=M1_CAL;

handles.M2_CAL=M2_CAL;

handles.M3_CAL=M3_CAL;

handles.M4_CAL=M4_CAL;

handles.M5_CAL=M5_CAL;

handles.M7_CAL=M7_CAL;

guidata(hObject, handles);


% set the defaut selected 

% set(handles.treatment_type,'selectedobject',handles.IMRT);
% 
 set(handles.tps_pannel,'selectedobject',handles.Pinnacle);
% set(handles.epid_pannel,'selectedobject',handles.autoreport);

set(handles.treatment_type,'selectedobject','');

% set(handles.tps_pannel,'selectedobject','');

set(handles.epid_pannel,'selectedobject','');

% outputTypeObj=get(handles.epid_pannel,'selectedobject');
% 
% outputType=get(outputTypeObj,'Tag');
% 
% handles.output_option=outputType;

% set reg_pannel type to 



 set(handles.reg_pannel,'selectedobject',handles.Reg);
 
 regTypeObj=get(handles.reg_pannel,'selectedobject');
 
 regType2=get(regTypeObj,'Tag');
 
 handles.registrationType=regType2;
 
 setappdata(0,'registrationType',regType2); % set appdata for manual matching.
 
 % set appdata for manual matching 
 
 
 

handles.which_tps='Pinnacle'; % preset the TPS as Pinnalce to remove the tps pannel.

guidata(hObject,handles);

% add user guide

guide0='1. To quickly know treatment type, Select patient and click manual matching to see tps files and then close it.';

set(handles.user_tip4,'string',guide0);

guide1='2. For IMRT, first try to use Beam auto-matching & auto-report with EPIDdose Image +AutoReport option. Then try manual beam-matching &Auto-Report with same output option. Finally try to use Beam auto-matching & auto-report with EPIDdoseImage only.';

set(handles.user_tip1,'string',guide1);

guide2='3. For VMAT, only use manual beam-matching &Auto-Report with EPIDdose Image +AutoReport option. On the opened beam matching window, click tps file and epid file to match the beam.';

set(handles.user_tip2,'string',guide2);

guide3='4. To calibrate EPID, go to menu ""EPID Calibration"->Calibrate EPID and follow the screen instruction.';

set(handles.user_tip3,'string',guide3);

guide5='5. ConvertEPIDtoDose is fully equivalent to EPIDDOSE with the choice of selecting referenece field or use calibration factors in database';

set(handles.user_tip5,'string',guide5);


% add two handdle variable to hold the sumary of 2mm/2% and 3mm/3%
% statistics


handles.gamma_sumary=struct();


% add a handle variable to hold image data, GLCM into a struct

handles.patient_database=struct();



handles.patient_matfile_dir=patient_mat_dir;

setappdata(0,'patient_mat_file_dir',handles.patient_matfile_dir);


% load jar file for pdf report

loadItextJarFiles;

% set physicist to remove the physicist gui

handles.selected_physicist='';

guidata(hObject, handles);


% version information here. version_info-frome configration files.


set(hObject,'Name',version_info);

handles.version_info=version_info;

guidata(hObject,handles);

setappdata(0,'version_info',version_info); % for manual Figure.

mfilename('fullpath')

 

% --- Outputs from this function are returned to the command line.
function varargout = AutoEPIDIMRTQA2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --------------------------------------------------------------------
function template_file_dir_Callback(hObject, eventdata, handles)
% hObject    handle to template_file_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 
% --------------------------------------------------------------------
function open_report_Callback(hObject, eventdata, handles)
% hObject    handle to open_report (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
% list patient name
% clear the previous patient resutls.


 handles.gammaProfileS=struct();
 
 handles.gamma_sumary=struct(); 
 
  
 guidata(hObject,handles);

handles.which_tps='Pinnacle'; % present tps type 
tmp_dir=get(handles.all_input_dir,'string');

% commented out to solove sort issues.

% pat_list1=listPatient2(tmp_dir);
% 
% set(handles.listbox1,'String',pat_list1);

pat_list = cellstr(get(hObject,'String'));

if ~isempty(pat_list)

pat_name=pat_list{get(hObject','Value')};

% logging event

eventLogger(['The selected patient name is:'  pat_name],'INFO','AutoEPID');


handles.output_pat_name=pat_name;

guidata(hObject,handles);

% return patient subdirectory

% handles.patient_name=[handles.all_input_dir '\' pat_name];

handles.patient_name=fullfile(tmp_dir,pat_name);
 
all_file_list2=getFileList(handles.patient_name);
    
if isempty(all_file_list2)

   set(handles.patient_folder,'string','No TPS or EPID files exist. Please check.');
else
    
    
  set(handles.patient_folder,'string',handles.patient_name);
  
  % find the machine and selected which machine 
  
  machine_name=findMachineFromDir(handles.patient_name);
  
    
  handles.which_machine=machine_name;
  
  if machine_name==0
      
       set(handles.machine_name,'string','');
      
      % set calibration factor to none
       set(handles.default_cf,'string','');
        
       set(handles.cf_date,'string','');
        
       set(handles.cf_physicist,'string','');
%        
         tmp10{1}='';
% %        set(handles.cf_list,'Value',1);
          set(handles.cf_list,'String',tmp10);      
% %        set(handles.cf_list,'Value',1);
           
       
           
      
  else
            
       handles.which_machine=machine_name;
       
       setappdata(0,'which_machine',machine_name);
       
       set(handles.machine_name,'string',machine_name);
       guidata(hObject,handles);
       
       % set the calibration factors if epid file exist.
       
     switch machine_name % Get Tag of selected object.
    
       case 'M1'
        
        handles.which_machine='M1';
        guidata(hObject,handles);
       
        % udpate the CF
        
        
        tmp2=handles.M1_CAL;
        
        tmp=tmp2(length(tmp2));
        
            
        cal_factor=tmp.cal_factor;
        
        date=tmp.date;
        
        physicist=tmp.physicist;
        
        
        set(handles.default_cf,'string',num2str(cal_factor));
        
        set(handles.cf_date,'string',date);
        
        set(handles.cf_physicist,'string',physicist);
        
        % get CF list to cell 
        
        cf_list={};
        for k=1:length(tmp2)
            
           cf_list{k}=tmp2(k).date ;
            
        end 
        
        set(handles.cf_list,'String',cf_list,'Value',length(cf_list));
        
      % set calibraion factor for pdf 
      
        handles.pdf_cal=get(handles.default_cf,'string');
        
        handles.pdf_cal_date=get(handles.cf_date,'string');
        
        
        guidata(hObject,handles);
        
        setappdata(0,'pdf_cal',handles.pdf_cal); % For manual windows.
        
        setappdata(0,'pdf_cal_date',handles.pdf_cal_date);
        
        
        
    case 'M2'
        % Code for when Xio is selected.
        handles.which_machine='M2';
        guidata(hObject,handles);
        
        
        % update CF list
        
        
        tmp2=handles.M2_CAL;
                 
        tmp=tmp2(end);
            
        cal_factor=tmp.cal_factor;
        
        date=tmp.date;
        
        physicist=tmp.physicist;
        
        
        set(handles.default_cf,'string',num2str(cal_factor));
        
        set(handles.cf_date,'string',date);
        
        set(handles.cf_physicist,'string',physicist);
        
        % get CF list to cell 
        
        cf_list={};
        for k=1:length(tmp2)
            
           cf_list{k}=tmp2(k).date ;
            
        end 
        
        set(handles.cf_list,'String',cf_list,'Value',length(cf_list));
        
         
        % set calibraion factor for pdf 
      
        handles.pdf_cal=get(handles.default_cf,'string');
        
        handles.pdf_cal_date=get(handles.cf_date,'string');
        guidata(hObject,handles);
        
        setappdata(0,'pdf_cal',handles.pdf_cal); % For manual windows.
        
        setappdata(0,'pdf_cal_date',handles.pdf_cal_date);
        
               
        
    case 'M3'
        % Code for when Xio is selected.
        handles.which_machine='M3';
        guidata(hObject,handles);
        
         % update CF list
        tmp2=handles.M3_CAL;
        
        tmp=tmp2(end);
        
            
        cal_factor=tmp.cal_factor;
        
        date=tmp.date;
        
        physicist=tmp.physicist;
        
        
        set(handles.default_cf,'string',num2str(cal_factor));
        
        set(handles.cf_date,'string',date);
        
        set(handles.cf_physicist,'string',physicist);
        
        % get CF list to cell 
        
        cf_list={};
        for k=1:length(tmp)
            
           cf_list{k}=tmp(k).date ;
            
        end 
        
        set(handles.cf_list,'String',cf_list,'Value',length(cf_list));
        
        % set calibraion factor for pdf 
      
        handles.pdf_cal=get(handles.default_cf,'string');
        
        handles.pdf_cal_date=get(handles.cf_date,'string');
        guidata(hObject,handles);
        
        setappdata(0,'pdf_cal',handles.pdf_cal); % For manual windows.
        
        setappdata(0,'pdf_cal_date',handles.pdf_cal_date);
        
            
        
    case 'M4'
        % Code for when Xio is selected.
        handles.which_machine='M4';
        guidata(hObject,handles);
        
         % update CF list
        tmp2=handles.M4_CAL;
        
        tmp=tmp2(end);    
        cal_factor=tmp.cal_factor;
        
        date=tmp.date;
        
        physicist=tmp.physicist;
        
        
        set(handles.default_cf,'string',num2str(cal_factor));
        
        set(handles.cf_date,'string',date);
        
        set(handles.cf_physicist,'string',physicist);
        
        % get CF list to cell 
        
        cf_list={};
        for k=1:length(tmp2)
            
           cf_list{k}=tmp2(k).date ;
            
        end 
        
        set(handles.cf_list,'String',cf_list,'Value',length(cf_list));
        
         % set calibraion factor for pdf 
      
        handles.pdf_cal=get(handles.default_cf,'string');
        
        handles.pdf_cal_date=get(handles.cf_date,'string');
        guidata(hObject,handles);
        
        setappdata(0,'pdf_cal',handles.pdf_cal); % For manual windows.
        
        setappdata(0,'pdf_cal_date',handles.pdf_cal_date);
        
        
               
    case 'M5'
        % Code for when Xio is selected.
        handles.which_machine='M5';
        guidata(hObject,handles);
        
        %update CF list
        tmp2=handles.M5_CAL;
        
        tmp=tmp2(end);
            
        cal_factor=tmp.cal_factor;
        
        date=tmp.date;
        
        physicist=tmp.physicist;
        
        
        set(handles.default_cf,'string',num2str(cal_factor));
        
        set(handles.cf_date,'string',date);
        
        set(handles.cf_physicist,'string',physicist);
        
        % get CF list to cell 
        
        cf_list={};
        for k=1:length(tmp2)
            
           cf_list{k}=tmp2(k).date ;
            
        end 
        
        set(handles.cf_list,'String',cf_list,'Value',length(cf_list));
        
       % set calibraion factor for pdf 
      
        handles.pdf_cal=get(handles.default_cf,'string');
        
        handles.pdf_cal_date=get(handles.cf_date,'string');
        guidata(hObject,handles);
        
        setappdata(0,'pdf_cal',handles.pdf_cal); % For manual windows.
        
        setappdata(0,'pdf_cal_date',handles.pdf_cal_date);
        
               
        
    case 'M7'
        % Code for when Xio is selected.
        handles.which_machine='M7';
        guidata(hObject,handles);
        
         % update CF list
        tmp2=handles.M7_CAL;
        
        tmp=tmp2(end);
            
        cal_factor=tmp.cal_factor;
        
        date=tmp.date;
        
        physicist=tmp.physicist;
        
        
        set(handles.default_cf,'string',num2str(cal_factor));
        
        set(handles.cf_date,'string',date);
        
        set(handles.cf_physicist,'string',physicist);
        
        % get CF list to cell 
        
        cf_list={};
        for k=1:length(tmp2)
            
           cf_list{k}=tmp2(k).date ;
            
        end 
        
        set(handles.cf_list,'String',cf_list,'Value',length(cf_list));
        
        
         otherwise
     
         eventLogger('No EPID images were found','INFO','AutoEPID');
         
         cf_list1{1}='No EPID Image found';
         
         eventLogger('No calibration factor was displayed','INFO','AutoEPID');
         
         cf_list1{2}='No calibration factor displayed';
         
              
         
         set(handles.cf_list,'String',cf_list1,'Value',1);
         
      % set calibraion factor for pdf 
      
        handles.pdf_cal=get(handles.default_cf,'string');
        
        handles.pdf_cal_date=get(handles.cf_date,'string');
        
        guidata(hObject,handles);
        
        setappdata(0,'pdf_cal',handles.pdf_cal); % For manual windows.
        
        setappdata(0,'pdf_cal_date',handles.pdf_cal_date);
        
            
              
         
     end
     
     
    
              
       
         
         
            
       
  end 
  
  
end 


tps_folder=fullfile(handles.patient_name,'TPS');

if exist(tps_folder,'dir')
    
    set(handles.tps_folder,'string',tps_folder);
    
    all_file_list=getFileList(tps_folder);
    
    if isempty(all_file_list)
        
      set(handles.tps_folder,'string','No TPS files exist');
        
    end 
    
        
else
     set(handles.tps_folder,'string','TPS subfolder does not exist.Please check.');
        
end     
    
epid_folder=fullfile(handles.patient_name,'EPID');

if exist(epid_folder,'dir')
    
    set(handles.epid_folder,'string',epid_folder);
    
    all_file_list=getFileList(epid_folder);
    
    
    if isempty(all_file_list)
        
      set(handles.epid_folder,'string','No EPID files exist');
      
      % set the CF list an empty cell string
      
      cf_list1={};
      
      cf_list1{1}='No EPID Image found';
      
      cf_list1{2}='No calibration factor list';
         
         
      set(handles.cf_list,'String',cf_list1,'Value',1);
      
      
    else
        
     common_cf2=get(handles.default_cf,'string');

     common_cf=str2double(common_cf2);
     
     % set default_cf for manual matching windows.  
     
     setappdata(0,'default_cf', common_cf);  
        
              
    end 
    
       
else
     set(handles.epid_folder,'string','EPID subfolder does not exist.Please check.');
     
   % dealint with CF list dispear issues.
     cf_list1={};
      
     cf_list1{1}='No subEPID folder found';
      
     cf_list1{2}='No calibration factor list';
         
         
     set(handles.cf_list,'String',cf_list1,'Value',1);
      
        
end     



guidata(hObject,handles);

setappdata(0,'patient_dir',handles.patient_name)

setappdata(0,'epid_dir',handles.epid_folder);

% clear all comments

setappdata(0,'report_comments','');

end 



% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in epid_dose.
function epid_dose_Callback(hObject, eventdata, handles)
% hObject    handle to epid_dose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.progress,'Visible','on');

disp(handles.which_tps)

AUTOIMRT13_Callback3(handles)

set(handles.progress,'Visible','off');

imdata1=imread('liverpool_hospital.png');
% X = load('clown');
% imdata=ind2rgb(X.X,X.map);
% % image_data=imread('clown');

axes(handles.logo1);

image(imdata1);

set(handles.logo1,'XTick',[],'YTick',[])

set(handles.logo1,'XTickLabel',[],'YTickLabel',[]);

axes(handles.logo2)
imdata2=imread('macarthur2.png');
% X = load('clown');
% imdata=ind2rgb(X.X,X.map);
% % image_data=imread('clown');

% xx=load('macarthur.png');
% imdata2=ind2rgb(xx.X,xx.map);

image(imdata2);

set(handles.logo2,'XTick',[],'YTick',[])

set(handles.logo2,'XTickLabel',[],'YTickLabel',[]);




% --------------------------------------------------------------------
function Help_tag_Callback(hObject, eventdata, handles)
% hObject    handle to Help_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function About_tag_Callback(hObject, eventdata, handles)
% hObject    handle to About_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --------------------------------------------------------------------
function dicom_template_Callback(hObject, eventdata, handles)
% hObject    handle to dicom_template (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 dicom_dir=uigetdir('.','Choose the default directory for dicom template file');
 if isempty(dicom_dir)
      handles.dicom_template_dir='C:\';
 else
     
    handles.dicom_template_dir='C:\'; 
      
    handles.dicom_template_dir=dicom_dir;
    guidata(hObject, handles);
 
    dicom_template_dir=handles.dicom_template_dir;
    save('resource.mat', 'dicom_template_dir','-append');
    disp(handles.dicom_template_dir)
    
end




% --------------------------------------------------------------------
function all_input_dir_Callback(hObject, eventdata, handles)
% hObject    handle to all_input_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pat_dir=uigetdir('.','Choose the default directory for dicom template file');
 if pat_dir==0
    
    handles.all_input_dir='C:\';
    guidata(hObject,handles);
    
 else
    handles.all_input_dir=pat_dir;
    guidata(hObject, handles);
    patient_list_dir=handles.all_input_dir;
    save('resource.mat', 'patient_list_dir','-append');
    disp(handles.all_input_dir);
    guidata(hObject,handles);

 end 

% list patient name
pat_list=listPatient(handles.all_input_dir);

set(handles.listbox1,'String',pat_list);


% --------------------------------------------------------------------
function print_report_Callback(hObject, eventdata, handles)
% hObject    handle to print_report (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function progress_Callback(hObject, eventdata, handles)
% hObject    handle to progress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of progress as text
%        str2double(get(hObject,'String')) returns contents of progress as a double


% --- Executes during object creation, after setting all properties.
function progress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to progress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function settings_menu_Callback(hObject, eventdata, handles)
% hObject    handle to settings_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function File_menu_Callback(hObject, eventdata, handles)
% hObject    handle to File_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% utility function

function  pat_list=listPatientByMRN(dir_temp)

d = dir(dir_temp);
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';

nameFolds(ismember(nameFolds,{'.','..'})) = [];

pat_list=nameFolds;

% modified patient list to list the patient by date and time

function  pat_list=listPatientByDate(dir_temp)

dirS= dir(dir_temp);

% struct to table

dirT=struct2table(dirS);


% sort the table by date/time 

dirT=sortrows(dirT,'datenum','descend');


% filter the table to get dir only

dirT=dirT(dirT.isdir,:);

% back to dirlist

d=table2struct(dirT);

isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';

nameFolds(ismember(nameFolds,{'.','..'})) = [];

pat_list=nameFolds;



% --- Executes when selected object is changed in tps_pannel.
function tps_pannel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in tps_pannel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)


 % set to Pinnacle to remove the  tps pannel.
 handles.which_tps='Pinnacle';
 

 switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'Pinnacle'
        
        handles.which_tps='Pinnacle';
        guidata(hObject,handles);
        
    case 'Xio'
        % Code for when Xio is selected.
        handles.which_tps='Xio';
        guidata(hObject,handles);
        
 end 
 
 setappdata(0,'which_tps',handles.which_tps);
 disp(handles.which_tps)


% --- Executes when selected object is changed in epid_pannel.
function epid_pannel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in epid_pannel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
 handles.output_option='';
 
 switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
     
    case 'epidimage'
        
        handles.output_option='EPID Dose Image Only';
        guidata(hObject,handles);
        
    case 'autoreport'
        
        % Code for when Xio is selected.
        
        handles.output_option='EPID Dose Image+AutoReport';
        guidata(hObject,handles);
        
 end 
 
 setappdata(0,'output_option',handles.output_option);
 disp(handles.output_option)


% --- Executes on button press in Exit.
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% delete(handles.auto_epid_main);

% use matlab-built in function to turn off the program. 
closereq


% --------------------------------------------------------------------
function all_output_dir_Callback(hObject, eventdata, handles)
% hObject    handle to all_output_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
output_dir=uigetdir('.','Choose the default directory for dicom template file');
 if output_dir==0
    
    handles.all_input_dir='C:\';
    guidata(hObject,handles);
    
 else
    handles.all_output_dir=output_dir;
    guidata(hObject, handles);
    output_dir=handles.all_output_dir;
    save('resource.mat', 'output_dir','-append');
    disp(handles.all_output_dir);
    guidata(hObject,handles);

 end 


% --- Executes during object creation, after setting all properties.
function logo1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to logo1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate logo1


% --- Executes during object creation, after setting all properties.
function logo2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to logo2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate logo2


% --- Executes during object creation, after setting all properties.
function tps_pannel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tps_pannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in physicist.
function physicist_Callback(hObject, eventdata, handles)
% hObject    handle to physicist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns physicist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from physicist

contents = get(hObject,'String');

index=get(hObject,'Value');

selected_physicist=contents{index};

handles.selected_physicist=selected_physicist;


guidata(hObject,handles);

setappdata(0,'physicist',handles.selected_physicist);



% --- Executes during object creation, after setting all properties.
function physicist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to physicist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function calibration_Callback(hObject, eventdata, handles)
% hObject    handle to calibration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function epid_cal_Callback(hObject, eventdata, handles)
% hObject    handle to epid_cal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
epidcal3

% --------------------------------------------------------------------
function cal_file_Callback(hObject, eventdata, handles)
% hObject    handle to cal_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ManualMatching3


function default_cf_Callback(hObject, eventdata, handles)
% hObject    handle to default_cf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of default_cf as text
%        str2double(get(hObject,'String')) returns contents of default_cf as a double


% --- Executes during object creation, after setting all properties.
function default_cf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to default_cf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cf_date_Callback(hObject, eventdata, handles)
% hObject    handle to cf_date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cf_date as text
%        str2double(get(hObject,'String')) returns contents of cf_date as a double


% --- Executes during object creation, after setting all properties.
function cf_date_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cf_date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cf_physicist_Callback(hObject, eventdata, handles)
% hObject    handle to cf_physicist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cf_physicist as text
%        str2double(get(hObject,'String')) returns contents of cf_physicist as a double


% --- Executes during object creation, after setting all properties.
function cf_physicist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cf_physicist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cf_list.
function cf_list_Callback(hObject, eventdata, handles)
% hObject    handle to cf_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cf_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cf_list

    contents = cellstr(get(hObject,'String'));
    selected=contents{get(hObject,'Value')};
    
    switch handles.which_machine
        
        case 'M1'
            
            index=structfind(handles.M1_CAL,'date',selected);
            
            if length(index)>1
               
                index=length(index); % get last one.
                
            end
            
            M1_CAL=handles.M1_CAL;
            
            selected_CF=M1_CAL(index);
            
            % if the selected CF has more than 2 same calibration factor
            % chose the last one.
            if length(selected_CF)>1
                
            selected_CF= selected_CF(end);   
                
            end 
            cf=num2str(selected_CF.cal_factor);
              
            % set the date and Cal factor
            
            set(handles.cf_date,'string',selected_CF.date);
            set(handles.cf_physicist,'string',selected_CF.physicist);
            set(handles.default_cf,'string',cf);
            
            % set calibraion factor for pdf 
      
            handles.pdf_cal=get(handles.default_cf,'string');
        
            handles.pdf_cal_date=get(handles.cf_date,'string');
            guidata(hObject,handles);
        
            setappdata(0,'pdf_cal',handles.pdf_cal); % For manual windows.
        
            setappdata(0,'pdf_cal_date',handles.pdf_cal_date);
            
            
        case 'M2'
            
            index=structfind(handles.M2_CAL,'date',selected);
            
            M2_CAL=handles.M2_CAL;
            
            selected_CF=M2_CAL(index);
            
             % if the selected CF has more than 2 same calibration factor
            % chose the last one.
            if length(selected_CF)>1
                
            selected_CF= selected_CF(end);   
                
            end 
                        
            cf=num2str(selected_CF.cal_factor);
            
             % set the date and Cal factor
            
            set(handles.cf_date,'string',selected_CF.date);
            set(handles.cf_physicist,'string',selected_CF.physicist);
            set(handles.default_cf,'string',cf);
            
             % set calibraion factor for pdf 
      
            handles.pdf_cal=get(handles.default_cf,'string');
        
            handles.pdf_cal_date=get(handles.cf_date,'string');
            guidata(hObject,handles);
        
            setappdata(0,'pdf_cal',handles.pdf_cal); % For manual windows.
        
            setappdata(0,'pdf_cal_date',handles.pdf_cal_date);
            
                                   
        case 'M3'
            
            index=structfind(handles.M3_CAL,'date',selected);
            
            
            cf=num2str(M3_CAL(index).cal_factor);
                               
            set(handles.default_cf,'string',cf)
            
            % set calibraion factor for pdf 
      
            handles.pdf_cal=get(handles.default_cf,'string');
        
            handles.pdf_cal_date=get(handles.cf_date,'string');
            guidata(hObject,handles);
        
            setappdata(0,'pdf_cal',handles.pdf_cal); % For manual windows.
        
            setappdata(0,'pdf_cal_date',handles.pdf_cal_date); 
            
            
            
        case 'M4'
            
            index=structfind(handles.M4_CAL,'date',selected);
            
            M4_CAL=handles.M4_CAL;
            
            selected_CF=M4_CAL(index);
            
             % if the selected CF has more than 2 same calibration factor
            % chose the last one.
            if length(selected_CF)>1
                
            selected_CF= selected_CF(end);   
                
            end 
            
            cf=num2str(selected_CF.cal_factor);
                  
           % set the date and Cal factor
            
            set(handles.cf_date,'string',selected_CF.date);
            set(handles.cf_physicist,'string',selected_CF.physicist);
            set(handles.default_cf,'string',cf);
            
             % set calibraion factor for pdf 
      
            handles.pdf_cal=get(handles.default_cf,'string');
        
            handles.pdf_cal_date=get(handles.cf_date,'string');
            guidata(hObject,handles);
        
            setappdata(0,'pdf_cal',handles.pdf_cal); % For manual windows.
        
            setappdata(0,'pdf_cal_date',handles.pdf_cal_date);
            
                      
        case 'M5'
            
            index=structfind(handles.M5_CAL,'date',selected);
             
            M5_CAL=handles.M5_CAL;
        
            selected_CF=M5_CAL(index);
            
             % if the selected CF has more than 2 same calibration factor
            % chose the last one.
            if length(selected_CF)>1
                
                selected_CF= selected_CF(end);
                
            end 
            
            cf=num2str(selected_CF.cal_factor);
            
            % set the date and Cal factor
            
            set(handles.cf_date,'string',selected_CF.date);
            set(handles.cf_physicist,'string',selected_CF.physicist);
            set(handles.default_cf,'string',cf);
            
             % set calibraion factor for pdf 
      
            handles.pdf_cal=get(handles.default_cf,'string');
        
            handles.pdf_cal_date=get(handles.cf_date,'string');
            guidata(hObject,handles);
        
            setappdata(0,'pdf_cal',handles.pdf_cal); % For manual windows.
        
            setappdata(0,'pdf_cal_date',handles.pdf_cal_date);
            
         
         case 'M7'
            
            index=structfind(handles.M7_CAL,'date',selected);
             
            M7_CAL=handles.M7_CAL;
        
            selected_CF=M7_CAL(index);
            
             % if the selected CF has more than 2 same calibration factor
            % chose the last one.
            if length(selected_CF)>1
                
                selected_CF= selected_CF(end);
                
            end 
            
            cf=num2str(selected_CF.cal_factor);
            
            % set the date and Cal factor
            
            set(handles.cf_date,'string',selected_CF.date);
            set(handles.cf_physicist,'string',selected_CF.physicist);
            set(handles.default_cf,'string',cf);
            
            
            % set calibraion factor for pdf 
      
            handles.pdf_cal=get(handles.default_cf,'string');
        
            handles.pdf_cal_date=get(handles.cf_date,'string');
            guidata(hObject,handles);
        
            setappdata(0,'pdf_cal',handles.pdf_cal); % For manual windows.
        
            setappdata(0,'pdf_cal_date',handles.pdf_cal_date);
               
          
            
    end 
 

% --- Executes during object creation, after setting all properties.
function cf_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cf_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in treatment_type.
function treatment_type_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in treatment_type 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

 handles.treatment_type='';
 

 switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'IMRT'
        
        handles.treatment_type='IMRT';
        guidata(hObject,handles);
        
        setappdata(0,'treatment_type','IMRT');
        
        set(handles.all_output_dir,'string',handles.output_dir);
        
        imrt_output_dir=get(handles.all_output_dir,'string');
        
%         imrt_output_dir1=imrt_output_dir{1};
        % when user change choice, setup different directory.
        setappdata(0,'output_dir',imrt_output_dir);
        
%         handles.output_dir=get(handles.all_output_dir,'string');
%  
%         guidata(hObject,handles);
        
    case 'VMAT'
        % Code for when Xio is selected.
        handles.treatment_type='VMAT';
        guidata(hObject,handles);
        
        setappdata(0,'treatment_type','VMAT');
        
        set(handles.all_output_dir,'string',handles.output_dir_vmat);
        
        % set vmat dir for mannual mapping.
        
        % when user change choice, setup different directory.
%         setappdata(0,'output_dir',handles.all_output_dir);

          vmat_output_dir=get(handles.all_output_dir,'string');
          setappdata(0,'output_dir',vmat_output_dir);
       
          guidata(hObject,handles);
        
 end 
 
 
        
 disp(handles.treatment_type)
 
  
 


% --- Executes when selected object is changed in treatment_machine.
function treatment_machine_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in treatment_machine 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

 handles.which_machine='';
 

 switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'M1'
        
        handles.which_machine='M1';
        guidata(hObject,handles);
       
        % udpate the CF
        
        
        tmp2=handles.M1_CAL;
        
        tmp=tmp2(length(tmp2));
        
            
        cal_factor=tmp.cal_factor;
        
        date=tmp.date;
        
        physicist=tmp.physicist;
        
        
        set(handles.default_cf,'string',num2str(cal_factor));
        
        set(handles.cf_date,'string',date);
        
        set(handles.cf_physicist,'string',physicist);
        
        %get CF list to cell 
        
        cf_list={};
        for k=1:length(tmp)
            
           cf_list{k}=tmp(k).date ;
            
        end 
        
        set(handles.cf_list,'String',cf_list);
        
    case 'M2'
        % Code for when Xio is selected.
        handles.which_machine='M2';
        guidata(hObject,handles);
        
        
        % update CF list
        
        
        tmp2=handles.M2_CAL;
                 
        tmp=tmp2(end);
            
        cal_factor=tmp.cal_factor;
        
        date=tmp.date;
        
        physicist=tmp.physicist;
        
        
        set(handles.default_cf,'string',num2str(cal_factor));
        
        set(handles.cf_date,'string',date);
        
        set(handles.cf_physicist,'string',physicist);
        
        % get CF list to cell 
        
        cf_list={};
        for k=1:length(tmp)
            
           cf_list{k}=tmp(k).date ;
            
        end 
        
        set(handles.cf_list,'String',cf_list);
        
        
        
        
    case 'M3'
        % Code for when Xio is selected.
        handles.which_machine='M3';
        guidata(hObject,handles);
        
         % update CF list
        tmp2=handles.M3_CAL;
        
        tmp=tmp2(end);
        
            
        cal_factor=tmp.cal_factor;
        
        date=tmp.date;
        
        physicist=tmp.physicist;
        
        
        set(handles.default_cf,'string',num2str(cal_factor));
        
        set(handles.cf_date,'string',date);
        
        set(handles.cf_physicist,'string',physicist);
        
        % get CF list to cell 
        
        cf_list={};
        for k=1:length(tmp)
            
           cf_list{k}=tmp(k).date ;
            
        end 
        
        set(handles.cf_list,'String',cf_list);
        
        
        
        
        
        
    case 'M4'
        % Code for when Xio is selected.
        handles.which_machine='M4';
        guidata(hObject,handles);
        
         % update CF list
        tmp2=handles.M4_CAL;
        
        tmp=tmp2(end);    
        cal_factor=tmp.cal_factor;
        
        date=tmp.date;
        
        physicist=tmp.physicist;
        
        
        set(handles.default_cf,'string',num2str(cal_factor));
        
        set(handles.cf_date,'string',date);
        
        set(handles.cf_physicist,'string',physicist);
        
        % get CF list to cell 
        
        cf_list={};
        for k=1:length(tmp)
            
           cf_list{k}=tmp(k).date ;
            
        end 
        
        set(handles.cf_list,'String',cf_list);
        
        
               
    case 'M5'
        % Code for when Xio is selected.
        handles.which_machine='M5';
        guidata(hObject,handles);
        
         % update CF list
        tmp2=handles.M5_CAL;
        
        tmp=tmp2(end);
            
        cal_factor=tmp.cal_factor;
        
        date=tmp.date;
        
        physicist=tmp.physicist;
        
        
        set(handles.default_cf,'string',num2str(cal_factor));
        
        set(handles.cf_date,'string',date);
        
        set(handles.cf_physicist,'string',physicist);
        
        % get CF list to cell 
        
        cf_list={};
        for k=1:length(tmp)
            
           cf_list{k}=tmp(k).date ;
            
        end 
        
        set(handles.cf_list,'String',cf_list);
        
             
        
    case 'M7'
        % Code for when Xio is selected.
        handles.which_machine='M7';
        guidata(hObject,handles);
        
          % update CF list
        tmp2=handles.M7_CAL;
        
        tmp=tmp2(end);
            
        cal_factor=tmp.cal_factor;
        
        date=tmp.date;
        
        physicist=tmp.physicist;
        
        
        set(handles.default_cf,'string',num2str(cal_factor));
        
        set(handles.cf_date,'string',date);
        
        set(handles.cf_physicist,'string',physicist);
        
        % get CF list to cell 
        
        cf_list={};
        for k=1:length(tmp)
            
           cf_list{k}=tmp(k).date ;
            
        end 
        
        set(handles.cf_list,'String',cf_list);
        
            
 end 
 
 setappdata(0,'which_machine',handles.which_machine);
 disp(handles.which_machine)


% --- Executes on button press in epid_dose.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to epid_dose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%  AUTOIMRT13_Callback3_CF(hObject,handles)
 
 % handles has to be returned by fucntion, otherwise, it can not be seen by
 % next function. 
 
 

 registrationType=handles.registrationType;
 
  
 if strcmp(registrationType,'Reg')
 
    handles=AUTOIMRT13_Callback3_CF_PDF(hObject,handles); 
    
   
    disp('Reg');
 
  
 end 
 
 
 if strcmp(registrationType,'noReg')
     
    handles=AUTOIMRT13_Callback3_CF_PDF_noReg(hObject,handles);  
    
    disp('noReg');
    
       
 end 
     
  % get comments from comment windows
  
  handles.comments=getappdata(0,'report_comments');
  
  guidata(hObject,handles);
 
  generateAutoEPIDPDFReport(handles);
  
  % reset the comments to ''
  
  setappdata(0,'report_comments',' ');
  
  guidata(hObject,handles);
 
 % copy to escan 
 
 if isfield(handles,'pdf_report_file_name')
     
 copyfile(handles.pdf_report_file_name,handles.escan_dir);
 
 end 
 
 speakFinished();
 
 % open the pdf report file for inspection if it exists
 
 pdf_report_file_name=handles.pdf_report_file_name;
 
 if exist(pdf_report_file_name,'file')
     
     open(pdf_report_file_name);
     
 end 
 
 





function patient_folder_Callback(hObject, eventdata, handles)
% hObject    handle to patient_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of patient_folder as text
%        str2double(get(hObject,'String')) returns contents of patient_folder as a double


% --- Executes during object creation, after setting all properties.
function patient_folder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to patient_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tps_folder_Callback(hObject, eventdata, handles)
% hObject    handle to tps_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tps_folder as text
%        str2double(get(hObject,'String')) returns contents of tps_folder as a double


% --- Executes during object creation, after setting all properties.
function tps_folder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tps_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function epid_folder_Callback(hObject, eventdata, handles)
% hObject    handle to epid_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epid_folder as text
%        str2double(get(hObject,'String')) returns contents of epid_folder as a double


% --- Executes during object creation, after setting all properties.
function epid_folder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epid_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function machine_name_Callback(hObject, eventdata, handles)
% hObject    handle to machine_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of machine_name as text
%        str2double(get(hObject,'String')) returns contents of machine_name as a double


% --- Executes during object creation, after setting all properties.
function machine_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to machine_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to all_output_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of all_output_dir as text
%        str2double(get(hObject,'String')) returns contents of all_output_dir as a double


% --- Executes during object creation, after setting all properties.
function all_output_dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to all_output_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tmp3_dir=uigetdir('.','Please select a output folder');

set(handles.all_output_dir,'string',tmp3_dir);

% for this figure 
handles.output_dir=tmp3_dir;

guidata(hObject, handles);

setappdata(0,'output_dir',handles.output_dir);

function input_dir_Callback(hObject, eventdata, handles)
% hObject    handle to all_input_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of all_input_dir as text
%        str2double(get(hObject,'String')) returns contents of all_input_dir as a double


% --- Executes during object creation, after setting all properties.
function all_input_dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to all_input_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tmp_dir2=uigetdir('V:\','Please select a root directory where  all patient TPS and EPID files sit.');

if isdir(tmp_dir2)
    
    set(handles.all_input_dir,'string',tmp_dir2);
    
    % get patient root dir from dir box.
    tmp_dir=get(handles.all_input_dir,'string');

    pat_list1=listPatientByDate(tmp_dir);

  
   if length(pat_list1)<1
       
       pat_list1{1}='No patient found. Please select another folder.';
       
       set(handles.listbox1,'String',pat_list1);
       
   else
       
       
     set(handles.listbox1,'String',pat_list1);
   
   end 

pat_list = cellstr(get(hObject,'String'));

if ~isempty(pat_list)

pat_name=pat_list{get(hObject','Value')};

% return patient subdirectory

% handles.patient_name=[handles.all_input_dir '\' pat_name];

handles.patient_name=fullfile(tmp_dir,pat_name);
 
all_file_list2=getFileList(handles.patient_name);
    
if isempty(all_file_list2)

   set(handles.patient_folder,'string','No TPS or EPID files exist. Please check.');
else
    
    
  set(handles.patient_folder,'string',handles.patient_name);
  
  % find the machine and selected which machine 
  
  machine_name=findMachineFromDir(handles.patient_name);
  
  handles.which_machine=machine_name;
  
  if machine_name==0
      
      set(handles.machine_name,'string','');
      
      % set calibration factor to none
       set(handles.default_cf,'string','');
        
       set(handles.cf_date,'string','');
        
       set(handles.cf_physicist,'string','');
       
       set(handles.cf_list,'String',{});
      
      
  else
            
       handles.which_machine=machine_name;
       
       setappdata(0,'which_machine',machine_name);
       
       set(handles.machine_name,'string',machine_name);
       guidata(hObject,handles);
       
       % set the calibration factors if epid file exist.
       
       switch machine_name % Get Tag of selected object.
    
       case 'M1'
        
        handles.which_machine='M1';
        guidata(hObject,handles);
       
        % udpate the CF
        
        
        tmp2=handles.M1_CAL;
        
        tmp=tmp2(end);
        
            
        cal_factor=tmp.cal_factor;
        
        date=tmp.date;
        
        physicist=tmp.physicist;
        
        
        set(handles.default_cf,'string',num2str(cal_factor));
        
        set(handles.cf_date,'string',date);
        
        set(handles.cf_physicist,'string',physicist);
        
        % get CF list to cell 
        
        cf_list={};
        for k=1:length(tmp)
            
           cf_list{k}=tmp(k).date ;
            
        end 
        
        set(handles.cf_list,'String',cf_list);
        
    case 'M2'
        % Code for when Xio is selected.
        handles.which_machine='M2';
        guidata(hObject,handles);
        
        
        % update CF list
        
        
        tmp2=handles.M2_CAL;
                 
        tmp=tmp2(end);
            
        cal_factor=tmp.cal_factor;
        
        date=tmp.date;
        
        physicist=tmp.physicist;
        
        
        set(handles.default_cf,'string',num2str(cal_factor));
        
        set(handles.cf_date,'string',date);
        
        set(handles.cf_physicist,'string',physicist);
        
        % get CF list to cell 
        
        cf_list={};
        for k=1:length(tmp)
            
           cf_list{k}=tmp(k).date ;
            
        end 
        
        set(handles.cf_list,'String',cf_list);
        
        
        
        
    case 'M3'
        % Code for when Xio is selected.
        handles.which_machine='M3';
        guidata(hObject,handles);
        
         % update CF list
        tmp2=handles.M3_CAL;
        
        tmp=tmp2(end);
        
            
        cal_factor=tmp.cal_factor;
        
        date=tmp.date;
        
        physicist=tmp.physicist;
        
        
        set(handles.default_cf,'string',num2str(cal_factor));
        
        set(handles.cf_date,'string',date);
        
        set(handles.cf_physicist,'string',physicist);
        
        % get CF list to cell 
        
        cf_list={};
        for k=1:length(tmp)
            
           cf_list{k}=tmp(k).date ;
            
        end 
        
        set(handles.cf_list,'String',cf_list);
        
           
        
    case 'M4'
        % Code for when Xio is selected.
        handles.which_machine='M4';
        guidata(hObject,handles);
        
         % update CF list
        tmp2=handles.M4_CAL;
        
        tmp=tmp2(end);    
        cal_factor=tmp.cal_factor;
        
        date=tmp.date;
        
        physicist=tmp.physicist;
        
        
        set(handles.default_cf,'string',num2str(cal_factor));
        
        set(handles.cf_date,'string',date);
        
        set(handles.cf_physicist,'string',physicist);
        
        % get CF list to cell 
        
        cf_list={};
        for k=1:length(tmp)
            
           cf_list{k}=tmp(k).date ;
            
        end 
        
        set(handles.cf_list,'String',cf_list);
        
        
               
    case 'M5'
        % Code for when Xio is selected.
        handles.which_machine='M5';
        guidata(hObject,handles);
        
         % update CF list
        tmp2=handles.M5_CAL;
        
        tmp=tmp2(end);
            
        cal_factor=tmp.cal_factor;
        
        date=tmp.date;
        
        physicist=tmp.physicist;
        
        
        set(handles.default_cf,'string',num2str(cal_factor));
        
        set(handles.cf_date,'string',date);
        
        set(handles.cf_physicist,'string',physicist);
        
        % get CF list to cell 
        
        cf_list={};
        for k=1:length(tmp)
            
           cf_list{k}=tmp(k).date ;
            
        end 
        
        set(handles.cf_list,'String',cf_list);
        
             
        
    case 'M6'
        % Code for when Xio is selected.
        handles.which_machine='M6';
        guidata(hObject,handles);
        
 end
            
       
  end 
  
end 


tps_folder=fullfile(handles.patient_name,'TPS');

if exist(tps_folder,'dir')
    
    set(handles.tps_folder,'string',tps_folder);
    
    all_file_list=getFileList(tps_folder);
    
    if isempty(all_file_list)
        
      set(handles.tps_folder,'string','No TPS files exist');
        
    end 
    
        
else
     set(handles.tps_folder,'string','TPS subfolder does not exist.Please check.');
        
end     

handles.patient_name
epid_folder=fullfile(handles.patient_name,'EPID')

if exist(epid_folder,'dir')
    
    set(handles.epid_folder,'string',epid_folder);
    
    all_file_list=getFileList(epid_folder);
    
    
    if isempty(all_file_list)
        
      set(handles.epid_folder,'string','No EPID files exist');
      
    else
        
     common_cf2=get(handles.default_cf,'string');

     common_cf=str2double(common_cf2);
     
     setappdata(0,'default_cf', common_cf);  
        
              
    end 
    
       
else
     set(handles.epid_folder,'string','EPID subfolder does not exist.Please check.');
     
    
        
end     



guidata(hObject,handles);

setappdata(0,'patient_dir',handles.patient_name)

end 
    
    
 
    
else
    
    
   set(handles.all_input_dir,'string','Please selected a directory'); 
    
       
end 


% --- Executes during object creation, after setting all properties.
function user_tip1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to user_tip1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function patient_list_dir_Callback(hObject, eventdata, handles)
% hObject    handle to patient_list_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pat_dir=uigetdir('.','Choose the default directory for patient list');
 if pat_dir==0
    
    handles.patient_list_dir='C:\';
    guidata(hObject,handles);
    
 else
    handles.patient_list_dir=pat_dir;
    guidata(hObject, handles);
    patient_list_dir=handles.patient_list_dir;
    save('resource.mat', 'patient_list_dir','-append');
    disp(handles.patient_list_dir);
    guidata(hObject,handles);

 end 

% list patient name
pat_list=listPatient(handles.patient_list_dir);

set(handles.listbox1,'String',pat_list);

% --------------------------------------------------------------------
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pat_dir=uigetdir('.','Choose the default directory for patient list');
 if pat_dir==0
    
    handles.patient_list_dir='C:\';
    guidata(hObject,handles);
    
 else
    handles.patient_list_dir=pat_dir;
    guidata(hObject, handles);
    patient_list_dir=handles.patient_list_dir;
    save('resource.mat', 'patient_list_dir','-append');
    disp(handles.patient_list_dir);
    guidata(hObject,handles);

 end 

% list patient name
pat_list=listPatient(handles.patient_list_dir);

set(handles.listbox1,'String',pat_list);


% --------------------------------------------------------------------
function output_dir_Callback(hObject, eventdata, handles)
% hObject    handle to output_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

output_dir=uigetdir('.','Choose the default directory for output');
 if output_dir==0
    
    handles.patient_list_dir='C:\';
    guidata(hObject,handles);
    
 else
    handles.output_dir=output_dir;
    guidata(hObject, handles);
    output_dir=handles.output_dir;
    save('resource.mat', 'output_dir','-append');
    disp(handles.output_dir);
    guidata(hObject,handles);

 end 


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



EPIDDOSE_CF(handles);


% --- Executes during object creation, after setting all properties.
function treatment_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to treatment_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in Pinnacle.
function Pinnacle_Callback(hObject, eventdata, handles)
% hObject    handle to Pinnacle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Pinnacle


% --- Executes when selected object is changed in reg_pannel.
function reg_pannel_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in reg_pannel 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% added handles to reg_pannel buttons

handles.registrationType=''; 


switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    
    case 'Reg'
        
        handles.registrationType='Reg';
        guidata(hObject,handles);
        
        setappdata(0,'registrationType','Reg');
        
       
    case 'noReg'
       
        
        handles.registrationType='noReg';
        guidata(hObject,handles);
        
        setappdata(0,'registrationType','noReg');
       
        
end 

% handles.registrationType
 
 


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get patient list
% get patient root dir from dir box.


%pat_list=listPatientByDate( handles.patient_list_dir);

tmp_dir=get(handles.all_input_dir,'string');


pat_list=listPatientByDate(tmp_dir);

  
set(handles.listbox1,'String',pat_list);

guidata(hObject,handles);

% fixed the issue to write report to write destination.


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% pat_list=listPatientByMRN( handles.patient_list_dir);

% get patient root dir from dir box.
tmp_dir=get(handles.all_input_dir,'string');

pat_list=listPatientByMRN(tmp_dir);

set(handles.listbox1,'String',pat_list);

guidata(hObject,handles);


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%pat_list=listPatientByDate( handles.patient_list_dir);

% get patient root dir from dir box.
tmp_dir=get(handles.all_input_dir,'string');


pat_list=listPatientByDate( tmp_dir);

  
set(handles.listbox1,'String',pat_list);

guidata(hObject,handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over listbox1.
function listbox1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function user_guide_Callback(hObject, eventdata, handles)
% hObject    handle to user_guide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


user_guide='N:\PROJECTS\IMRT implementation\EPID Dosimetry Commissioning\autoEPID documents\AutoEPID user guide.pdf';
 if exist(user_guide,'file')
     
     open(user_guide);
     
 else
     
     message='can not find user guide which is suppose to be sitting at N:\PROJECTS\IMRT implementation\EPID Dosimetry Commissioning\autoEPID documents';
     eventLogger(message,'INFO','AutoEPID');
     
 end 
 


% --- Executes on button press in add_comment.
function add_comment_Callback(hObject, eventdata, handles)
% hObject    handle to add_comment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get comments 

%open the comments windows to add the comments.

comments;
