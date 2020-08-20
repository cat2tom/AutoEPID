function varargout = IMRTCheck(varargin)
% IMRTCHECK M-file for IMRTCheck.fig
%      IMRTCHECK, by itself, creates a new IMRTCHECK or raises the existing
%      singleton*.
%
%      H = IMRTCHECK returns the handle to a new IMRTCHECK or the handle to
%      the existing singleton*.
%
%      IMRTCHECK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMRTCHECK.M with the given input arguments.
%
%      IMRTCHECK('Property','Value',...) creates a new IMRTCHECK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IMRTCheck_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IMRTCheck_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IMRTCheck

% Last Modified by GUIDE v2.5 31-Mar-2011 17:14:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IMRTCheck_OpeningFcn, ...
                   'gui_OutputFcn',  @IMRTCheck_OutputFcn, ...
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


% --- Executes just before IMRTCheck is made visible.
function IMRTCheck_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IMRTCheck (see VARARGIN)

% Choose default command line output for IMRTCheck
handles.output = hObject;

% Get default values from parameter file
if IsParameter('CALDIR')
    caldir = GetParameter('CALDIR');
else
    caldir = pwd;
end
setappdata(handles.caldir_menu,'currentdir',caldir);

if IsParameter('TPSDIR')
    tpsdir = GetParameter('TPSDIR');
else
    tpsdir = pwd;
end
setappdata(handles.tpsdir_menu,'currentdir',tpsdir);

if IsParameter('EPIDDIR')
    epiddir = GetParameter('EPIDDIR');
else
    epiddir = pwd;
end
setappdata(handles.epiddir_menu,'currentdir',epiddir);

if IsParameter('MUCALAPPLIED')
    mucalapplied = GetParameter('MUCALAPPLIED');
else
    mucalapplied = 100;
end
set(handles.calmu_edit,'String',num2str(mucalapplied));

if IsParameter('MUCAL')
    mucal = GetParameter('MUCAL');
else
    mucal = 1;
    AddParameter(mucal,'MUCAL');
end
setappdata(handles.machinecal_menu,'mucal',mucal);

if IsParameter('FSIZECAL')
    fsize = GetParameter('FSIZECAL');
else
    fsize = 10;
    AddParameter(fsize,'FSIZECAL');
end
setappdata(handles.machinecal_menu,'fsize',fsize);

if IsParameter('SSDCAL')
    ssd = GetParameter('SSDCAL');
else
    ssd = 100;
    AddParameter(ssd,'SSDCAL');
end
setappdata(handles.machinecal_menu,'ssd',ssd);

if IsParameter('DEPTHCAL')
    depth = GetParameter('DEPTHCAL');
else
    depth = 1.5;
    AddParameter(depth,'DEPTHCAL');
end
setappdata(handles.machinecal_menu,'depth',depth);

if IsParameter('PDD')
    pdd = GetParameter('PDD');
else
    % No PDD data defined
    msgbox('No Percent-Depth Dose data found!','Configuration Error','error');
end
setappdata(handles.pdd_menu,'pdd',pdd);

if IsParameter('TPSSSD')
    tpsssd = GetParameter('TPSSSD');
else
    tpsssd = 100;
    AddParameter(tpsssd,'TPSSSD');
end
set(handles.tpsssd_edit,'String',num2str(tpsssd));

if IsParameter('TPSDEPTH')
    tpsdepth = GetParameter('TPSDEPTH');
else
    tpsdepth = 5;
    AddParameter(tpsdepth,'TPSDEPTH');
end
set(handles.tpsdepth_edit,'String',num2str(tpsdepth));

if IsParameter('MAPCHECKDIR')
    mapcheckdir = GetParameter('MAPCHECKDIR');
else
    mapcheckdir = pwd;
end
setappdata(handles.mapcheckdir_menu,'currentdir',mapcheckdir);

if IsParameter('MAPCHECKSSD')
    mapcheckssd = GetParameter('MAPCHECKSSD');
else
    mapcheckssd = 100;
    AddParameter(mapcheckssd,'MAPCHECKSSD');
end
set(handles.mapcheckssd_edit,'String',num2str(mapcheckssd));

if IsParameter('MAPCHECKDEPTH')
    mapcheckdepth = GetParameter('MAPCHECKDEPTH');
else
    mapcheckdepth = 2;
    AddParameter(mapcheckdepth,'MAPCHECKDEPTH');
end
set(handles.mapcheckdepth_edit,'String',num2str(mapcheckdepth));

% Update the lists of files available in the various selection boxes
UpdateCalibrationList(handles);
UpdateTPSList(handles);
UpdateEPIDList(handles);
UpdateMapCheckList(handles);

% Set mode
seteclipsemode(handles);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes IMRTCheck wait for user response (see UIRESUME)
% uiwait(handles.IMRTCheck_fig);


% --- Outputs from this function are returned to the command line.
function varargout = IMRTCheck_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in calculate_pushbutton.
function calculate_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to calculate_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Determine which mode has been set
tpscheck = get(handles.eclipsemode_menu,'Checked');
if strcmp(tpscheck,'on')
    % TPS vs Epid mode
    getTPS = true;
    getEpid = true;
    getMapcheck = false;
end
mccheck = get(handles.mapcheckmode_menu,'Checked');
if strcmp(mccheck,'on')
    % Mapcheck vs Epid mode
    getTPS = false;
    getEpid = true;
    getMapcheck = true;
end
mctpscheck = get(handles.mctpsmode_menu,'Checked');
if strcmp(mctpscheck,'on')
    % Mapcheck vs TPS mode
    getTPS = true;
    getEpid = false;
    getMapcheck = true;
end

if getEpid
    % Get the calibration directory, files
    cdir = getappdata(handles.caldir_menu,'currentdir');
    filelist = get(handles.calfile1_popupmenu,'String');
    cfileindex = get(handles.calfile1_popupmenu,'Value');
    filetypelist = get(handles.calfiletype_popupmenu,'String');
    filetypeindex = get(handles.calfiletype_popupmenu,'Value');
    cfile1 = fullfile(cdir,[filelist{cfileindex} '.' filetypelist{filetypeindex}]);

    cfileindex = get(handles.calfile2_popupmenu,'Value');
    cfile2 = fullfile(cdir,[filelist{cfileindex} '.' filetypelist{filetypeindex}]);

    % Get the number of MU applied in the calibration images
    epidcalmu_str = get(handles.calmu_edit,'String');
    epidcalmu = str2double(epidcalmu_str);

    % Get the EPID file
    cdir = getappdata(handles.epiddir_menu,'currentdir');
    filelist = get(handles.epidimage_popupmenu,'String');
    cfileindex = get(handles.epidimage_popupmenu,'Value');
    filetypelist = get(handles.epidfiletype_popupmenu,'String');
    filetypeindex = get(handles.epidfiletype_popupmenu,'Value');
    epidfile = fullfile(cdir,[filelist{cfileindex} '.' filetypelist{filetypeindex}]);

    % Get the reference PDD Data
    PDD = getappdata(handles.pdd_menu,'pdd');

    % Get the machine parameters
    mucal = getappdata(handles.machinecal_menu,'mucal');
    fsizecal = getappdata(handles.machinecal_menu,'fsize');
    ssdcal = getappdata(handles.machinecal_menu,'ssd');
    depthcal = getappdata(handles.machinecal_menu,'depth');

end

% Determine which comparison mode selected and compare to appropriate data
if getTPS
    % Get the TPS file
    cdir = getappdata(handles.tpsdir_menu,'currentdir');
    filelist = get(handles.tpsfile_popupmenu,'String');
    cfileindex = get(handles.tpsfile_popupmenu,'Value');
    filetypelist = get(handles.tpsfiletype_popupmenu,'String');
    filetypeindex = get(handles.tpsfiletype_popupmenu,'Value');
    tpsfile = fullfile(cdir,[filelist{cfileindex} '.' filetypelist{filetypeindex}]);

    % Get the TPS SSD and depth
    tpsssd_str = get(handles.tpsssd_edit,'String');
    tpsssd = str2double(tpsssd_str);

    tpsdepth_str = get(handles.tpsdepth_edit,'String');
    tpsdepth = str2double(tpsdepth_str);
    
end

if getMapcheck
    % Get the mapcheck file
    cdir = getappdata(handles.mapcheckdir_menu,'currentdir');
    filelist = get(handles.mapcheckfile_popupmenu,'String');
    cfileindex = get(handles.mapcheckfile_popupmenu,'Value');
    filetypelist = get(handles.mapcheckfiletype_popupmenu,'String');
    filetypeindex = get(handles.mapcheckfiletype_popupmenu,'Value');
    mapcheckfile = fullfile(cdir,[filelist{cfileindex} '.' filetypelist{filetypeindex}]);
    
    % Get the mapcheck SSD and depth
    mapcheckssd_str = get(handles.mapcheckssd_edit,'String');
    mapcheckssd = str2double(mapcheckssd_str);

    mapcheckdepth_str = get(handles.mapcheckdepth_edit,'String');
    mapcheckdepth = str2double(mapcheckdepth_str);
    
end

% Choose which comparison to perform
if getEpid && getTPS
    % Call the analysis function
    IMRTCompare({cfile1;cfile2},epidfile,tpsfile,tpsssd,tpsdepth,PDD,epidcalmu,mucal,depthcal,ssdcal,fsizecal);
end
if getEpid && getMapcheck
    % Call the analysis function
    MapCheckCompare({cfile1;cfile2},epidfile,mapcheckfile,mapcheckssd,mapcheckdepth,PDD,epidcalmu,mucal,depthcal,ssdcal,fsizecal);
end
if getTPS && getMapcheck
    MCEclipseCompare(mapcheckfile,tpsfile,tpsssd,tpsdepth);
end

% --- Executes on button press in exit_pushbutton.
function exit_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to exit_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.IMRTCheck_fig);


function epidimage_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to epidimage_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epidimage_popupmenu as text
%        str2double(get(hObject,'String')) returns contents of epidimage_popupmenu as a double


% --- Executes during object creation, after setting all properties.
function epidimage_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epidimage_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in epidimage_pushbutton.
function epidimage_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to epidimage_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function tpsfile_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to tpsfile_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tpsfile_popupmenu as text
%        str2double(get(hObject,'String')) returns contents of tpsfile_popupmenu as a double


% --- Executes during object creation, after setting all properties.
function tpsfile_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tpsfile_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tpsselect_pushbutton.
function tpsselect_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to tpsselect_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function tpsssd_edit_Callback(hObject, eventdata, handles)
% hObject    handle to tpsssd_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tpsssd_edit as text
%        str2double(get(hObject,'String')) returns contents of tpsssd_edit as a double


% --- Executes during object creation, after setting all properties.
function tpsssd_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tpsssd_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tpsdepth_edit_Callback(hObject, eventdata, handles)
% hObject    handle to tpsdepth_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tpsdepth_edit as text
%        str2double(get(hObject,'String')) returns contents of tpsdepth_edit as a double


% --- Executes during object creation, after setting all properties.
function tpsdepth_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tpsdepth_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function muval_edit_Callback(hObject, eventdata, handles)
% hObject    handle to muval_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of muval_edit as text
%        str2double(get(hObject,'String')) returns contents of muval_edit as a double


% --- Executes during object creation, after setting all properties.
function muval_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to muval_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SSDval_edit_Callback(hObject, eventdata, handles)
% hObject    handle to SSDval_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SSDval_edit as text
%        str2double(get(hObject,'String')) returns contents of SSDval_edit as a double


% --- Executes during object creation, after setting all properties.
function SSDval_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SSDval_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function depthval_edit_Callback(hObject, eventdata, handles)
% hObject    handle to depthval_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of depthval_edit as text
%        str2double(get(hObject,'String')) returns contents of depthval_edit as a double


% --- Executes during object creation, after setting all properties.
function depthval_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to depthval_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PDD_pushbutton.
function PDD_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PDD_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function calfile1_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to calfile1_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of calfile1_popupmenu as text
%        str2double(get(hObject,'String')) returns contents of calfile1_popupmenu as a double


% --- Executes during object creation, after setting all properties.
function calfile1_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to calfile1_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function calfile2_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to calfile2_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of calfile2_popupmenu as text
%        str2double(get(hObject,'String')) returns contents of calfile2_popupmenu as a double


% --- Executes during object creation, after setting all properties.
function calfile2_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to calfile2_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calfile1_pushbutton.
function calfile1_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to calfile1_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in calfile2_pushbutton.
function calfile2_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to calfile2_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function fieldsize_edit_Callback(hObject, eventdata, handles)
% hObject    handle to fieldsize_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fieldsize_edit as text
%        str2double(get(hObject,'String')) returns contents of fieldsize_edit as a double


% --- Executes during object creation, after setting all properties.
function fieldsize_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fieldsize_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in epidfiletype_popupmenu.
function epidfiletype_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to epidfiletype_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns epidfiletype_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from epidfiletype_popupmenu
UpdateEPIDList(handles);

% --- Executes during object creation, after setting all properties.
function epidfiletype_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epidfiletype_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tpsfiletype_popupmenu.
function tpsfiletype_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to tpsfiletype_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tpsfiletype_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tpsfiletype_popupmenu
UpdateTPSList(handles);

% --- Executes during object creation, after setting all properties.
function tpsfiletype_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tpsfiletype_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in calfiletype_popupmenu.
function calfiletype_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to calfiletype_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns calfiletype_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from calfiletype_popupmenu
UpdateCalibrationList(handles);

% --- Executes during object creation, after setting all properties.
function calfiletype_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to calfiletype_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Data_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Data_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
% Set the new directory for Epid calibration images
function caldir_menu_Callback(hObject, eventdata, handles)
% hObject    handle to caldir_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currentdir = getappdata(hObject,'currentdir');
[newdir] = uigetdir(currentdir,'Select calibration image directory');
if isequal(newdir,0)
    % Cancelled
    return;
end
setappdata(hObject,'currentdir',newdir);
AddParameter(newdir,'CALDIR');
UpdateCalibrationList(handles);


% --------------------------------------------------------------------
% Set the new directory for TPS dose planes
function tpsdir_menu_Callback(hObject, eventdata, handles)
% hObject    handle to tpsdir_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currentdir = getappdata(hObject,'currentdir');
[newdir] = uigetdir(currentdir,'Select TPS dose plane directory');
if isequal(newdir,0)
    % Cancelled
    return;
end
setappdata(hObject,'currentdir',newdir);
AddParameter(newdir,'TPSDIR');
UpdateTPSList(handles);

% --------------------------------------------------------------------
function mapcheckdir_menu_Callback(hObject, eventdata, handles)
% hObject    handle to mapcheckdir_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currentdir = getappdata(hObject,'currentdir');
[newdir] = uigetdir(currentdir,'Select MapCheck data directory');
if isequal(newdir,0)
    % Cancelled
    return;
end
setappdata(hObject,'currentdir',newdir);
AddParameter(newdir,'MAPCHECKDIR');
UpdateMapCheckList(handles);
% --------------------------------------------------------------------
% Set the new directory for Epid Images
function epiddir_menu_Callback(hObject, eventdata, handles)
% hObject    handle to epiddir_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currentdir = getappdata(hObject,'currentdir');
[newdir] = uigetdir(currentdir,'Select Epid image directory');
if isequal(newdir,0)
    % Cancelled
    return;
end
setappdata(hObject,'currentdir',newdir);
AddParameter(newdir,'EPIDDIR');
UpdateEPIDList(handles);

% --------------------------------------------------------------------
% View and/or modify the percent-depth-dose data
function pdd_menu_Callback(hObject, eventdata, handles)
% hObject    handle to pdd_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get the PDD data
PDD_raw = getappdata(handles.pdd_menu,'pdd');
fsize = (PDD_raw(1,2:end))';
fsize_str = cell(size(fsize));
for i=1:numel(fsize)
    fsize_str{i} = [num2str(fsize(i)) ' cm'];
end
depth = PDD_raw(2:end,1);
pdd = PDD_raw(2:end,2:end);
[newPDD newfsize_str newdepth] = DataExplorer(pdd,depth,fsize, ...
    'Title','Percent-Depth-Dose Data','OrdinateLabel','Depth (cm)', ...
    'AbscissaPrefix','','AbscissaSuffix',' (cm)');
if isempty(newPDD)
    % Operation cancelled. Do not update
    return;
end

% --------------------------------------------------------------------
% View / modify the machine calibration parameters
function machinecal_menu_Callback(hObject, eventdata, handles)
% hObject    handle to machinecal_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get current machine calibration parameters
mucal = getappdata(hObject,'mucal');    % 1 MU = mucal cGy
fsize = getappdata(hObject,'fsize');    % field size (cm) for calibration
ssd = getappdata(hObject,'ssd');        % SSD (cm) for calibration
depth = getappdata(hObject,'depth') ;    % depth (cm) for calibration

dlgprompt = {'1 MU  = ? cGy';'Calibration field size (cm)'; ...
    'Calibration SSD (cm)'; 'Calibration depth (cm)'};
currentparams = cellstr(num2str([mucal; fsize; ssd; depth]));
validparams = false;

while ~validparams
    userans = inputdlg(dlgprompt,'Machine Calibration Parameters',1,currentparams);
    if isempty(userans)
        % Cancelled
        return;
    end

    newmucal = str2double(userans{1});
    newfsize = str2double(userans{2});
    newssd = str2double(userans{3});
    newdepth = str2double(userans{4});
    newparams = [newmucal;newfsize;newssd;newdepth];
    if any(isnan(newparams))
        validparams = false;
    else
        validparams = true;
    end
end

if newmucal ~= mucal
    % Upate MU calibration
    setappdata(hObject,'mucal',newmucal);
    AddParameter(newmucal,'MUCAL');
end
if str2double(userans{2}) ~= fsize
    % Update field size calibration
    setappdata(hObject,'fsize',newfsize);
    AddParameter(newfsize,'FSIZECAL');
end
if str2double(userans{3}) ~= ssd
    % Update ssd calibration
    setappdata(hObject,'ssd',newssd);
    AddParameter(newssd,'SSDCAL');
end
if str2double(userans{4}) ~= depth
    % Update depth calibration
    setappdata(hObject,'depth',newdepth);
    AddParameter(newdepth,'DEPTHCAL');
end

% Update list of files available in selection boxes to match those
% available in the specified directory (calibration files)
function UpdateCalibrationList(handles)
% Get the current calibration directory
caldir = getappdata(handles.caldir_menu,'currentdir');
% Get the specified file type
ftypelist = get(handles.calfiletype_popupmenu,'String');
ftypeindex = get(handles.calfiletype_popupmenu,'Value');
ftypestr = ftypelist{ftypeindex};

% Get the list of files in the specified directory of the specified file
% type
filestring = fullfile(caldir,['*.' ftypestr]);
dirlist = dir(filestring);
nlist = numel(dirlist);
% Remove subdirectories from the listing
flistcell = {};
for i=1:nlist
    [~, fname] = fileparts(dirlist(i).name);
    if ~dirlist(i).isdir
        flistcell = [flistcell; fname];
    end
end
if isempty(flistcell)
   flistcell = cellstr(''); 
end

% Populate the selection boxes with the remaining files
set(handles.calfile1_popupmenu,'String',flistcell);
set(handles.calfile2_popupmenu,'String',flistcell);
set(handles.calfile1_popupmenu,'Value',1);
set(handles.calfile2_popupmenu,'Value',1);

% Update list of files available in selection boxes to match those
% available in the specified directory (TPS files)
function UpdateTPSList(handles)
% Get the current calibration directory
tpsdir = getappdata(handles.tpsdir_menu,'currentdir');
% Get the specified file type
ftypelist = get(handles.tpsfiletype_popupmenu,'String');
ftypeindex = get(handles.tpsfiletype_popupmenu,'Value');
ftypestr = ftypelist{ftypeindex};

% Get the list of files in the specified directory of the specified file
% type
filestring = fullfile(tpsdir,['*.' ftypestr]);
dirlist = dir(filestring);
nlist = numel(dirlist);
% Remove subdirectories from the listing
flistcell = {};
for i=1:nlist
    [~, fname] = fileparts(dirlist(i).name);
    if ~dirlist(i).isdir
        flistcell = [flistcell; fname];
    end
end
if isempty(flistcell)
   flistcell = cellstr(''); 
end

% Populate the selection boxes with the remaining files
set(handles.tpsfile_popupmenu,'String',flistcell);
set(handles.tpsfile_popupmenu,'Value',1);

% Update list of files available in selection boxes to match those
% available in the specified directory (MapCheck files)
function UpdateMapCheckList(handles)
% Get the current calibration directory
mapcheckdir = getappdata(handles.mapcheckdir_menu,'currentdir');
% Get the specified file type
ftypelist = get(handles.mapcheckfiletype_popupmenu,'String');
ftypeindex = get(handles.mapcheckfiletype_popupmenu,'Value');
ftypestr = ftypelist{ftypeindex};

% Get the list of files in the specified directory of the specified file
% type
filestring = fullfile(mapcheckdir,['*.' ftypestr]);
dirlist = dir(filestring);
nlist = numel(dirlist);
% Remove subdirectories from the listing
flistcell = {};
for i=1:nlist
    [~, fname] = fileparts(dirlist(i).name);
    if ~dirlist(i).isdir
        flistcell = [flistcell; fname];
    end
end
if isempty(flistcell)
   flistcell = cellstr(''); 
end

% Populate the selection boxes with the remaining files
set(handles.mapcheckfile_popupmenu,'String',flistcell);
set(handles.mapcheckfile_popupmenu,'Value',1);

% Update list of files available in selection boxes to match those
% available in the specified directory (Epid image files)
function UpdateEPIDList(handles)
% Get the current calibration directory
epiddir = getappdata(handles.epiddir_menu,'currentdir');
% Get the specified file type
ftypelist = get(handles.epidfiletype_popupmenu,'String');
ftypeindex = get(handles.epidfiletype_popupmenu,'Value');
ftypestr = ftypelist{ftypeindex};

% Get the list of files in the specified directory of the specified file
% type
filestring = fullfile(epiddir,['*.' ftypestr]);
dirlist = dir(filestring);
nlist = numel(dirlist);
% Remove subdirectories from the listing
flistcell = {};
for i=1:nlist
    [~, fname] = fileparts(dirlist(i).name);
    if ~dirlist(i).isdir
        flistcell = [flistcell; fname];
    end
end
if isempty(flistcell)
   flistcell = cellstr(''); 
end

% Populate the selection boxes with the remaining files
set(handles.epidimage_popupmenu,'String',flistcell);
set(handles.epidimage_popupmenu,'Value',1);


function calmu_edit_Callback(hObject, eventdata, handles)
% hObject    handle to calmu_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of calmu_edit as text
%        str2double(get(hObject,'String')) returns contents of calmu_edit as a double


% --- Executes during object creation, after setting all properties.
function calmu_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to calmu_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Configure GUI for eclipse mode
function seteclipsemode(handles)
set(allchild(handles.mapcheck_panel),'enable','off');
set(allchild(handles.TPS_panel),'enable','on');
set(allchild(handles.epid_panel),'enable','on');
set(allchild(handles.calibration_panel),'enable','on');
set(handles.eclipsemode_menu,'Checked','on');
set(handles.mapcheckmode_menu,'Checked','off');
set(handles.mctpsmode_menu,'Checked','off');

% Configure GUI for mapcheck mode
function setmapcheckmode(handles)
set(allchild(handles.mapcheck_panel),'enable','on');
set(allchild(handles.TPS_panel),'enable','off');
set(allchild(handles.epid_panel),'enable','on');
set(allchild(handles.calibration_panel),'enable','on');
set(handles.eclipsemode_menu,'Checked','off');
set(handles.mapcheckmode_menu,'Checked','on');
set(handles.mctpsmode_menu,'Checked','off');

function setmctpsmode(handles)
set(allchild(handles.mapcheck_panel),'enable','on');
set(allchild(handles.TPS_panel),'enable','on');
set(allchild(handles.epid_panel),'enable','off');
set(allchild(handles.calibration_panel),'enable','off');
set(handles.eclipsemode_menu,'Checked','off');
set(handles.mapcheckmode_menu,'Checked','off');
set(handles.mctpsmode_menu,'Checked','on');


% --- Executes on selection change in mapcheckfile_popupmenu.
function mapcheckfile_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to mapcheckfile_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mapcheckfile_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mapcheckfile_popupmenu


% --- Executes during object creation, after setting all properties.
function mapcheckfile_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mapcheckfile_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mapcheckssd_edit_Callback(hObject, eventdata, handles)
% hObject    handle to mapcheckssd_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mapcheckssd_edit as text
%        str2double(get(hObject,'String')) returns contents of mapcheckssd_edit as a double


% --- Executes during object creation, after setting all properties.
function mapcheckssd_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mapcheckssd_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mapcheckdepth_edit_Callback(hObject, eventdata, handles)
% hObject    handle to mapcheckdepth_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mapcheckdepth_edit as text
%        str2double(get(hObject,'String')) returns contents of mapcheckdepth_edit as a double


% --- Executes during object creation, after setting all properties.
function mapcheckdepth_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mapcheckdepth_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in mapcheckfiletype_popupmenu.
function mapcheckfiletype_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to mapcheckfiletype_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mapcheckfiletype_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mapcheckfiletype_popupmenu


% --- Executes during object creation, after setting all properties.
function mapcheckfiletype_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mapcheckfiletype_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function mode_menu_Callback(hObject, eventdata, handles)
% hObject    handle to mode_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function eclipsemode_menu_Callback(hObject, eventdata, handles)
% hObject    handle to eclipsemode_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
seteclipsemode(handles);

% --------------------------------------------------------------------
function mapcheckmode_menu_Callback(hObject, eventdata, handles)
% hObject    handle to mapcheckmode_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setmapcheckmode(handles)



function mapchecknewdepth_edit_Callback(hObject, eventdata, handles)
% hObject    handle to mapchecknewdepth_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mapchecknewdepth_edit as text
%        str2double(get(hObject,'String')) returns contents of mapchecknewdepth_edit as a double


% --- Executes during object creation, after setting all properties.
function mapchecknewdepth_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mapchecknewdepth_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function mctpsmode_menu_Callback(hObject, eventdata, handles)
% hObject    handle to mctpsmode_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setmctpsmode(handles);
