function varargout = ManualMatching3(varargin)
% MANUALMATCHING3 MATLAB code for ManualMatching3.fig
%      MANUALMATCHING3, by itself, creates a new MANUALMATCHING3 or raises the existing
%      singleton*.
%
%      H = MANUALMATCHING3 returns the handle to a new MANUALMATCHING3 or the handle to
%      the existing singleton*.
%
%      MANUALMATCHING3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANUALMATCHING3.M with the given input arguments.
%
%      MANUALMATCHING3('Property','Value',...) creates a new MANUALMATCHING3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ManualMatching3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ManualMatching3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ManualMatching3

% Last Modified by GUIDE v2.5 08-May-2017 09:39:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ManualMatching3_OpeningFcn, ...
                   'gui_OutputFcn',  @ManualMatching3_OutputFcn, ...
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


% --- Executes just before ManualMatching3 is made visible.
function ManualMatching3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ManualMatching3 (see VARARGIN)

handles.output_option=getappdata(0,'output_option');

handles.which_machine=getappdata(0,'which_machine');

handles.treatment_type=getappdata(0,'treatment_type');



handles.which_tps=getappdata(0,'which_tps');

guidata(hObject,handles);

handles.default_cf=getappdata(0,'default_cf');

% set the default patient directory


patient_dir=getappdata(0,'patient_dir');

set(handles.patient_folder,'String',patient_dir);

handles.patient_dir=patient_dir;


% get vmat output dir

vmat_output_dir=getappdata(0,'vmat_output_dir');

handles.vmat_output_dir=vmat_output_dir;


handles.escan_dir=getappdata(0,'escan_dir');

guidata(hObject,handles);



% set default TPS folder

default_tps_dir=fullfile(patient_dir,'TPS');

if isdir(default_tps_dir)

  set(handles.tps_default_dir,'String',default_tps_dir);
  
else
    
  set(handles.tps_default_dir,'String',{'Please use the browser button to chose TPS folder'});
    
end 

% set the list of tps files.

tps_dir=get(handles.tps_default_dir,'String');

if isdir(tps_dir)

[dir_path, ext_cell]=getTPSFileExtCell(tps_dir);

if length(ext_cell)<1
    
    return 
    
end 

set(handles.tps_list_box,'string',ext_cell);

else
    
  set(handles.tps_list_box,'string',{'No TPS files found and Please select an TPS folder'});
   
    
end     






% set(handles.tps_default_dir,'String','C:\aitangResearch\AutoEPID_developement\manualmatching\tps');

% set default EPID folder

default_epid_dir=fullfile(handles.patient_dir,'EPID');

if isdir(default_epid_dir)


   set(handles.epid_default_dir,'String',default_epid_dir);
   
else
    
    
   set(handles.epid_default_dir,'String','Please chose EPID folder');
     
    
end

% pop up the patient list
epid_dir=get(handles.epid_default_dir,'String');
if isdir(epid_dir)
    
[dir_path, ext_cell]=getEPIDFileExtCell(epid_dir);

if length(ext_cell)<1
    
    return 
    
end 

set(handles.epid_list_box,'string',ext_cell);

else
    
  set(handles.epid_list_box,'string',{'No EPID files found and Please select an EPID folder'});
  
    
end 



% grab the application data and set them up as hanldes.

handles.selected_physicist=getappdata(0,'physicist');

handles.patient_list_dir=getappdata(0,'patient_list_dir');

handles.output_dir=getappdata(0,'output_dir');

handles.dicom_template_dir=getappdata(0,'dicom_template_dir');

handles.which_tps=getappdata(0,'which_tps');

handles.patient_name=patient_dir;

% grab application data for calibration factor and date

handles.pdf_cal=getappdata(0,'pdf_cal');

handles.pdf_cal_date=getappdata(0,'pdf_cal_date');


% Choose default command line output for ManualMatching3
handles.output = hObject;

% get version info from appdata for pdf report


handles.version_info=getappdata(0,'version_info');




% Update handles structure
guidata(hObject, handles);




% UIWAIT makes ManualMatching3 wait for user response (see UIRESUME)
% uiwait(handles.manual_figure);


% --- Outputs from this function are returned to the command line.
function varargout = ManualMatching3_OutputFcn(hObject, eventdata, handles) 
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

tps_dir=get(handles.tps_default_dir,'String');

if isdir(tps_dir)

[dir_path, ext_cell]=getTPSFileExtCell(tps_dir);

if length(ext_cell)<1
    
    return 
    
end 
set(hObject,'string',ext_cell);

contents = get(hObject,'String');

selected_file=contents{get(hObject,'Value')};

full_file=fullfile(dir_path,selected_file);

[xgrid,ygrid, dose_plane2]=readPinnacleDose4(full_file,1);

dose_plane2=flipud(dose_plane2);

dose_plane2=fliplr(dose_plane2);

colormap(gray)

axes(handles.tps_image);
imagesc(dose_plane2)
colormap(gray)
else
    
    return
end 



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

epid_dir=get(handles.epid_default_dir,'String');


if isdir(epid_dir)
    
[dir_path, ext_cell]=getEPIDFileExtCell(epid_dir);

if length(ext_cell)<1
    
    return 
    
end 

handles.which_machine

set(hObject,'string',ext_cell);

contents = get(hObject,'String');
selected_file=contents{get(hObject,'Value')};

full_file=fullfile(dir_path,selected_file);

if strcmp(handles.which_machine,'M2')||strcmp(handles.which_machine,'M1')||strcmp(handles.which_machine,'M4')||strcmp(handles.which_machine,'M5') ...
   || strcmp(handles.which_machine,'M7')|| strcmp(handles.which_machine,'M3')

im = readHISfile(full_file);

% [xgrid,ygrid, dose_plane2]=readPinnacleDose4(full_file,1);
colormap(gray)

axes(handles.epid_image);
imagesc(im)
colormap(gray)

end 


% if strcmp(handles.which_machine,'M33')
% 
% im = readSiemensEPID(full_file,1);
% 
% % [xgrid,ygrid, dose_plane2]=readPinnacleDose4(full_file,1);
% colormap(gray)
% 
% axes(handles.epid_image);
% imagesc(im)
% colormap(gray)
% 
% end

else
    
    return
end 

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


tps_file_list=cellstr(get(handles.epid_list_box,'String'));

selected_epid_file=tps_file_list{get(handles.epid_list_box,'Value')}


matched_epid_list=cellstr(get(handles.matched_epid_list,'String'))


if isempty(matched_epid_list)
    
    matched_epid_list{1}=selected_epid_file;
    
else
    
    tmp=length(matched_epid_list);
    matched_epid_list{tmp+1}=selected_epid_file;
    
end 

if isempty(matched_epid_list{1})
    
    matched_epid_list(1)=[];
    
end 


set(handles.matched_epid_list,'String',matched_epid_list);


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





% get the mached epid_file_list

tps_file_name=get(handles.matched_tps_list,'String');

matched_tps_file_list={};


tps_dir=get(handles.tps_default_dir,'String');

if ~isempty(tps_file_name)
   for k=1:length(tps_file_name)
       
       
      matched_tps_file_list{k}=fullfile(tps_dir,tps_file_name{k});
             
   end
   
   handles.matched_tps_file_list=matched_tps_file_list;
   
   guidata(hObject,handles);
   
end 



epid_file_name=get(handles.matched_epid_list,'String');

matched_epid_file_list={};


epid_dir=get(handles.epid_default_dir,'String');

if ~isempty(epid_file_name)
   for k=1:length(epid_file_name)
             
      
      matched_epid_file_list{k}=fullfile(epid_dir,epid_file_name{k});
            
   end
   
   handles.matched_epid_file_list=matched_epid_file_list;
   
   guidata(hObject,handles);
   
end 

% Mannual_Callback3_CF(hObject,handles);

%% added no registratio for VMAT and IMRT


registrationType=getappdata(0,'registrationType');
 
 if strcmp(registrationType,'Reg')
 
   handles=Mannual_Callback3_CF_PDF(hObject,handles);
   
   disp('Reg');
   
   % copy pdf report here.
   
   isfield(handles,'pdf_report_file_name');
   
  % get comments from comment windows
  
  handles.comments=getappdata(0,'report_comments');
  
 
     
      
  generateAutoEPIDPDFReport(handles);
   
   
   % reset the comments to ''
  
  setappdata(0,'report_comments',' ');
  
   
     
   % copy the pdf report to escan
   
   if isfield(handles,'pdf_report_file_name')
       copyfile(handles.pdf_report_file_name,handles.escan_dir);
       
   end

   % speak out
   
   speakFinished();
   
   % if pdf report file exists, then open it.
   
   pdf_report_file=handles.pdf_report_file_name;
   
   if exist(pdf_report_file,'file')
       
       open(pdf_report_file);
       
  end 
   
   
   
 end % end reg if
 
 
 if strcmp(registrationType,'noReg')
     
    handles=Mannual_Callback3_CF_PDF_noReg(hObject,handles);  
    
    disp('noReg');
    
    
    isfield(handles,'pdf_report_file_name');
    
  % get comments from comment windows
  
  handles.comments=getappdata(0,'report_comments');
  
 
    

  generateAutoEPIDPDFReport(handles);
    
    
   % reset the comments to ''
  
  setappdata(0,'report_comments',' ');
  
 
  
    

% copy the pdf report to escan

if isfield(handles,'pdf_report_file_name')
    
 copyfile(handles.pdf_report_file_name,handles.escan_dir);
 
end 

% speak out

speakFinished();

% if pdf report file exists, then open it.

pdf_report_file=handles.pdf_report_file_name;

if exist(pdf_report_file,'file')
    
    open(pdf_report_file);
    
end 
     
end % end noReg if  






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

tps_file_list=cellstr(get(handles.tps_list_box,'String'));

selected_tps_file=tps_file_list{get(handles.tps_list_box,'Value')}


matched_tps_list=cellstr(get(handles.matched_tps_list,'String'))


if isempty(matched_tps_list)
    
    matched_tps_list{1}=selected_tps_file;
    
else
    
    tmp=length(matched_tps_list)
    matched_tps_list{tmp+1}=selected_tps_file;
    
end 

if isempty(matched_tps_list{1})
    
    matched_tps_list(1)=[];
    
    
end 


set(handles.matched_tps_list,'String',matched_tps_list);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

matched_tps_list=cellstr(get(handles.matched_tps_list,'String'));


selected_index=get(handles.matched_tps_list,'Value');

if length(matched_tps_list)<1
    
return

end 

matched_tps_list(selected_index)=[];

value=selected_index-1;

if value<1
    
    value=1;
    
end 

set(handles.matched_tps_list,'String',matched_tps_list,'Value',value);


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

   
   tps_folder=uigetdir(handles.patient_dir, 'Please Select a TPS sub folder');
   
   if tps_folder==0
       
      set(handles.tps_default_dir,'String','Please choose a TPS folder for this patient'); 
       
   else
       
      set(handles.tps_default_dir,'String',tps_folder); 
      
      guidata(hObject,handles);
      
      tps_dir=get(handles.tps_default_dir,'String');

    if isdir(tps_dir)

    [dir_path, ext_cell]=getTPSFileExtCell(tps_folder);

    if length(ext_cell)<1
    
        
        ext_cell{1}= 'No TPS files found and Please select an TPS folder';
   
        set(handles.tps_list_box,'string',ext_cell);
                           
    else
    
        set(handles.tps_list_box,'string',ext_cell);
        
    end 
    
   
    end
    
    
   end
   
  


function epid_default_dir_Callback(hObject, eventdata, handles)
% hObject    handle to epid_default_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epid_default_dir as text
%        str2double(get(hObject,'String')) returns contents of epid_default_dir as a double


% --- Executes during object creation, after setting all properties.
function epid_default_dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epid_default_dir (see GCBO)
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

% default_epid_dir=fullfile(handles.patient_folder,'EPID');


tmp2=uigetdir(handles.patient_dir,'Please select EPID sub directory');

if tmp2==0
    
     set(handles.epid_default_dir,'String','Please choose an EPID folder for this patient');
   
else

   set(handles.epid_default_dir,'String',tmp2);
   
   tmp3=get(handles.epid_default_dir,'string');
   
   if isdir(tmp3)
       
       [dir_path, ext_cell]=getEPIDFileExtCell(tmp3);

   if length(ext_cell)<1
    
    ext_cell{1}='No EPID files found and Please select an EPID folder';

     set(handles.epid_list_box,'string',ext_cell);

   else
    
      set(handles.epid_list_box,'string',ext_cell);
  
    
    end 
       
       
       
   end
   
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


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

patient_folder=uigetdir(handles.patient_dir, 'Please Select the patient folder')

if patient_folder==0
    
   set(handles.patient_folder,'String','Please chose a patient folder');
    
else
    
   set(handles.patient_folder,'String',patient_folder);
   
   handles.patient_dir=patient_folder;
   
   guidata(hObject,handles);
   
   
   tps_folder1=fullfile(patient_folder,'TPS')
   
   if isdir(tps_folder1)
       
        set(handles.tps_default_dir,'String',tps_folder1); 
   else
        
        set(handles.tps_default_dir,'String','Please select a TPS folder for this patient'); 
        
   end
   
    epid_folder1=fullfile(patient_folder,'EPID')
   
   if isdir(epid_folder1)
       
        set(handles.epid_default_dir,'String',epid_folder1); 
   else
        
        set(handles.epid_default_dir,'String','Please select a TPS folder for this patient'); 
        
   end
   
end

% update EPID and TPS subfolder





% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents=get(handles.matched_tps_list,'String');

contents(:)=[];

set(handles.matched_tps_list,'String',contents);


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

matched_epid_list=cellstr(get(handles.matched_epid_list,'String'));


selected_index=get(handles.matched_epid_list,'Value');

if length(matched_epid_list)<1
    
return

end 

matched_epid_list(selected_index)=[];

value=selected_index-1;

if value<1
    
    value=1;
    
end 

set(handles.matched_epid_list,'String',matched_epid_list,'Value',value);

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents=get(handles.matched_epid_list,'String');

contents(:)=[];

set(handles.matched_epid_list,'String',contents);


function upDateTPSList(handles,tps_dir)


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(handles.manual_figure);


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
