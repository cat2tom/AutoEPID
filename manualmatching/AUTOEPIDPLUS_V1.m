   function varargout = AUTOEPIDPLUS_V1(varargin)
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
%      AUTOEPIDIMRTQA2('Property','Value',...) creates a new AUTOEPIDIMRTQA2 or raises the
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

% Last Modified by GUIDE v2.5 26-Feb-2015 10:49:52

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

% only for ctrix version.

system('net use v: /delete');

system('net use v: \\ctcphapp01\vdrive /user:apps physics99 /persistent:no');

handles.patient_list_dir='v:\IMRT_Patient_QA'; 
handles.dicom_template_dir='H:\IMRT\PatientQA\Ekekta dicom template'; 
handles.output_dir='H:\IMRT\PatientQA\2015\IMRT'; 
guidata(hObject, handles); 

patient_list_dir=handles.patient_list_dir;
output_dir=handles.output_dir;
dicom_template_dir=handles.dicom_template_dir;

save('H:\IMRT\PatientQA\AUTOEPIDRESOURCE\resource.mat', 'patient_list_dir','-append');
save('H:\IMRT\PatientQA\AUTOEPIDRESOURCE\resource.mat', 'output_dir','-append');
save('H:\IMRT\PatientQA\AUTOEPIDRESOURCE\resource.mat', 'dicom_template_dir','-append');
  

% set default patient director and dicom template directory
   
load('H:\IMRT\PatientQA\AUTOEPIDRESOURCE\resource.mat');
% if patient_list_dir==0
%     
%     handles.patient_list_dir='C:\'; 
%    
%    patient_list_dir=handles.patient_list_dir;
%    save('H:\IMRT\PatientQA\AUTOEPIDRESOURCE\resource.mat', 'patient_list_dir','-append');
%        
% end
% if dicom_template_dir==0
%     
%    handles.dicom_template_dir='C:\'; 
%    
%    dicom_template_dir=handles.dicom_template_dir;
%    save('H:\IMRT\PatientQA\AUTOEPIDRESOURCE\resource.mat', 'dicom_template_dir','-append');
%     
% end
% 
% if output_dir==0
%     
%    handles.dicom_template_dir='C:\'; 
%    
%    output_dir=handles.output_dir;
%    save('H:\IMRT\PatientQA\AUTOEPIDRESOURCE\resource.mat', 'dicom_template_dir','-append');
%     
% end



% reload the patient
% load('H:\IMRT\PatientQA\AUTOEPIDRESOURCE\resource.mat');

handles.patient_list_dir=patient_list_dir;
handles.dicom_template_dir=dicom_template_dir;

handles.output_dir=output_dir;

guidata(hObject, handles);

% set the patient list and out directory box

set(handles.all_input_dir,'string',patient_list_dir);

set(handles.all_output_dir,'string',output_dir);


setappdata(0,'patient_list_dir',handles.patient_list_dir);

setappdata(0,'output_dir',output_dir);

setappdata(0,'dicom_template_dir',handles.dicom_template_dir);



disp(handles.all_input_dir);
% UIWAIT makes AutoEPIDIMRTQA2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% list patient name
patient_root_dir=get(handles.all_input_dir,'string');

if isdir(patient_root_dir)
    
 handles.patient_list_dir=patient_root_dir;
 
 guidata(hObject,handles);
    
pat_list=listPatient( handles.patient_list_dir);

  
set(handles.listbox1,'String',pat_list);

set(handles.progress,'Visible','off');

else
    
    set(handles.all_output_dir,'string','Please select a directory where all patient files sit');
    
end 

% update output dir from output box

handles.output_dir=get(handles.all_output_dir,'string');



if ~isdir(handles.output_dir)
    
    set(handles.output_dir,'string','Please selected a root directory for EPID resutls report');
    
end 
    
guidata(hObject,handles);




% axes(handles.logo1);

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

set(handles.tps_pannel,'SelectedObject',[]);
set(handles.epid_pannel,'SelectedObject',[]);

physicist_list={'Radiation therapist';'Richard Short';'Alison Gray';'Armia George';'Jarrad Begg';...
    'Philip Vial';'Sankar Arumugam';'Satya Rajapakse';'Shrikant Deshpande';...
    'Tania Erven';'Aitang Xing';'Tony Young';'Vinod Nelson';'Virendra Patel';...
    'Gary Goozee';'Michael Jameson';'Martin Butson';'Bradley Beeksma';...
	'Daniel Truant';'James Hellyer';'Guest'};

set(handles.physicist,'String',physicist_list);

%load CF files
load('H:\IMRT\PatientQA\AUTOEPIDRESOURCE\EPID_CALIBRATION.mat');

handles.M1_CAL=M1_CAL;

handles.M2_CAL=M2_CAL;

handles.M3_CAL=M3_CAL;

handles.M4_CAL=M4_CAL;

handles.M5_CAL=M5_CAL;

guidata(hObject, handles);


% set the defaut selected 

% set(handles.treatment_type,'selectedobject',handles.IMRT);
% 
% set(handles.tps_pannel,'selectedobject',handles.Pinnacle);
% set(handles.epid_pannel,'selectedobject',handles.autoreport);

set(handles.treatment_type,'selectedobject','');

set(handles.tps_pannel,'selectedobject','');
set(handles.epid_pannel,'selectedobject','');

% add user guide

guide0='1. To quickly know treatment type, Select patient and click manual matching to see tps files and then close it.';

set(handles.user_tip4,'string',guide0);

guide1='2. For IMRT, first try to use Beam auto-matching & auto-report with EPIDdose Image +AutoReport option. Then try manual beam-matching &Auto-Report with same output option. Finally try to use Beam auto-matching & auto-report with EPIDdoseImage only.';

set(handles.user_tip1,'string',guide1);

guide2='3. For VMAT, only use manual beam-matching &Auto-Report with EPIDdose Image +AutoReport option. On the opened beam matching window, click tps file and epid file to match the beam.';

set(handles.user_tip2,'string',guide2);

guide3='4. To calibrate EPID, go to menu ""EPID Calibration"->Calibrate EPID and follow the screen instruction.';

set(handles.user_tip3,'string',guide3);

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


tmp_dir=get(handles.all_input_dir,'string');

pat_list1=listPatient(tmp_dir);

set(handles.listbox1,'String',pat_list1);

pat_list = cellstr(get(hObject,'String'));

if ~isempty(pat_list)

pat_name=pat_list{get(hObject','Value')};

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
       
       tmp10{1}=''
%        set(handles.cf_list,'Value',1);
       set(handles.cf_list,'String',tmp10);      
%        set(handles.cf_list,'Value',1);
       
                  
      
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
    
epid_folder=fullfile(handles.patient_name,'EPID');

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

setappdata(0,'epid_dir',handles.epid_folder);
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

function  pat_list=listPatient(dir_temp)

d = dir(dir_temp);
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



 handles.which_tps='';
 

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
delete(handles.figure1);


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


% --- Executes on button press in epid_dose.
function epid_dose_Callback(hObject, eventdata, handles)
% hObject    handle to epid_dose (see GCBO)
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
    selected=contents{get(hObject,'Value')}
    
    switch handles.which_machine
        
        case 'M1'
            
            index=structfind(handles.M1_CAL,'date',selected)
            
            
            cf=num2str(M1_CAL(index).cal_factor);
                               
            set(handles.default_cf,'string',cf)
            
        case 'M2'
            
            index=structfind(handles.M2_CAL,'date',selected)
            
            
            cf=num2str(M2_CAL(index).cal_factor);
                               
            set(handles.default_cf,'string',cf)
            
        case 'M3'
            
            index=structfind(handles.M3_CAL,'date',selected)
            
            
            cf=num2str(M3_CAL(index).cal_factor);
                               
            set(handles.default_cf,'string',cf)
            
            
            
        case 'M4'
            
            index=structfind(handles.M4_CAL,'date',selected)
            
            
            cf=num2str(M4_CAL(index).cal_factor);
                               
            set(handles.default_cf,'string',cf)
            
            
            
        case 'M5'
            
             index=structfind(handles.M5_CAL,'date',selected)
             
            
             cf=num2str(M5_CAL(index).cal_factor);
                                
             set(handles.default_cf,'string',cf)
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
        
    case 'VMAT'
        % Code for when Xio is selected.
        handles.treatment_type='VMAT';
        guidata(hObject,handles);
        
        setappdata(0,'treatment_type','VMAT');
        
 end 
 
 disp(handles.treatment_type)
 
 test=getappdata(0,'treatment_type')
 
 


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

if strcmp(handles.treatment_type,'VMAT')
        
 ManualMatching2
 
end 

if strcmp(handles.treatment_type,'IMRT')
 AUTOIMRT13_Callback3_CF(handles)
 
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

tmp3_dir=uigetdir('H:\IMRT\PatientQA\2015\','Please select a output folder');

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
    
    
    tmp_dir=get(handles.all_input_dir,'string');

   pat_list1=listPatient(tmp_dir);

  
   if length(pat_list1)<1
       
       pat_list1{1}='No patient found. Please select another folder.'
       
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
    
epid_folder=fullfile(handles.patient_name,'EPID');

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
