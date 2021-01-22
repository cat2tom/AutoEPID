function varargout = AutoEPIDIMRTQA2(varargin)
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

% Last Modified by GUIDE v2.5 10-Apr-2013 08:22:59

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
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AutoEPIDIMRTQA2 (see VARARGIN)

% Choose default command line output for AutoEPIDIMRTQA2
handles.output = hObject;

% save default directory

handles.patient_list_dir='V:\IMRT_Patient_QA'; 
handles.dicom_template_dir='C:'; 
handles.output_dir='H:\IMRT\PatientQA\2013'; 
guidata(hObject, handles); 

patient_list_dir=handles.patient_list_dir;
output_dir=handles.output_dir;
dicom_template_dir=handles.dicom_template_dir;

save('resource.mat', 'patient_list_dir','-append');
save('resource.mat', 'output_dir','-append');
save('resource.mat', 'dicom_template_dir','-append');

  

% set default patient director and dicom template directory
load resource.mat;
if patient_list_dir==0
    
   handles.patient_list_dir='C:\'; 
   
   patient_list_dir=handles.patient_list_dir;
   save('resource.mat', 'patient_list_dir','-append');
       
end
if dicom_template_dir==0
    
   handles.dicom_template_dir='C:\'; 
   
   dicom_template_dir=handles.dicom_template_dir;
   save('resource.mat', 'dicom_template_dir','-append');
    
end

load resource.mat;

handles.patient_list_dir=patient_list_dir;
handles.dicom_template_dir=dicom_template_dir;

% Update handles structure
guidata(hObject, handles);

disp(handles.patient_list_dir);
% UIWAIT makes AutoEPIDIMRTQA2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% list patient name
pat_list=listPatient(handles.patient_list_dir);

set(handles.listbox1,'String',pat_list);

set(handles.progress,'Visible','off');


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

physicist_list={'Richard Short';'Alison Gray';'Armia George';'Jarrad Beggt';...
    'Philip Vial';'Sankar Arumugam';'Satya Rajapakse';'Shrikant Deshpande';...
    'Tania Erven';'Aitang Xing';'Tony Young';'Vinod Nelson';'Virendra Patel';...
    'Gary Goozee'};

set(handles.physicist,'String',physicist_list);

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

pat_list1=listPatient(handles.patient_list_dir);

set(handles.listbox1,'String',pat_list1);

pat_list = cellstr(get(hObject,'String'));

if ~isempty(pat_list)

pat_name=pat_list{get(hObject','Value')};

% return patient subdirectory

handles.patient_name=[handles.patient_list_dir '\' pat_name];

disp(handles.patient_name)

guidata(hObject,handles);

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

AUTOIMRT13_Callback2(handles)

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
 if dicom_dir==0
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
function patient_list_dir_Callback(hObject, eventdata, handles)
% hObject    handle to patient_list_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pat_dir=uigetdir('.','Choose the default directory for dicom template file');
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
 disp(handles.which_tps)


% --- Executes when selected object is changed in epid_pannel.
function epid_pannel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in epid_pannel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
 handles.reference_epid='';
 switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'Yes'
        
        handles.reference_epid='Yes';
        guidata(hObject,handles);
        
    case 'No'
        % Code for when Xio is selected.
        handles.reference_epid='No';
        guidata(hObject,handles);
        
 end 
 disp(handles.reference_epid)


% --- Executes on button press in Exit.
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1);


% --------------------------------------------------------------------
function output_dir_Callback(hObject, eventdata, handles)
% hObject    handle to output_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
output_dir=uigetdir('.','Choose the default directory for dicom template file');
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


% --------------------------------------------------------------------
function cal_file_Callback(hObject, eventdata, handles)
% hObject    handle to cal_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
