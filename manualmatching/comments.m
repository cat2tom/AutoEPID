function varargout = comments(varargin)
% COMMENTS MATLAB code for comments.fig
%      COMMENTS, by itself, creates a new COMMENTS or raises the existing
%      singleton*.
%
%      H = COMMENTS returns the handle to a new COMMENTS or the handle to
%      the existing singleton*.
%
%      COMMENTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMMENTS.M with the given input arguments.
%
%      COMMENTS('Property','Value',...) creates a new COMMENTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before comments_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to comments_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help comments

% Last Modified by GUIDE v2.5 29-Oct-2018 12:57:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @comments_OpeningFcn, ...
                   'gui_OutputFcn',  @comments_OutputFcn, ...
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


% --- Executes just before comments is made visible.
function comments_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to comments (see VARARGIN)

% Choose default command line output for comments
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes comments wait for user response (see UIRESUME)
% uiwait(handles.comment_window);


% --- Outputs from this function are returned to the command line.
function varargout = comments_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function comment_box_Callback(hObject, eventdata, handles)
% hObject    handle to comment_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of comment_box as text
%        str2double(get(hObject,'String')) returns contents of comment_box as a double


% --- Executes during object creation, after setting all properties.
function comment_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comment_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in comment_button.
function comment_button_Callback(hObject, eventdata, handles)
% hObject    handle to comment_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

comments=get(handles.comment_box,'string');

setappdata(0,'report_comments',comments);

% close the figure

try
    
    % Close figure or leave it open
    close(handles.comment_window)
   
catch
    disp('comment_window closed')
end
