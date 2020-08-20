function varargout = epidcal(varargin)
% EPIDCAL MATLAB code for epidcal.fig
%      EPIDCAL, by itself, creates a new EPIDCAL or raises the existing
%      singleton*.
%
%      H = EPIDCAL returns the handle to a new EPIDCAL or the handle to
%      the existing singleton*.
%
%      EPIDCAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EPIDCAL.M with the given input arguments.
%
%      EPIDCAL('Property','Value',...) creates a new EPIDCAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before epidcal_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to epidcal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help epidcal

% Last Modified by GUIDE v2.5 04-Feb-2015 14:40:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @epidcal_OpeningFcn, ...
                   'gui_OutputFcn',  @epidcal_OutputFcn, ...
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


% --- Executes just before epidcal is made visible.
function epidcal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to epidcal (see VARARGIN)

% Choose default command line output for epidcal


handles.output = hObject;

% set the physicsit list at start.

physicist={' ','RG','JB','GG','VP','SA','AX','MJ','SD','JH','DT','TY','SR','VN','TE','AG','BB'};

set(handles.physicist_list,'String',physicist);

% set the default output dir

set(handles.output_dir,'String','H:\IMRT\PatientQA\AUTOEPIDRESOURCE');

% set the default dose


% if strcmp(handles.machine_list,'M5')
%     
%     set(handles.dose,'String','93.9');
%     
% else
%     
%     set(handles.dose,'String','100')
% end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes epidcal wait for user response (see UIRESUME)
% uiwait(handles.epid_cal);


% --- Outputs from this function are returned to the command line.
function varargout = epidcal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile({'*.HIS';'*.IMA';'*.*'} , 'Please select the calibration EPID image file');

tmp_file_name=fullfile(pathname,filename);

handles.epid_image_file=tmp_file_name;

handles.epid_dir=pathname;
guidata(hObject,handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

output_folder = uigetdir('H:\IMRT\PatientQA\AUTOEPIDRESOURCE','Please select output folder for calibration file')

handles.output_path=output_folder;

set(handles.output_dir,'string',output_folder);

guidata(hObject,handles);


function output_dir_Callback(hObject, eventdata, handles)
% hObject    handle to output_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of output_dir as text
%        str2double(get(hObject,'String')) returns contents of output_dir as a double


% --- Executes during object creation, after setting all properties.
function output_dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to output_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in physicist_list.
function physicist_list_Callback(hObject, eventdata, handles)
% hObject    handle to physicist_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns physicist_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from physicist_list
contents = cellstr(get(hObject,'String'));

handles.physicist=contents{get(hObject,'Value')};

disp(handles.physicist)

guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function physicist_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to physicist_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calibrate.
function calibrate_Callback(hObject, eventdata, handles)
% hObject    handle to calibrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


machine=handles.machine;

ref_mu=str2double(get(handles.MU,'String'));

dose=str2double(get(handles.dose,'String'));

epid_image_file=handles.epid_image_file;

output_dir=get(handles.output_dir,'string')

physicist=handles.physicist;

epid_dir=handles.epid_dir;

cal_file_name='';

switch machine
    
    case {'M1','M2','M4'}
        
        [file,path]=uigetfile('.LOG','Please select log file',epid_dir);
        
        dir_log_file_name=fullfile(path,file)
        
        cal_S = EPIDCalibration_Callback_Elekta(machine,ref_mu,dose,epid_image_file, dir_log_file_name, output_dir,physicist)
        
        cal_file_name  = writeEPIDCalFactor(output_dir,machine,cal_S)
        
      
        
    case {'M3','M5'}
        
        cal_S = EPIDCalibration_Callback_Siemens(machine,ref_mu,dose,epid_image_file, output_dir,physicist)
        
        cal_file_name  = writeEPIDCalFactor(output_dir,machine,cal_S);
        
       
        
        
end 

 tmp10=strcat('Done! saved CF at:   ','     ',cal_file_name);
        
 set(handles.status_bar,'String',tmp10);
 
 load(cal_file_name);
        


function MU_Callback(hObject, eventdata, handles)
% hObject    handle to MU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MU as text
%        str2double(get(hObject,'String')) returns contents of MU as a double


% --- Executes during object creation, after setting all properties.
function MU_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dose_Callback(hObject, eventdata, handles)
% hObject    handle to dose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dose as text
%        str2double(get(hObject,'String')) returns contents of dose as a double


% --- Executes during object creation, after setting all properties.
function dose_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in machine_list.
function machine_list_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in machine_list 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

set(handles.status_bar,'string','');
handles.machine=get(eventdata.NewValue,'Tag');


guidata(hObject,handles);

tmp2=handles.machine;

switch tmp2
    case 'M1'
        set(handles.MU,'String',20')
        set(handles.dose,'string','93.9')
    case 'M2'
        set(handles.MU,'String',20')
        set(handles.dose,'String','93.9')
        
    case 'M3'
        set(handles.MU,'String',20')
        set(handles.dose,'string','93.4')
    case 'M4'
        set(handles.MU,'String',20')
        set(handles.dose,'String','93.9')
        
     case 'M5'
        set(handles.MU,'String',20')
        set(handles.dose,'String','93.4')
end        
