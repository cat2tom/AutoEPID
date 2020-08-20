function varargout = EImage_backup2(varargin)
% EIMAGE_BACKUP2 M-file for EImage_backup2.fig
%      EIMAGE_BACKUP2 produces an extended image window that provides easy-access
%      to some more details image manipulation tools than the standard
%      image function. There is a main image axis, secondary plot axis and
%      a text box that can provide additional information about the image.
%
%      EImage_backup2 processes all of the standard arguments of the Image function
%      and passes them through to plot the specified image in the Extended
%      image. It also recognizes an extra property value pair named 'Mode'
%      which can take the following values:
%           xprofile: show the x profile of the image in the secondary
%           window at startup
%           yprofile: show the y profile of the image in the secondary
%           window at startup
%           summary: show the summary information below the image
%
%      [H1 H2 H3] = EImage_backup2 returns handles to the main window elements for
%      further customization as necessary.
%           H1: handle to the main image axes
%           H2: handle to the secondary plot axes
%           H3: handle to the summary information text box
%
%      EIMAGE_BACKUP2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EIMAGE_BACKUP2.M with the given input arguments.
%
%      EIMAGE_BACKUP2('Property','Value',...) creates a new EIMAGE_BACKUP2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EImage_backup2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EImage_backup2_OpeningFcn via varargin.
%

%
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EImage_backup2

% Last Modified by GUIDE v2.5 27-Apr-2017 16:44:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EImage_backup2_OpeningFcn, ...
                   'gui_OutputFcn',  @EImage_backup2_OutputFcn, ...
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


% --- Executes just before EImage_backup2 is made visible.
function EImage_backup2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EImage_backup2 (see VARARGIN)

% Choose default command line output for EImage_backup2
handles.output = hObject;

p = inputParser;
p.FunctionName = 'Extended Image';
p.KeepUnmatched = true;
checkimage = @(argtocheck) checkarg(argtocheck,'real',NaN,NaN);
checkdimlimits = @(argtocheck) checkarg(argtocheck,'real',1,2);

p.addRequired('image',checkimage);
p.addOptional('xlimits',[],checkdimlimits);
p.addOptional('ylimits',[],checkdimlimits);

p.addParamValue('Mode','image',@ischar);
p.addParamValue('Title','Extended Image Analysis',@ischar);
p.addParamValue('xlabel', '', @ischar);
p.addParamValue('ylabel', '', @ischar);
p.addParamValue('flipyaxis',true,@islogical);

% parse the arguments passed to the function
p.parse(varargin{:});

% Set name of window
set(hObject,'Name',p.Results.Title);


if ~(isempty(p.Results.xlimits)) && ~(isempty(p.Results.ylimits))
    imageargs = {p.Results.xlimits p.Results.ylimits};
else
    imageargs = cell(0);
end
imageargs = [imageargs p.Results.image];

% Set parent object in list of arguments to be passed to the image function

% comment out as in matlab version later than 2014a, you can put handles
% and number into same array. 
% imageargs = [imageargs 'Parent' handles.main_axes]; 


xlabel_str = p.Results.xlabel;
if isempty(p.Results.xlabel) 
    if isempty(p.Results.xlimits)
        % no x-limits specified. Use pixels
        xlabel_str = 'x (pixels)';
    else
        % If no label specified but limits are given, assume limits are
        % given in cm
        xlabel_str = 'x (cm)';
    end
end

ylabel_str = p.Results.ylabel;
if isempty(p.Results.ylabel) 
    if isempty(p.Results.ylimits)
        % no y-limits specified. Use pixels
        ylabel_str = 'y (pixels)';
    else
        % If no label specified but limits are given, assume limits are
        % given in cm
        ylabel_str = 'y (cm)';
    end
end


% Unmatched arguments will be passed to the image function, except for a
% few special cases. Process these here
unmatchedargs = p.Unmatched;
if ~isfield(unmatchedargs,'CDataMapping')
    % By default set data mapping to scaled. If argument is specified, use
    % the value passed by the user
    unmatchedargs.CDataMapping = 'scaled';
end

if isfield(unmatchedargs,'Parent')
    % Parent must always be set to the handle of this window. Ignore value
    % of this parameter
    rmfield(unmatchedargs,'Parent');
end

if isfield(unmatchedargs,'CData')
    % CData defined by image parameter. Ignore value of this parameter
    rmfield(unmatchedargs,'CData');
end

% Add the unmatched arguments specified to the list of input arguments to
% be passed to the image function
unmatchedargnames = fieldnames(unmatchedargs);
unmatchedargvals = struct2cell(unmatchedargs);
nunmatched = numel(unmatchedargnames);
for i=1:nunmatched
    imageargs = [imageargs unmatchedargnames{i} unmatchedargvals{i}];
end

% image(imageargs{:});

img=image(imageargs{:});

% Added this as the matlab version later than 2015a. You can not do put
% handle and number into same array.
% 
set(img,'Parent',handles.main_axes);

if p.Results.flipyaxis
    set(handles.main_axes,'YDir','reverse');
else
    set(handles.main_axes,'YDir','normal');
end
colorbar('peer',handles.main_axes);
showimage(handles);
xlabel(handles.main_axes,xlabel_str);
ylabel(handles.main_axes,ylabel_str);
modestring = p.Results.Mode;
modestring='summary'
switch modestring
    case 'image'
        % Nothing else to do
    case 'summary'
        % Show summary information
        set(handles.options_buttongroup,'Visible','off');
        set(handles.xprofile_togglebutton,'Visible','off');
        set(handles.yprofile_togglebutton,'Visible','off');
        set(handles.profile_togglebutton,'Visible','off');
        set(handles.summary_togglebutton,'Value',get(handles.summary_togglebutton,'Max'));
        modeeventdata.EventName = 'SelectionChanged';
        modeeventdata.OldValue = handles.image_togglebutton;
        modeeventdata.NewValue = handles.summary_togglebutton;
        EImage('options_buttongroup_SelectionChangeFcn',handles.options_buttongroup,modeeventdata,handles);
    case 'profile'
        % Show general profile line
        set(handles.profile_togglebutton,'Value',get(handles.profile_togglebutton,'Max'));
        modeeventdata.EventName = 'SelectionChanged';
        modeeventdata.OldValue = handles.image_togglebutton;
        modeeventdata.NewValue = handles.profile_togglebutton;
        EImage('options_buttongroup_SelectionChangeFcn',handles.options_buttongroup,modeeventdata,handles);
    case 'xprofile'
        % Show x profile
        set(handles.xprofile_togglebutton,'Value',get(handles.xprofile_togglebutton,'Max'));
        modeeventdata.EventName = 'SelectionChanged';
        modeeventdata.OldValue = handles.image_togglebutton;
        modeeventdata.NewValue = handles.xprofile_togglebutton;
        EImage('options_buttongroup_SelectionChangeFcn',handles.options_buttongroup,modeeventdata,handles);
    case 'yprofile'
        % Show y profile
        set(handles.yprofile_togglebutton,'Value',get(handles.yprofile_togglebutton,'Max'));
        modeeventdata.EventName = 'SelectionChanged';
        modeeventdata.OldValue = handles.image_togglebutton;
        modeeventdata.NewValue = handles.yprofile_togglebutton;
        EImage('options_buttongroup_SelectionChangeFcn',handles.options_buttongroup,modeeventdata,handles);
    otherwise
        % Invalid mode specified
        error('Invalid mode specified for EImage');
end


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes EImage_backup2 wait for user response (see UIRESUME)
% uiwait(handles.Eimage_fig);


% --- Outputs from this function are returned to the command line.
function varargout = EImage_backup2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;
% Function will return handle for main axes, sub axes and information
% window
varargout{1} = handles.main_axes;
varargout{2} = handles.sub_axes;
varargout{3} = handles.infowindow_text;
varargout{4}=handles.Eimage_fig;
varargout{5}=handles.output;
 imagehandle = findobj(handles.main_axes,'Type','image');
     idata = get(imagehandle,'Cdata');
        
        idata=double(idata);
        [summarystring,numpass]= CalculateSummaryData(idata);
        
      
        
        handles.pass_rate=numpass;
        
        guidata(hObject,handles);
        

        varargout{6}=handles.pass_rate;

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Redraw the window to show the subplot axes (beneath the main plot)
function showsubplot(handles)

pixspacing = 60;
% Change the units to pixels for computation
axes1_units = get(handles.main_axes,'Units');
axes2_units = get(handles.sub_axes,'Units');
figure_units = get(handles.Eimage_fig,'Units');
option_units = get(handles.options_buttongroup,'Units');
slider_units = get(handles.slider_panel,'Units');

set(handles.main_axes,'Units','pixels');
set(handles.sub_axes,'Units','pixels');
set(handles.Eimage_fig,'Units','pixels');
set(handles.options_buttongroup,'Units','pixels');
set(handles.slider_panel,'Units','pixels');

% Determine total height of window required
axes1_dim = get(handles.main_axes,'Position');
axes2_dim = get(handles.sub_axes,'Position');
figure_dim = get(handles.Eimage_fig,'Position');
newheight = axes1_dim(4) + axes2_dim(4) + 4*pixspacing;
newbottom = figure_dim(2) - axes2_dim(4) - 2*pixspacing;
if newbottom < 0
    newbottom = 0;
end

axis(handles.main_axes, 'image');

% Adjust size of objects
figure_dim(2) = newbottom;
figure_dim(4) = newheight;
set(handles.Eimage_fig,'Position',figure_dim);
axes2_dim(2) = pixspacing;
set(handles.sub_axes,'Position',axes2_dim);
axes1_dim(2) = axes2_dim(2) + axes2_dim(4) + 2*pixspacing;
set(handles.main_axes,'Position',axes1_dim);

options_dim = get(handles.options_buttongroup,'Position');
slider_dim = get(handles.slider_panel,'Position');

options_dim(2) = axes1_dim(2) + axes1_dim(4) - options_dim(4) + 10;
slider_dim(2) = options_dim(2) - slider_dim(4) - 10;
set(handles.options_buttongroup,'Position',options_dim);
set(handles.slider_panel,'Position',slider_dim);

% Set units back to previous value
set(handles.main_axes,'Units',axes1_units);
set(handles.sub_axes,'Units',axes2_units);
set(handles.Eimage_fig,'Units',figure_units);
set(handles.options_buttongroup,'Units',option_units);
set(handles.slider_panel,'Units',slider_units);

% Show the relevant objects
set(handles.infowindow_text,'visible','off');
set(handles.slider_panel,'visible','off');
set(allchild(handles.slider_panel),'visible','off');
set(handles.sub_axes,'visible','on');
set(allchild(handles.sub_axes),'visible','on');


%Redraw the window to show the summary window beneath the main plot
function showsummary(handles)
pixspacing = 60;
% Change the units to pixels for computation
axes1_units = get(handles.main_axes,'Units');
axes2_units = get(handles.sub_axes,'Units');
summary_units = get(handles.infowindow_text,'Units');
figure_units = get(handles.Eimage_fig,'Units');
option_units = get(handles.options_buttongroup,'Units');
slider_units = get(handles.slider_panel,'Units');

set(handles.main_axes,'Units','pixels');
set(handles.sub_axes,'Units','pixels');
set(handles.infowindow_text,'Units','pixels');
set(handles.Eimage_fig,'Units','pixels');
set(handles.options_buttongroup,'Units','pixels');
set(handles.slider_panel,'Units','pixels');

% Determine total height of window required
axes1_dim = get(handles.main_axes,'Position');
axes2_dim = get(handles.sub_axes,'Position');
summary_dim = get(handles.infowindow_text,'Position');
figure_dim = get(handles.Eimage_fig,'Position');
newheight = axes1_dim(4) + summary_dim(4) + 4*pixspacing;
newbottom = figure_dim(2) +figure_dim(4) - axes1_dim(4) - summary_dim(4) - 4*pixspacing;
if newbottom < 0
    newbottom = 0;
end

axis(handles.main_axes, 'image');
% Adjust size of objects
figure_dim(2) = newbottom;
figure_dim(4) = newheight;
set(handles.Eimage_fig,'Position',figure_dim);
summary_dim(2) = pixspacing;
set(handles.infowindow_text,'Position',summary_dim);
axes2_dim(2) = summary_dim(2) + summary_dim(4) + 2*pixspacing;
set(handles.sub_axes,'Position',axes2_dim);
axes1_dim(2) = summary_dim(2) + summary_dim(4) + 2*pixspacing;
set(handles.main_axes,'Position',axes1_dim);

options_dim = get(handles.options_buttongroup,'Position');
slider_dim = get(handles.slider_panel,'Position');

options_dim(2) = axes1_dim(2) + axes1_dim(4) - options_dim(4) + 10;
slider_dim(2) = options_dim(2) - slider_dim(4) - 10;
set(handles.options_buttongroup,'Position',options_dim);
set(handles.slider_panel,'Position',slider_dim);

removecrosshair(handles);

% Set units back to previous value
set(handles.main_axes,'Units',axes1_units);
set(handles.sub_axes,'Units',axes2_units);
set(handles.infowindow_text,'Units',summary_units);
set(handles.Eimage_fig,'Units',figure_units);
set(handles.options_buttongroup,'Units',option_units);
set(handles.slider_panel,'Units',slider_units);

set(handles.infowindow_text,'visible','on');
set(handles.slider_panel,'visible','off');
set(allchild(handles.slider_panel),'visible','off');
set(handles.sub_axes,'visible','off');
set(allchild(handles.sub_axes),'visible','off');

% Redraw the window to show the slider panel beneath the main plot
function showsliders(handles)
set(handles.infowindow_text,'visible','off');
set(handles.slider_panel,'visible','on');
set(allchild(handles.slider_panel),'visible','on');
set(handles.sub_axes,'visible','off');
set(allchild(handles.sub_axes),'visible','off');

% Redraw the window to show only the main image
function showimage(handles)

pixspacing = 60;
%set(handles.main_axes,'YDir','normal');
% Change the units to pixels for computation
axes1_units = get(handles.main_axes,'Units');
% axes2_units = get(handles.sub_axes,'Units');
figure_units = get(handles.Eimage_fig,'Units');
option_units = get(handles.options_buttongroup,'Units');
slider_units = get(handles.slider_panel,'Units');

set(handles.main_axes,'Units','pixels');
set(handles.sub_axes,'Units','pixels');
set(handles.Eimage_fig,'Units','pixels');
set(handles.options_buttongroup,'Units','pixels');
set(handles.slider_panel,'Units','pixels');

axis(handles.main_axes, 'image');

% Determine total height of window required
axes1_dim = get(handles.main_axes,'Position');
axes2_dim = get(handles.sub_axes,'Position');
figure_dim = get(handles.Eimage_fig,'Position');
newheight = axes1_dim(4) + 2*pixspacing;
newbottom = figure_dim(2) + figure_dim(4) - axes1_dim(4) - 2*pixspacing;
%newbottom = axes1_dim(2) - pixspacing;
if newbottom < 0
    newbottom = 0;
end

% Adjust size of objects
figure_dim(2) = newbottom;
figure_dim(4) = newheight;
set(handles.Eimage_fig,'Position',figure_dim);
axes2_dim(2) = pixspacing;
set(handles.sub_axes,'Position',axes2_dim);
axes1_dim(2) = pixspacing;
set(handles.main_axes,'Position',axes1_dim);

options_dim = get(handles.options_buttongroup,'Position');
slider_dim = get(handles.slider_panel,'Position');

options_dim(2) = axes1_dim(2) + axes1_dim(4) - options_dim(4) + 10;
slider_dim(2) = options_dim(2) - slider_dim(4) - 10;
set(handles.options_buttongroup,'Position',options_dim);
set(handles.slider_panel,'Position',slider_dim);

removecrosshair(handles);

% Set units back to previous value
set(handles.main_axes,'Units',axes1_units);
set(handles.sub_axes,'Units',axes2_units);
set(handles.Eimage_fig,'Units',figure_units);
set(handles.options_buttongroup,'Units',option_units);
set(handles.slider_panel,'Units',slider_units);

set(handles.infowindow_text,'visible','off');
set(handles.slider_panel,'visible','off');
set(allchild(handles.slider_panel),'visible','off');
set(handles.sub_axes,'visible','off');
set(allchild(handles.sub_axes),'visible','off');



% --- Executes when selected object is changed in options_buttongroup.
function options_buttongroup_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in options_buttongroup 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
buttonpushed = get(eventdata.NewValue,'Tag');
switch buttonpushed
    case 'image_togglebutton'
        showimage(handles);
        RemoveGeneralProfile(handles);
    case 'summary_togglebutton'
        showsummary(handles);
        imagehandle = findobj(handles.main_axes,'Type','image');
        idata = get(imagehandle,'Cdata');
        
        idata=double(idata);
        [summarystring,numpass]= CalculateSummaryData(idata);
        
        handles.pass_rate=numpass;
        
        guidata(hObject,handles);
        
               
             
        set(handles.infowindow_text,'String',summarystring);
        RemoveGeneralProfile(handles);
    case 'xprofile_togglebutton'
        setappdata(handles.slider_panel,'SliderControl','xprofile');
        showsubplot(handles);
        SetSlidersProfile(handles);
        PlotProfile(handles);
        RemoveGeneralProfile(handles);
    case 'yprofile_togglebutton'
        setappdata(handles.slider_panel,'SliderControl','yprofile');
        showsubplot(handles);
        SetSlidersProfile(handles);
        PlotProfile(handles);
        RemoveGeneralProfile(handles);
    case 'profile_togglebutton'
        setappdata(handles.slider_panel,'SliderControl','generalprofile');
        showsubplot(handles);
        PlotGeneralProfile(handles);
    case 'histogram_togglebutton'
        showsubplot(handles);
        PlotHisto(handles);
        RemoveGeneralProfile(handles);
%     case 'contrast_togglebutton'
%         setappdata(handles.slider_panel,'SliderControl','contrast');
%         showimage(handles);
%         SetSlidersContrast(handles);
end
    



function bottomslider_edit_Callback(hObject, eventdata, handles)
% hObject    handle to bottomslider_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bottomslider_edit as text
%        str2double(get(hObject,'String')) returns contents of bottomslider_edit as a double
newvalue = str2double(get(hObject,'String'));
if isnan(newvalue) || (~isreal(newvalue))
     % Invalid value. Replace with previous (from slider control)
   set(hObject,'String',get(handles.bottom_slider,'Value'));
   return;
else
    % Verify that number is within the legitimate range
    maxvalue = get(handles.bottom_slider,'Max');
    minvalue = get(handles.bottom_slider,'Min');
    if newvalue > maxvalue
        newvalue = maxvalue;
    end
    if newvalue < minvalue
        newvalue = minvalue;
    end
end

slidermode = getappdata(handles.slider_panel,'SliderControl');
switch slidermode
    case 'contrast'
        % Bottom edit box controls window
        newwindow = newvalue;
        newlevel = get(handles.top_slider,'Value');
        
        set(handles.bottom_slider,'Value',newwindow);
        
        minwindow = newlevel - newwindow/2;
        maxwindow = newlevel + newwindow/2;
        set(handles.bottom_slider,'Value',newwindow);
        set(handles.main_axes,'CLim',[minwindow maxwindow]);
        
    case 'xprofile'
        newx = newvalue;
        himage = findobj(handles.main_axes,'Type','image');
        xlimits = get(himage,'XData');
        nxpoints = size(get(himage,'CData'),2);
        deltax = (xlimits(2) - xlimits(1))/(nxpoints - 1);
        newxpix = round(1 + (newx - xlimits(1))/deltax);
        newvalue = xlimits(1) + deltax*(newxpix - 1);
        set(handles.bottom_slider,'Value',newvalue);
        PlotProfile(handles);
    case 'yprofile'
        error('Invalid profile. Should not be able to trigger this event');
        
end
set(hObject,'String',newvalue);


% --- Executes during object creation, after setting all properties.
function bottomslider_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bottomslider_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function topslider_edit_Callback(hObject, eventdata, handles)
% hObject    handle to topslider_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of topslider_edit as text
%        str2double(get(hObject,'String')) returns contents of topslider_edit as a double
% Perform error checking
newvalue = str2double(get(hObject,'String'));
if isnan(newvalue) || (~isreal(newvalue))
     % Invalid value. Replace with previous (from slider control)
   set(hObject,'String',get(handles.top_slider,'Value'));
   return;
else
    % Verify that number is within the legitimate range
    maxvalue = get(handles.top_slider,'Max');
    minvalue = get(handles.top_slider,'Min');
    if newvalue > maxvalue
        newvalue = maxvalue;
    end
    if newvalue < minvalue
        newvalue = minvalue;
    end
end


slidermode = getappdata(handles.slider_panel,'SliderControl');

switch slidermode
    case 'contrast'
        % Top edit box controls level
        newlevel = newvalue;
        newwindow = get(handles.bottom_slider,'Value');
        minwindow = newlevel - newwindow/2;
        maxwindow = newlevel + newwindow/2;
        set(handles.top_slider,'Value',newlevel);
        set(handles.main_axes,'CLim',[minwindow maxwindow]);
        
    case 'xprofile'
        error('Invalid profile. Should not be able to trigger this event');
    case 'yprofile'
        newy = newvalue;
        himage = findobj(handles.main_axes,'Type','image');
        ylimits = get(himage,'YData');
        nypoints = size(get(himage,'CData'),1);
        deltay = (ylimits(2) - ylimits(1))/(nypoints - 1);
        newypix = round(1 + (newy - ylimits(1))/deltay);
        newvalue = ylimits(1) + deltay*(newypix - 1);
        set(handles.top_slider,'Value',newvalue);
        PlotProfile(handles);
        
end
set(hObject,'String',newvalue);

% --- Executes during object creation, after setting all properties.
function topslider_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to topslider_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function bottom_slider_Callback(hObject, eventdata, handles)
% hObject    handle to bottom_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Determine which mode the sliders are in
slidermode = getappdata(handles.slider_panel,'SliderControl');

switch slidermode
    case 'contrast'
        % Bottom slider controls window
        newwindow = get(hObject,'Value');
        newlevel = get(handles.top_slider,'Value');
        newmin = newlevel - newwindow/2;
        newmax = newlevel + newwindow/2;
        set(handles.main_axes,'CLim',[newmin newmax]);
        set(handles.bottomslider_edit,'String',num2str(newwindow));
        
    case 'xprofile'
        % update text box
        newx = get(hObject,'Value');
        set(handles.bottomslider_edit,'String',num2str(newx));
        
        PlotProfile(handles);
    case 'yprofile'
        
        error('Invalid profile. Should not be able to trigger this event');
end


% --- Executes during object creation, after setting all properties.
function bottom_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bottom_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function top_slider_Callback(hObject, eventdata, handles)
% hObject    handle to top_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Determine which mode the sliders are in
slidermode = getappdata(handles.slider_panel,'SliderControl');

switch slidermode
    case 'contrast'
        % Top slider controls level
        newlevel = get(hObject,'Value');
        newwindow = get(handles.bottom_slider,'Value');
        newmin = newlevel - newwindow/2;
        newmax = newlevel + newwindow/2;
        set(handles.main_axes,'CLim',[newmin newmax]);
        set(handles.topslider_edit,'String',num2str(newlevel));
        
    case 'xprofile'
        error('Invalid profile. Should not be able to trigger this event');
    case 'yprofile'
        % update text box
        newy = get(hObject,'Value');
        set(handles.topslider_edit,'String',num2str(newy));
        
        PlotProfile(handles);
end

% --- Executes during object creation, after setting all properties.
function top_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to top_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% calculate gammma pass rate.

function gpassrate= calGammaPassRate(imagedata)

% get mask for gamma image

% use gmap as images dataset.
Mask = zeros(size(imagedata));

critical_val=0.01*max(imagedata(:));  % changed from 10 to 1%.

Mask(imagedata>critical_val) = 1;

numWithinField = nnz(Mask);
numpass = nnz(imagedata<1 & Mask)./numWithinField;
avg = sum(imagedata(:))./numWithinField;

gpassrate=numpass;





% Compute the summary string to be placed in the information window
function [summarystring,numpass] = CalculateSummaryData(imagedata,varargin)
% Compute some summary values
minimage = min(imagedata(:));
maximage = max(imagedata(:));
meanimage = mean(imagedata(:));
medimage = median(imagedata(:));
devimage = std(imagedata(:));
[ypix xpix] = size(imagedata);

% get mask for gamma image

% use gmap as images dataset.
Mask = zeros(size(imagedata));

type=class(imagedata)

% critical_val=0.01*max(imagedata(:));  % changed from 10 to 1%.

critical_val=0;

Mask(imagedata>critical_val) = 1;

numWithinField = nnz(Mask);
numpass = nnz(imagedata<1 & Mask)./numWithinField;

avg = sum(imagedata(:))./numWithinField;

      


% Construct summary string
% summarystring = {'Gamma Map Statistics'; ['Minimum Value: ' num2str(minimage)]; ...
%     ['Maximum Value: ' num2str(maximage)]; ['Mean Value: ' num2str(meanimage)]; ...
%     ['Median Value: ' num2str(medimage)]; ['Standard Deviation: ' num2str(devimage)];...
%     ['Gamma range (0-1)percentage:' num2str(numpass*100) '%'];...
%     ['Gamma range (>1) percentage:' num2str((1-numpass)*100) '%']...
%     }
summarystring = {'Gamma Criteria:3mm/3% of local maximum TPS dose and 10% threshold';...
                 'Gamma Map Statistics'; ['Minimum Value: ' num2str(minimage)]; ...
    ['Maximum Value: ' num2str(maximage)]; ['Mean Value: ' num2str(meanimage)]; ...
    ['Gamma range (0-1):' num2str(numpass*100) '%'];...
    ['Gamma range (>1):' num2str((1-numpass)*100) '%']...
    }


% Function to configure the sliders for contrast adjustment
function SetSlidersContrast(handles)
set(handles.slider_panel,'Visible','on');
set(allchild(handles.slider_panel),'Visible','on');
set(allchild(handles.slider_panel),'Enable','on');
set(handles.topslider_label,'String','Level');
set(handles.bottomslider_label,'String','Window');

% Get the image data from the Main axes
himage = findobj(handles.main_axes,'Type','image');
idata = get(himage,'CData');
set(handles.top_slider,'Min',min(idata(:)));
set(handles.top_slider,'Max',max(idata(:)));
set(handles.bottom_slider,'Min',min(idata(:)));
set(handles.bottom_slider,'Max',max(idata(:)) - min(idata(:)));

% Set the default values for the sliders and adjust the contrast
% accordingly
winlimits = get(handles.main_axes,'CLim');
minwindow = winlimits(1);
maxwindow = winlimits(2);
midlevel = (minwindow + maxwindow)/2;
midwindow = (maxwindow - minwindow);
% midlevel = (max(idata(:)) + min(idata(:)))/2;
% midwindow = (max(idata(:)) - min(idata(:)))/2;
set(handles.top_slider,'Value',midlevel);
set(handles.topslider_edit,'String',num2str(midlevel));
set(handles.bottom_slider,'Value',midwindow);
set(handles.bottomslider_edit,'String',num2str(midwindow));
% minwindow = midlevel - midwindow/2;
% maxwindow = midlevel + midwindow/2;
% set(handles.main_axes,'Clim',[minwindow maxwindow]);

% Set the movement levels for the sliders
set(handles.top_slider,'SliderStep',[0.01 0.1]);
set(handles.bottom_slider,'SliderStep',[0.01 0.1]);




% Function to configure the sliders for profile adjustment
function SetSlidersProfile(handles)
% Determines whether to setup for x or y profiles from 'SliderControl'
% appdata variable

set(handles.slider_panel,'Visible','on');
set(allchild(handles.slider_panel),'Visible','on');
set(handles.topslider_label,'String','Level');
set(handles.bottomslider_label,'String','Window');

% Get the image data from the Main axes
himage = findobj(handles.main_axes,'Type','image');
idatasize = size(get(himage,'CData'));
xlimits = get(himage,'XData');
ylimits = get(himage,'YData');
deltax = (xlimits(2) - xlimits(1))/(idatasize(2) - 1);
deltay = (ylimits(2) - ylimits(1))/(idatasize(1) - 1);

% Top slider controls X location. Bottom slider controls Y location
set(handles.topslider_label,'String','X Location');
set(handles.topslider_edit,'String','');
set(handles.bottomslider_label,'String','Y Location');
set(handles.bottomslider_edit,'String','');

% Set min, max, initial values for sliders
minxstep = deltax/(xlimits(2) - xlimits(1));
minystep = deltay/(ylimits(2) - ylimits(1));
Ypix = round(idatasize(1)/2);
Xpix = round(idatasize(2)/2);
xval = xlimits(1) + deltax * (Xpix - 1);
yval = ylimits(1) + deltay * (Ypix - 1);
set(handles.top_slider,'Value',xval);
set(handles.top_slider,'Min',xlimits(1));
set(handles.top_slider,'Max',xlimits(2));
set(handles.top_slider,'SliderStep',[minxstep 10*minxstep]);
set(handles.topslider_edit,'String',num2str(xval));
set(handles.bottom_slider,'Value',yval);
set(handles.bottom_slider,'Min',ylimits(1));
set(handles.bottom_slider,'Max',ylimits(2));
set(handles.bottom_slider,'SliderStep',[minystep 10*minystep]);
set(handles.bottomslider_edit,'String',num2str(yval));

slidermode = getappdata(handles.slider_panel,'SliderControl');
switch slidermode
    case 'xprofile'
        % profiles in x direction. Adjust Y location
        set(handles.topslider_label,'Enable','off');
        set(handles.topslider_edit,'Enable','off');
        set(handles.top_slider,'Enable','off');
        set(handles.bottomslider_label,'Enable','on');
        set(handles.bottomslider_edit,'Enable','on');
        set(handles.bottom_slider,'Enable','on');
    case 'yprofile'
        % profiles in y direction. Adjust X location
        set(handles.topslider_label,'Enable','on');
        set(handles.topslider_edit,'Enable','on');
        set(handles.top_slider,'Enable','on');
        set(handles.bottomslider_label,'Enable','off');
        set(handles.bottomslider_edit,'Enable','off');
        set(handles.bottom_slider,'Enable','off');
    otherwise
        error('Invalid slider mode. Should not be able to get to this point');
end

% Plot the data in the image as a histogram
function PlotHisto(handles)
% Get the image data
himage = findobj(handles.main_axes,'Type','image');
imdata = get(himage,'CData');

% Plot the histogram
npix = numel(imdata);
freqperbin = 10;
nbin = floor(npix / freqperbin);
hist(handles.sub_axes,imdata(:),nbin);
xlabel(handles.sub_axes,'Pixel value');
ylabel(handles.sub_axes,'Frequency');

% Plot the relevant profile based on current values
function PlotProfile(handles)

% Determine what type of profile to plot
slidermode = getappdata(handles.slider_panel,'SliderControl');

% Get the profile data
himage = findobj(handles.main_axes,'Type','image');
imdata = get(himage,'CData');
xdata = get(himage,'XData');
ydata = get(himage,'YData');

switch slidermode
    case 'xprofile'
        yval = get(handles.bottom_slider,'Value');
        npoints = size(imdata,2);
        ordinate_limits = get(himage,'XData');
        delta = (ordinate_limits(2) - ordinate_limits(1))/(npoints - 1);
        prof_ordinate = ordinate_limits(1):delta:ordinate_limits(2);
        prof = improfile(xdata,ydata,imdata,ordinate_limits,[yval yval],npoints);
        prof_title = 'X Profile';
        if isappdata(handles.main_axes,'handle_crosshair')
            handle_crosshair = getappdata(handles.main_axes,'handle_crosshair');
            set(handle_crosshair,'YData',[yval yval]);
            set(handle_crosshair,'XData',ordinate_limits);
        else
            handle_crosshair = line(ordinate_limits,[yval yval],'Color','k','Parent',handles.main_axes);
            setappdata(handles.main_axes,'handle_crosshair',handle_crosshair);
        end
    case 'yprofile'
        xval = get(handles.top_slider,'Value');
        npoints = size(imdata,1);
        ordinate_limits = get(himage,'YData');
        delta = (ordinate_limits(2) - ordinate_limits(1))/(npoints - 1);
        prof_ordinate = ordinate_limits(1):delta:ordinate_limits(2);
        prof = improfile(xdata,ydata,imdata,[xval xval], ordinate_limits,npoints);
        prof_title = 'Y Profile';
        if isappdata(handles.main_axes,'handle_crosshair')
            handle_crosshair = getappdata(handles.main_axes,'handle_crosshair');
            set(handle_crosshair,'XData',[xval xval]);
            set(handle_crosshair,'YData',ordinate_limits);
        else
            handle_crosshair = line([xval xval],ordinate_limits,'Color','k','Parent',handles.main_axes);
            setappdata(handles.main_axes,'handle_crosshair',handle_crosshair);
        end
    case 'generalprofile'
        
    otherwise
        error('Invalid Profile. Should not be able to get to this point');
end

% plot the profile
plot(handles.sub_axes,prof_ordinate,prof);
title(handles.sub_axes,prof_title);

% Function for plotting a general profile along a line in the image
function PlotGeneralProfile(handles)

% Get the line handles, if available. Otherwise, create them
himage = findobj(handles.main_axes,'Type','image');
if isappdata(handles.profile_togglebutton,'handle_profileline');
    handle_profileline = getappdata(handles.profile_togglebutton,'handle_profileline');
else
    x1data = get(himage,'XData');
    y1data = get(himage,'YData');
    y1linedata = mean(y1data) * ones(1,2);
    handle_profileline = imline(handles.main_axes,x1data,y1linedata);
    % Ensure the line stays within the image borders
    lineconstraintfcn = makeConstrainToRectFcn('imline', ...
        get(handles.main_axes,'XLim'),get(handles.main_axes,'YLim'));
    handle_profileline.setPositionConstraintFcn(lineconstraintfcn);
    % Set a callback function that will update the profile when the line
    % position is changed
    addNewPositionCallback(handle_profileline,@UpdateProfilePosition);
    setappdata(handles.profile_togglebutton,'handle_profileline',handle_profileline);
end
% At this point, have the handle of an imline object in handle_profileline.
% This points to an imline object (see imline in Matlab documentation)
% Now get properties and plot the appropriate profile line in the sub-axes
line_endpoints = handle_profileline.getPosition;
xpoints = line_endpoints(:,1);
ypoints = line_endpoints(:,2);
% Create a profile of the image between the two endpoints
Imdata = get(himage,'CData');
[xprof yprof prof] = improfile(Imdata,xpoints,ypoints);

% Plot the profile in the sub-axes
% Determine whether to use x or y values based on whichever contains a
% larger spread in values;
xprofdiff = max(xprof) - min(xprof);
yprofdiff = max(yprof) - min(yprof);
if xprofdiff > yprofdiff
    % Plot against x values
    plot(handles.sub_axes,xprof,prof);
    
    xlabel(handles.sub_axes,'horizontal image location');
else
    % Plot against y values
    plot(handles.sub_axes,yprof,prof);
    xlabel(handles.sub_axes,'vertical image location');
end

prof_title = 'Profile along given line';
title(handles.sub_axes,prof_title);

% This function is triggered whenever the general profile line position is
% changed. It gets the new position and updates the profile
function UpdateProfilePosition(pos)
handles = guidata(gcbo);
PlotGeneralProfile(handles);


% Function to erase the profile line from the image
function RemoveGeneralProfile(handles)
% Get the line handle, if available. If not available, line has already
% been removed and nothing else is required
if isappdata(handles.profile_togglebutton,'handle_profileline')
    handle_profileline = getappdata(handles.profile_togglebutton,'handle_profileline');
    delete(handle_profileline);
    rmappdata(handles.profile_togglebutton,'handle_profileline');
end

% Removes crosshair from main image
function removecrosshair(handles)

if isappdata(handles.main_axes,'handle_crosshair')
    handle_crosshair = getappdata(handles.main_axes,'handle_crosshair');
    delete(handle_crosshair);
    rmappdata(handles.main_axes,'handle_crosshair');
end


% --------------------------------------------------------------------
function contrast_toggletool_OnCallback(hObject, eventdata, handles)
% hObject    handle to contrast_toggletool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Find all of the controls, pushbuttons etc and disable them.
% panels = [handles.options_buttongroup;handles.slider_panel];
% set(panels,'visible','off');
imhandle = findobj(handles.main_axes,'Type','image');
contrast_handle = imcontrast(imhandle);

% Push handle of contrast tool to appdata for checking when toggles off
setappdata(hObject,'contrasttoolhandle',contrast_handle);

% --------------------------------------------------------------------
function contrast_toggletool_OffCallback(hObject, eventdata, handles)
% hObject    handle to contrast_toggletool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get handle of contrast window to delete it
if isappdata(hObject,'contrasttoolhandle')
    chandle = getappdata(hObject,'contrasttoolhandle');
    if ishandle(chandle)
        delete(chandle);
    end
    rmappdata(hObject,'contrasttoolhandle');
end

% Update the contrast window so it is kept during later manipulations
imagewindow = get(handles.main_axes,'Clim');
setappdata(handles.Eimage_fig,'ContrastWindow',imagewindow);
%set(handles.Image2_axes,'Clim',imagewindow);

% Re-enable the panel buttons
% panels = [handles.options_buttongroup;handles.slider_panel];
% set(panels,'visible','on');


% --------------------------------------------------------------------
function savefigures_pushtool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to savefigures_pushtool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Export the image to separate figure windows for further manipulation
figure;
axes;
copyobj(allchild(handles.main_axes),gca);
%title(get(handles.image1_panel,'Title'));
axis image

subimage1_vis = get(handles.sub_axes,'visible');
if strmatch(subimage1_vis,'on')
    figure;
    copyobj(handles.sub_axes,gcf);
    %legend('show');
    %copyobj(allchild(handles.SubImage1_axes),gca);
end


% --- Executes during object creation, after setting all properties.
function options_buttongroup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to options_buttongroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function slider_panel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
