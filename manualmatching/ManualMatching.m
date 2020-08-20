function varargout = ManualMatching(varargin)
% MANUALMATCHING MATLAB code for ManualMatching.fig
%      MANUALMATCHING, by itself, creates a new MANUALMATCHING or raises the existing
%      singleton*.
%
%      H = MANUALMATCHING returns the handle to a new MANUALMATCHING or the handle to
%      the existing singleton*.
%
%      MANUALMATCHING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANUALMATCHING.M with the given input arguments.
%
%      MANUALMATCHING('Property','Value',...) creates a new MANUALMATCHING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ManualMatching_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ManualMatching_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ManualMatching

% Last Modified by GUIDE v2.5 09-Feb-2015 14:38:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ManualMatching_OpeningFcn, ...
                   'gui_OutputFcn',  @ManualMatching_OutputFcn, ...
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


% --- Executes just before ManualMatching is made visible.
function ManualMatching_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ManualMatching (see VARARGIN)

% Choose default command line output for ManualMatching
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ManualMatching wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ManualMatching_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in tps_list_box.
function tps_list_box_Callback(hObject, eventdata, handles)
% hObject    handle to tps_list_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tps_list_box contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tps_list_box

[dir_path, ext_cell]=getTPSFileExtCell('C:\aitangResearch\AutoEPID_developement\manualmatching\tps');

set(hObject,'string',ext_cell);

contents = get(hObject,'String');
selected_file=contents{get(hObject,'Value')};

full_file=fullfile(dir_path,selected_file);

[xgrid,ygrid, dose_plane2]=readPinnacleDose4(full_file,1);

colormap(gray)

axes(handles.tps_image);
imagesc(dose_plane2)





% --- Executes during object creation, after setting all properties.
function tps_list_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tps_list_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in epid_list_box.
function epid_list_box_Callback(hObject, eventdata, handles)
% hObject    handle to epid_list_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns epid_list_box contents as cell array
%        contents{get(hObject,'Value')} returns selected item from epid_list_box

[dir_path, ext_cell]=getEPIDFileExtCell('C:\aitangResearch\AutoEPID_developement\manualmatching\epid');

set(hObject,'string',ext_cell);

contents = get(hObject,'String');
selected_file=contents{get(hObject,'Value')};

full_file=fullfile(dir_path,selected_file);

im = readHISfile(full_file);

% [xgrid,ygrid, dose_plane2]=readPinnacleDose4(full_file,1);
colormap(gray)

axes(handles.epid_image);
imagesc(im)


% --- Executes during object creation, after setting all properties.
function epid_list_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epid_list_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in matched_epid_list.
function matched_epid_list_Callback(hObject, eventdata, handles)
% hObject    handle to matched_epid_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns matched_epid_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from matched_epid_list


% --- Executes during object creation, after setting all properties.
function matched_epid_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to matched_epid_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in move_in_epid.
function move_in_epid_Callback(hObject, eventdata, handles)
% hObject    handle to move_in_epid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in move_out_epid.
function move_out_epid_Callback(hObject, eventdata, handles)
% hObject    handle to move_out_epid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in auto_manual.
function auto_manual_Callback(hObject, eventdata, handles)
% hObject    handle to auto_manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in matched_tps_list.
function matched_tps_list_Callback(hObject, eventdata, handles)
% hObject    handle to matched_tps_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns matched_tps_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from matched_tps_list


% --- Executes during object creation, after setting all properties.
function matched_tps_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to matched_tps_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function tps_default_dir_Callback(hObject, eventdata, handles)
% hObject    handle to tps_default_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tps_default_dir as text
%        str2double(get(hObject,'String')) returns contents of tps_default_dir as a double


% --- Executes during object creation, after setting all properties.
function tps_default_dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tps_default_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
