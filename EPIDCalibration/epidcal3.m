function varargout = epidcal3(varargin)
% EPIDCAL3 MATLAB code for epidcal3.fig
%      EPIDCAL3, by itself, creates a new EPIDCAL3 or raises the existing
%      singleton*.
%
%      H = EPIDCAL3 returns the handle to a new EPIDCAL3 or the handle to
%      the existing singleton*.
%
%      EPIDCAL3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EPIDCAL3.M with the given input arguments.
%
%      EPIDCAL3('Property','Value',...) creates a new EPIDCAL3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before epidcal3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to epidcal3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help epidcal3

% Last Modified by GUIDE v2.5 22-Mar-2018 14:01:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @epidcal3_OpeningFcn, ...
                   'gui_OutputFcn',  @epidcal3_OutputFcn, ...
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


% --- Executes just before epidcal3 is made visible.
function epidcal3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to epidcal3 (see VARARGIN)

% Choose default command line output for epidcal3


handles.output = hObject;

% set the physicsit list at start.

physicist={' ','AW','RS','RG','JB','GG','PV','SA','AX','MJ','SD','JH','DT','TY','SR','VN','TE','AG','BB'};

set(handles.physicist_list,'String',physicist);

% set the default output dir

% set(handles.output_dir,'String','H:\IMRT\PatientQA\AUTOEPIDRESOURCE');

set(handles.output_dir,'String','H:\IMRT\PatientQA\AUTOEPIDRESOURCE');



% set the default dose

set(handles.machine_list,'selectedObject','');

% set beam type to none

set(handles.fff,'value',0);

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

% UIWAIT makes epidcal3 wait for user response (see UIRESUME)
% uiwait(handles.epid_cal);


% --- Outputs from this function are returned to the command line.
function varargout = epidcal3_OutputFcn(hObject, eventdata, handles) 
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

set(handles.epid_cal_file,'string',tmp_file_name);

handles.epid_dir=pathname;
guidata(hObject,handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

output_folder = uigetdir('H:\IMRT\PatientQA\AUTOEPIDRESOURCE','Please select output folder for calibration file');

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

% get beam_type

beam_type_tmp=handles.beam_type;


% get machine name
machine=handles.machine;

ref_mu=str2double(get(handles.MU,'String'));

dose=str2double(get(handles.dose,'String'));

epid_image_file=handles.epid_image_file;

output_dir=get(handles.output_dir,'string');

% get message box pop up if no physicist selectecd.

if ~isfield(handles,'physicist')
    
    msgbox('Please select a physicist');
    
end 

physicist=handles.physicist;

epid_dir=handles.epid_dir;

cal_file_name='';

switch machine
    
    case {'M1','M2','M4','M5','M7'}
        
        [file,path]=uigetfile('.LOG','Please select log file',epid_dir);
        
        dir_log_file_name=fullfile(path,file);
        
    
        
        cal_S = EPIDCalibration_Callback_Elekta(machine,ref_mu,dose,epid_image_file, dir_log_file_name, output_dir,physicist);
        
        if strcmp(beam_type_tmp,'fff')
            
           cal_file_name  = writeEPIDCalFactorFFF(output_dir,machine,beam_type_tmp,cal_S);
            
        end 
        
        if strcmp(beam_type_tmp,'none_fff')
            
           cal_file_name  = writeEPIDCalFactor(output_dir,machine,cal_S);
            
        end 
        
%         cal_file_name  = writeEPIDCalFactor(output_dir,machine,cal_S)
        
      
        
    case {'M3'}
        
        cal_S = EPIDCalibration_Callback_Siemens(machine,ref_mu,dose,epid_image_file, output_dir,physicist);
        
        cal_file_name  = writeEPIDCalFactor(output_dir,machine,cal_S);
        
          
end 

 tmp10=strcat('Done! saved CF at:   ','     ',cal_file_name);
        
 set(handles.status_bar,'String',tmp10);
 
 %load cal_file and write it to an txt file for QATrack.
 
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

tmp3=get(eventdata.NewValue,'Tag');
handles.machine=tmp3;


guidata(hObject,handles);

tmp2=handles.machine;

% When machine changes, modify the handle variables.
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
        set(handles.dose,'String','93.9')
        
    case 'M7'
        
        set(handles.MU,'String',20);
        set(handles.dose,'String','93.9')
        
end        


% --- Executes on selection change in selected_date_list.
function selected_date_list_Callback(hObject, eventdata, handles)
% hObject    handle to selected_date_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selected_date_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selected_date_list

     % clear status bar.
     set(handles.status_bar,'string','');


     contents = cellstr(get(hObject,'String'));
     
     selected= contents{get(hObject,'Value')};
     
     handles.selected_delete_index=get(hObject,'Value');
     
     guidata(hObject,handles);
     
    
     
     
     % find the index and other parts of contents
     
%      index=length(contents);
     
     tmp2=handles.machine;

    switch tmp2
       
    case 'M1'
        
         % get CF list to cell 
        
         
         tmp=handles.M1_CAL;
       
         index=length(tmp);
          
         
          
          for k=1:length(contents)
         
           tmp1=tmp(k).date;
           
         
            if strcmp(selected,tmp1)
                
                index=k;
            end 
            
          end 
        
         handles.selected_index=index;
         
         handles.selected_cf_item=tmp(index);
         
              
         
                  
         tmp5=handles.selected_cf_item;
         
         set(handles.selected_cf,'string',num2str(tmp5.cal_factor));
         set(handles.selected_physicist,'string',tmp5.physicist);
         
         guidata(hObject,handles);
    %        
    case 'M2'
       
          tmp=handles.M2_CAL;
       
          index=length(tmp);
          
          for k=1:length(contents)
         
           tmp1=tmp(k).date;
           
         
            if strcmp(selected,tmp1)
                
                index=k;
            end 
            
          end 
        
         handles.selected_index=index;
         
         handles.selected_cf_item=tmp(index);
         
         guidata(hObject,handles);
         tmp5=handles.selected_cf_item;
         
         set(handles.selected_cf,'string',num2str(tmp5.cal_factor));
         set(handles.selected_physicist,'string',tmp5.physicist);
         
            
        
        
    case 'M3'
        
          tmp=handles.M3_CAL;
       
          index=length(tmp);
          
          for k=1:length(contents)
         
           tmp1=tmp(k).date;
           
         
            if strcmp(selected,tmp1)
                
                index=k;
            end 
            
          end 
        
         handles.selected_index=index;
         
         handles.selected_cf_item=tmp(index);
         
         guidata(hObject,handles);
         
         tmp5=handles.selected_cf_item;
         
         set(handles.selected_cf,'string',num2str(tmp5.cal_factor));
         set(handles.selected_physicist,'string',tmp5.physicist);
         
         
         
    case 'M4'
        
          tmp=handles.M4_CAL;
       
          index=length(tmp);
          
          for k=1:length(tmp)
         
           tmp1=tmp(k).date;
           
         
            if strcmp(selected,tmp1)
                
                index=k;
            end 
            
          end 
        
         handles.selected_index=index;
         
         handles.selected_cf_item=tmp(index);
         
         guidata(hObject,handles);
         
         tmp5=handles.selected_cf_item;
         
         set(handles.selected_cf,'string',num2str(tmp5.cal_factor));
         set(handles.selected_physicist,'string',tmp5.physicist);
         
         
         
      case 'M5'
         
          tmp=handles.M5_CAL;
       
          index=length(tmp);
          
          for k=1:length(tmp)
         
           tmp1=tmp(k).date;
           
         
            if strcmp(selected,tmp1)
                
                index=k;
            end 
            
          end 
        
         handles.selected_index=index;
         
         handles.selected_cf_item=tmp(index);
         
         guidata(hObject,handles);
         
         tmp5=handles.selected_cf_item;
         
         set(handles.selected_cf,'string',num2str(tmp5.cal_factor));
         set(handles.selected_physicist,'string',tmp5.physicist);
          
     case 'M7'
         
          tmp=handles.M7_CAL;
       
          index=length(tmp);
          
          for k=1:length(tmp)
         
           tmp1=tmp(k).date;
           
         
            if strcmp(selected,tmp1)
                
                index=k;
            end 
            
          end 
        
         handles.selected_index=index;
         
         handles.selected_cf_item=tmp(index);
         
         guidata(hObject,handles);
         
         tmp7=handles.selected_cf_item;
         
         set(handles.selected_cf,'string',num2str(tmp7.cal_factor));
         set(handles.selected_physicist,'string',tmp7.physicist);       
         
        
          
   end        
   
   
    
     
    

% --- Executes during object creation, after setting all properties.
function selected_date_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selected_date_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function selected_cf_Callback(hObject, eventdata, handles)
% hObject    handle to selected_cf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of selected_cf as text
%        str2double(get(hObject,'String')) returns contents of selected_cf as a double


% --- Executes during object creation, after setting all properties.
function selected_cf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selected_cf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function selected_physicist_Callback(hObject, eventdata, handles)
% hObject    handle to selected_physicist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of selected_physicist as text
%        str2double(get(hObject,'String')) returns contents of selected_physicist as a double


% --- Executes during object creation, after setting all properties.
function selected_physicist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selected_physicist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% button for select default CF.


tmp_machine=handles.machine;
output_dir=get(handles.output_dir,'string');


switch tmp_machine
    
    case 'M1'
        
           
        last_calS=handles.selected_cf_item;
                    
        cal_file_name  = writeEPIDCalFactor(output_dir,tmp_machine,last_calS);
        
        set(handles.status_bar,'string','The CF you selected was set default CF');
        
    case 'M2'
        
       
        
        last_calS=handles.selected_cf_item;
                    
        cal_file_name  = writeEPIDCalFactor(output_dir,tmp_machine,last_calS);
        
               
        set(handles.status_bar,'string','The CF you selected was set default CF');
              
        
    case 'M3'
        
               
        last_calS=handles.selected_cf_item;
                    
        cal_file_name  = writeEPIDCalFactor(output_dir,tmp_machine,last_calS);
        
        
        set(handles.status_bar,'string','The CF you selected was set default CF');
              
    case 'M4'
        
        
       last_calS=handles.selected_cf_item;
                    
       cal_file_name  = writeEPIDCalFactor(output_dir,tmp_machine,last_calS);
        
       set(handles.status_bar,'string','The CF you selected was set default CF');
       
    case 'M5'
        
        
       last_calS=handles.selected_cf_item;
                    
       cal_file_name  = writeEPIDCalFactor(output_dir,tmp_machine,last_calS);
        
       set(handles.status_bar,'string','The CF you selected was set default CF');
              
             
        
end 
    
    


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.epid_cal);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path]=uigetfile('H:\IMRT\PatientQA\AUTOEPIDRESOURCE','Please select the file you want to inspect');

% [file,path]=uigetfile('C:\aitangResearch\AutoEPID_developement\EPIDCalibration','Please select the file you want to inspect');


cal_file=fullfile(path,file);

handles.selected_cal_file=cal_file;

guidata(hObject,handles);


if ~(cal_file==0)
    
   handles.selected_cal_file=cal_file;
   
   guidata(hObject,handles);
   
   
   load(cal_file);
   
   
   handles.M1_CAL=M1_CAL;
   
   handles.M2_CAL=M2_CAL;
   
   handles.M3_CAL=M3_CAL;
   
   handles.M4_CAL=M4_CAL;
   
   handles.M5_CAL=M5_CAL;
   
   handles.M7_CAL=M7_CAL;
   
   guidata(hObject,handles);
   % get 
   tmp2=handles.machine;

   switch tmp2
    case 'M1'
        
         % get CF list to cell 
        
         
        tmp=M1_CAL;
        cf_list={};
        for k=1:length(tmp)
            
           cf_list{k}=tmp(k).date ;
            
        end 
        
        % convert struct to 2d cell array
        table_data={};
         for k=1:length(tmp)
            
           table_data{k,1}=tmp(k).machine_name ;
           
           table_data{k,2}=tmp(k).cal_factor;
           
           table_data{k,3}=tmp(k).date ;
            
           table_data{k,4}=tmp(k).cal_file ;
           
           table_data{k,5}=tmp(k).physicist ;
           
        end 
        
        
        % set the table value 
        
        
        
        set(handles.cal_factor_table,'data',table_data);
        
        
        % 
         set(handles.selected_date_list,'String',cf_list);
%         
%         index=get(handles.selected_date_list,'value');
%         
%         contents=get(handles.selected_date_list,'string')
%         
%         selected=_
        
        
%         set(handles.selected_cf,'String',num2str(tmp.cal_factor));
%         
%         set(handles.selected_physicist,'String',tmp.physicist);
%        
    case 'M2'
        tmp=M2_CAL;
        cf_list={};
        for k=1:length(tmp)
            
           cf_list{k}=tmp(k).date ;
            
        end 
        
        
        set(handles.selected_date_list,'String',cf_list);
        
        
         % convert struct to 2d cell array
        table_data={};
         for k=1:length(tmp)
            
           table_data{k,1}=tmp(k).machine_name ;
           
           table_data{k,2}=tmp(k).cal_factor;
           
           table_data{k,3}=tmp(k).date ;
            
           table_data{k,4}=tmp(k).cal_file ;
           
           table_data{k,5}=tmp(k).physicist ;
           
        end 
        
         set(handles.cal_factor_table,'data',table_data);
        
        
        
%         set(handles.selected_cf,'String',num2str(tmp.cal_factor));
%         
%         set(handles.selected_physicist,'String',tmp.physicist);
    case 'M3'
        tmp=M3_CAL;
        cf_list={};
        for k=1:length(tmp)
            
           cf_list{k}=tmp(k).date ;
            
        end 
        
        
        set(handles.selected_date_list,'String',cf_list);
        
        
        
         % convert struct to 2d cell array
        table_data={};
         for k=1:length(tmp)
            
           table_data{k,1}=tmp(k).machine_name ;
           
           table_data{k,2}=tmp(k).cal_factor;
           
           table_data{k,3}=tmp(k).date ;
            
           table_data{k,4}=tmp(k).cal_file ;
           
           table_data{k,5}=tmp(k).physicist ;
           
        end 
        
        
         set(handles.cal_factor_table,'data',table_data);
        
        
        
        
%         set(handles.selected_cf,'String',num2str(tmp.cal_factor));
%         
%         set(handles.selected_physicist,'String',tmp.physicist);    case 'M4'
    case 'M4'
        tmp=M4_CAL;
        cf_list={};
        for k=1:length(tmp)
            
           cf_list{k}=tmp(k).date ;
            
        end 
        
        
        set(handles.selected_date_list,'String',cf_list);
        
         % convert struct to 2d cell array
        table_data={};
         for k=1:length(tmp)
            
           table_data{k,1}=tmp(k).machine_name ;
           
           table_data{k,2}=tmp(k).cal_factor;
           
           table_data{k,3}=tmp(k).date ;
            
           table_data{k,4}=tmp(k).cal_file ;
           
           table_data{k,5}=tmp(k).physicist ;
           
        end 
        
        
         set(handles.cal_factor_table,'data',table_data);
        
        
%         set(handles.selected_cf,'String',num2str(tmp.cal_factor));
%         
%         set(handles.selected_physicist,'String',tmp.physicist);    case 'M4'

%         
     case 'M5'
         
        tmp=M5_CAL;
        cf_list={};
        for k=1:length(tmp)
            
           cf_list{k}=tmp(k).date ;
            
        end 
        
        
        set(handles.selected_date_list,'String',cf_list);
        
        
         % convert struct to 2d cell array
        table_data={};
         for k=1:length(tmp)
            
           table_data{k,1}=tmp(k).machine_name ;
           
           table_data{k,2}=tmp(k).cal_factor;
           
           table_data{k,3}=tmp(k).date ;
            
           table_data{k,4}=tmp(k).cal_file ;
           
           table_data{k,5}=tmp(k).physicist ;
           
         end 
        
          set(handles.cal_factor_table,'data',table_data);
        
    case 'M7'
         
        tmp=M7_CAL;
        cf_list={};
        for k=1:length(tmp)
            
           cf_list{k}=tmp(k).date ;
            
        end 
        
        
        set(handles.selected_date_list,'String',cf_list);
        
        
         % convert struct to 2d cell array
        table_data={};
         for k=1:length(tmp)
            
           table_data{k,1}=tmp(k).machine_name ;
           
           table_data{k,2}=tmp(k).cal_factor;
           
           table_data{k,3}=tmp(k).date ;
            
           table_data{k,4}=tmp(k).cal_file ;
           
           table_data{k,5}=tmp(k).physicist ;
           
         end  
        
          set(handles.cal_factor_table,'data',table_data);
         
        
   end        
   
   
   
end 
 
 
% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tmp_machine=handles.machine;
index=handles.selected_index;
output_dir=get(handles.output_dir,'string');         

switch tmp_machine
    
    case 'M1'
        
                   
        M1_CAL=handles.M1_CAL;
        
        M1_CAL(index)=[];
        
%         M1_CAL=tmp;
        
        cal_file_name  = writeEPIDCalFactor(output_dir,tmp_machine,M1_CAL);      
        set(handles.status_bar,'string','The CF you selected was deleted');
        
    case 'M2'
        
        tmp=handles.M2_CAL;
        
        tmp(index)=[];
        
        M2_CAL=tmp;
        
        cal_file_name  = writeEPIDCalFactor(output_dir,tmp_machine,M2_CAL);     
        set(handles.status_bar,'string','The CF you selected was deleted');
              
        
    case 'M3'
        
        tmp=handles.M3_CAL;
        
        tmp(index)=[];
        
        M3_CAL=tmp;
        
        cal_file_name  = writeEPIDCalFactor(output_dir,tmp_machine,M3_CAL);      
        set(handles.status_bar,'string','The CF you selected was deleted.');
              
    case 'M4'
        
        tmp=handles.M4_CAL;
        
        tmp(index)=[];
        
        M4_CAL=tmp;
        
        cal_file_name  = writeEPIDCalFactor(output_dir,tmp_machine,M4_CAL);
        set(handles.status_bar,'string','The CF you selected was deleted.');
              
        
end 


% --- Executes on button press in FFF.
function FFF_Callback(hObject, eventdata, handles)
% hObject    handle to FFF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FFF


% --- Executes on button press in None_FFF.
function None_FFF_Callback(hObject, eventdata, handles)
% hObject    handle to None_FFF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of None_FFF


% --- Executes when selected object is changed in uipanel10.
function uipanel10_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel10 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

% get selected beam type

tmp3=get(eventdata.NewValue,'Tag');

switch tmp3
    
    case 'fff'
        
        handles.beam_type='fff';
        
    case 'none_fff'
        
         handles.beam_type='none_fff';
        
end 

guidata(hObject,handles);


% --- Executes on button press in delete_button.
function delete_button_Callback(hObject, eventdata, handles)
% hObject    handle to delete_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% delete button
% get machine 


machine=handles.machine;
output_dir=get(handles.output_dir,'string');

index_array=handles.selected_delete_index;

cal_file_name  = deleteEPIDCalFactor(output_dir,machine,index_array);

set(handles.status_bar,'string','The CF you selected was deleted.');
 



function epid_cal_file_Callback(hObject, eventdata, handles)
% hObject    handle to epid_cal_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epid_cal_file as text
%        str2double(get(hObject,'String')) returns contents of epid_cal_file as a double


% --- Executes during object creation, after setting all properties.
function epid_cal_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epid_cal_file (see GCBO)
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

[file,path]=uigetfile('H:\IMRT\PatientQA\AUTOEPIDRESOURCE','Please select the file you want to inspect');

% [file,path]=uigetfile('C:\aitangResearch\AutoEPID_developement\EPIDCalibration','Please select the file you want to inspect');


cal_file=fullfile(path,file);

handles.selected_cal_file=cal_file;

guidata(hObject,handles);


 tmp10=strcat('Done! sent new Cal factor to QATrack sucessfully.'  );
        
 set(handles.status_bar,'String',tmp10);
 

if ~(cal_file==0)
    
   handles.selected_cal_file=cal_file;
   
   guidata(hObject,handles);
   
   
   load(cal_file);
   
   
   handles.M1_CAL=M1_CAL;
   
   handles.M2_CAL=M2_CAL;
   
   handles.M3_CAL=M3_CAL;
   
   handles.M4_CAL=M4_CAL;
   
   handles.M5_CAL=M5_CAL;
   
   handles.M7_CAL=M7_CAL;
   
   guidata(hObject,handles);
   % get 
   tmp2=handles.machine;

   switch tmp2
    case 'M1'
        
         % get CF list to cell 
        
         
        tmp=M1_CAL;
             
        % convert struct to 2d cell array
        table_data={};
         for k=1:length(tmp)
            
           table_data{k,1}=tmp(k).machine_name ;
           
           table_data{k,2}=tmp(k).cal_factor;
           
           table_data{k,3}=tmp(k).date ;
            
           table_data{k,4}=tmp(k).cal_file ;
           
           table_data{k,5}=tmp(k).physicist ;
           
        end 
        
        
       % write to QATrackfile
       
       writeCalFactorTxt( 'M1_Cal.txt',table_data)
        
       set(handles.status_bar,'String',tmp10);
              
        
  
    case 'M2'
        tmp=M2_CAL;
       
        
         % convert struct to 2d cell array
        table_data={};
         for k=1:length(tmp)
            
           table_data{k,1}=tmp(k).machine_name ;
           
           table_data{k,2}=tmp(k).cal_factor;
           
           table_data{k,3}=tmp(k).date ;
            
           table_data{k,4}=tmp(k).cal_file ;
           
           table_data{k,5}=tmp(k).physicist ;
           
        end 
        
           writeCalFactorTxt( 'M2_Cal.txt',table_data)
           set(handles.status_bar,'String',tmp10);
           
    case 'M3'
        tmp=M3_CAL;
       
        
         % convert struct to 2d cell array
        table_data={};
         for k=1:length(tmp)
            
           table_data{k,1}=tmp(k).machine_name ;
           
           table_data{k,2}=tmp(k).cal_factor;
           
           table_data{k,3}=tmp(k).date ;
            
           table_data{k,4}=tmp(k).cal_file ;
           
           table_data{k,5}=tmp(k).physicist ;
           
        end 
        
         % write to QATrackfile
       
       writeCalFactorTxt( 'M3_Cal.txt',table_data)
       set(handles.status_bar,'String',tmp10);
         
    case 'M4'
        tmp=M4_CAL;
       
        
              
         % convert struct to 2d cell array
        table_data={};
         for k=1:length(tmp)
            
           table_data{k,1}=tmp(k).machine_name ;
           
           table_data{k,2}=tmp(k).cal_factor;
           
           table_data{k,3}=tmp(k).date ;
            
           table_data{k,4}=tmp(k).cal_file ;
           
           table_data{k,5}=tmp(k).physicist ;
           
         end 
        
        
     % write to QATrackfile
       
       writeCalFactorTxt( 'M4_Cal.txt',table_data)
       
       set(handles.status_bar,'String',tmp10);

%         
     case 'M5'
         
        tmp=M5_CAL;
       
     
         % convert struct to 2d cell array
        table_data={};
         for k=1:length(tmp)
            
           table_data{k,1}=tmp(k).machine_name ;
           
           table_data{k,2}=tmp(k).cal_factor;
           
           table_data{k,3}=tmp(k).date ;
            
           table_data{k,4}=tmp(k).cal_file ;
           
           table_data{k,5}=tmp(k).physicist ;
           
         end 
        
          % write to QATrackfile
       
       writeCalFactorTxt( 'M5_Cal.txt',table_data)
       
       set(handles.status_bar,'String',tmp10);
        
    case 'M7'
         
        tmp=M7_CAL;
      
        
             
        % convert struct to 2d cell array
        table_data={};
         for k=1:length(tmp)
            
           table_data{k,1}=tmp(k).machine_name ;
           
           table_data{k,2}=tmp(k).cal_factor;
           
           table_data{k,3}=tmp(k).date ;
            
           table_data{k,4}=tmp(k).cal_file ;
           
           table_data{k,5}=tmp(k).physicist ;
           
         end  
        
           % write to QATrackfile
       
       writeCalFactorTxt( 'M7_Cal.txt',table_data)
       
       set(handles.status_bar,'String',tmp10);
        
   end
   
end


   
