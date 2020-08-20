function varargout = ImageCompare(varargin)
% IMAGECOMPARE M-file for ImageCompare.fig
%      ImageCompare(Im1,label1,Im2,label2) creates a new image comparison
%      window to compare the images Im1 and Im2. Label1 and Label2 define
%      names for the images. Im1 and Im2 must be numeric 2-dimensional
%      arrays of the same dimension.
%      
%      ImageCompare(Im1,label1,Im2,label2,xvalues,yvalues) creates the same
%      image comparison window as above but uses the defined xvalues and
%      yvalues to define the axes. Xvalues and Yvalues can be either single
%      values that specify the pixel spacing (zero is assumed to be at the 
%      centre), 1x2 arrays that specify the start and end points of the
%      pixels or column vectors with the appropriate dimensions to match up 
%      with the two images and are assumed to be given in units of 
%      centimetres.
%
%      Optional parameter-value pairs are the following:
%      Title: This is a string that gives the window title. Defaults to
%      "Image Comparison"
%      xlabel: This is a string that specifies the label to use for the x
%      dimension. Defaults to "x (cm)"
%      ylabel: This is a string that specifies the label to use for the y
%      dimension. Defaults to "y (cm)"
%      flipyaxis: This is a boolean that determines whether the plots
%      should be flipped in the y-direction. Defaults to true
%      Mode: This is a string that specifies which mode to start
%      ImageCompare in. The options are:
%           Image: Image Mode
%           Contour: Contour Mode
%           Mesh: Mesh Mode
%           Profile: Profile Mode
%           Table: Table Mode
%      
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Last Modified by GUIDE v2.5 11-Jun-2010 15:07:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageCompare_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageCompare_OutputFcn, ...
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


% --- Executes just before ImageCompare is made visible.
function ImageCompare_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImageCompare (see VARARGIN)

% Choose default command line output for ImageCompare
handles.output = hObject;



% UIWAIT makes ImageCompare wait for user response (see UIRESUME)
% uiwait(handles.ImageCompare_fig);

% Implement argument checking using Matlab inputParser Object
p1 = inputParser;
p1.FunctionName = 'Image Compare';
checkimage = @(argtocheck) checkarg(argtocheck,'real',NaN,NaN);
checkcolvect = @(argtocheck) checkarg(argtocheck,'real',1,NaN);

% Required arguments to be passed
p1.addRequired('Image1',checkimage);
p1.addRequired('Image2',checkimage);

% Optional arguments to be passed
p1.addOptional('xvals',[],checkcolvect);
p1.addOptional('yvals',[],checkcolvect);

% Parameter value pairs to be passed
p1.addParamValue('Label1','Image 1',@ischar);
p1.addParamValue('Label2','Image 2',@ischar);
p1.addParamValue('Title', 'Image Comparison', @ischar);
p1.addParamValue('xlabel', 'x (cm)', @ischar);
p1.addParamValue('ylabel', 'y (cm)', @ischar);
p1.addParamValue('flipyaxis',true, @islogical);
p1.addParamValue('Mode','image',@ischar);

% Parse the arguments. If something does not match an error will be thrown
% by the parse method.
try
    p1.parse(varargin{:});
    p = p1;
    clear p1;
catch
    % If an error is raised in parsing the inputs, may be because old style
    % labels were used. Try this format. Should relegate this style of
    % function call at some point.
    p2 = inputParser;
    p2.FunctionName = 'Image Compare (old style)';

    % Required arguments to be passed
    p2.addRequired('Image1',checkimage);
    p2.addRequired('Label1',@ischar);
    p2.addRequired('Image2',checkimage);
    p2.addRequired('Label2',@ischar);

    % Optional arguments to be passed
    p2.addOptional('xvals',[],checkcolvect);
    p2.addOptional('yvals',[],checkcolvect);

    % Parameter value pairs to be passed
    p2.addParamValue('Title', 'Image Comparison', @ischar);
    p2.addParamValue('xlabel', 'x (cm)', @ischar);
    p2.addParamValue('ylabel', 'y (cm)', @ischar);
    p2.addParamValue('flipyaxis',true, @islogical); % Not fully implemented
    p2.addParamValue('Mode','image',@ischar);
    p2.parse(varargin{:});
    p = p2;
    clear p2;
end
I1 = p.Results.Image1;
label1 = p.Results.Label1;
I2 = p.Results.Image2;
label2 = p.Results.Label2;
xvals = p.Results.xvals;
yvals = p.Results.yvals;
xlabel = p.Results.xlabel;
ylabel = p.Results.ylabel;

xsize = size(I1,2);
ysize = size(I1,1);
if any(size(I2) ~= [ysize xsize])
    error('Image dimensions do not match');
end

if isempty(xvals)
    xvals = 1:xsize;
    xlabel = 'pixels';
    % Gamma is only meaningful with knowledge of the scale for the image.
    % Disable the gamma button in this case.
    set(handles.gamma_pushbutton,'enable','off');
end

if isempty(yvals)
    yvals = 1:ysize;
    ylabel = 'pixels';
    % Gamma is only meaningful with knowledge of the scale for the image.
    % Disable the gamma button in this case.
    set(handles.gamma_pushbutton,'enable','off');
end

if numel(xvals) ~= xsize
    switch numel(xvals)
        case 2
            % Assume given values are first and last pixel values. All
            % pixels evenly spaced between these
            xmin = xvals(1);
            xmax = xvals(2);
            xvalsconstruct = linspace(xmin,xmax,xsize);
        case 1
            % Assume given value is pixel spacing. Centre x value is
            % assumed to be zero
            centrepix = round(xsize/2);
            deltax = xvals;
            xvalsconstruct = (linspace(1,xsize,xsize) - centrepix) * deltax;
        otherwise
            error('X values do not match image');
    end
else
    xvalsconstruct = xvals;
end

if numel(yvals) ~= ysize
    switch numel(yvals)
        case 2
            % Assume given values are first and last pixel values. All
            % pixels evenly spaced between these
            ymin = yvals(1);
            ymax = yvals(2);
            yvalsconstruct = linspace(ymin,ymax,ysize);
        case 1
            % Assume given value is pixel spacing. Centre y value is
            % assumed to be zero
            centrepix = round(ysize/2);
            deltay = yvals;
            yvalsconstruct = (linspace(1,ysize,ysize) - centrepix) * deltay;
        otherwise
            error('Y values do not match image');
    end
else
    yvalsconstruct = yvals;
end

% Set name of window
set(hObject,'Name',p.Results.Title);

setappdata(hObject,'image1',I1);
setappdata(hObject,'label1',label1);
setappdata(hObject,'image2',I2);
setappdata(hObject,'label2',label2);
setappdata(hObject,'xvalues',xvalsconstruct);
setappdata(hObject,'yvalues',yvalsconstruct);
setappdata(hObject,'xlabel',xlabel);
setappdata(hObject,'ylabel',ylabel);

minimage = min(min(I1(isfinite(I1))),min(I2(isfinite(I2))));
maximage = max(max(I1(isfinite(I1))),max(I2(isfinite(I2))));
setappdata(hObject,'ContrastWindow',[minimage maximage]);

set(handles.image1_panel,'title',label1);
set(handles.image2_panel,'title',label2);

setappdata(hObject,'flipyaxis',p.Results.flipyaxis);


% Set slider information
stepmultiple = 20;
minstepx = 1/numel(xvalsconstruct);
set(handles.xprofile_slider,'Min',1);
set(handles.xprofile_slider,'Max',numel(xvalsconstruct));
set(handles.xprofile_slider,'SliderStep',[minstepx stepmultiple*minstepx]);
set(handles.xprofile_slider,'Value',floor(numel(xvalsconstruct)/2));
set(handles.xprofile_slider,'Enable','off');
set(handles.xprofile_slider,'Visible','off');

minstepy = 1/numel(yvalsconstruct);
set(handles.yprofile_slider,'Min',1);
set(handles.yprofile_slider,'Max',numel(yvalsconstruct));
set(handles.yprofile_slider,'SliderStep',[minstepy stepmultiple*minstepy]);
set(handles.yprofile_slider,'Value',floor(numel(yvalsconstruct)/2));
set(handles.yprofile_slider,'Enable','off');
set(handles.yprofile_slider,'Visible','off');

axis([handles.Image1_axes handles.Image2_axes],'image');

modestring = upper(p.Results.Mode);
PlotImages(handles);
switch modestring
    case 'IMAGE'
        % Nothing else to do
    case 'CONTOUR'
        set(handles.contour_togglebutton,'Value',get(handles.contour_togglebutton,'Max'));
        PlotContours(handles);
%         modeeventdata.EventName = 'SelectionChanged';
%         modeeventdata.OldValue = handles.imagesc_togglebutton;
%         modeeventdata.NewValue = handles.contour_togglebutton;
%         ImageCompare('PlotOptions_buttongroup_SelectionChangeFcn',handles.PlotOptions_buttongroup,modeeventdata,handles);
    case 'MESH'
        set(handles.mesh_togglebutton,'Value',get(handles.mesh_togglebutton,'Max'));
        PlotMesh(handles);
%         modeeventdata.EventName = 'SelectionChanged';
%         modeeventdata.OldValue = handles.imagesc_togglebutton;
%         modeeventdata.NewValue = handles.mesh_togglebutton;
%         ImageCompare('PlotOptions_buttongroup_SelectionChangeFcn',handles.PlotOptions_buttongroup,modeeventdata,handles);
    case 'PROFILE'
        set(handles.profile_togglebutton,'Value',get(handles.profile_togglebutton,'Max'));
        PlotProfiles(handles);
%         modeeventdata.EventName = 'SelectionChanged';
%         modeeventdata.OldValue = handles.imagesc_togglebutton;
%         modeeventdata.NewValue = handles.profile_togglebutton;
%         ImageCompare('PlotOptions_buttongroup_SelectionChangeFcn',handles.PlotOptions_buttongroup,modeeventdata,handles);
    case 'TABLE'
        set(handles.rawdata_togglebutton,'Value',get(handles.rawdata_togglebutton,'Max'));
        DataTables(handles);
%         modeeventdata.EventName = 'SelectionChanged';
%         modeeventdata.OldValue = handles.imagesc_togglebutton;
%         modeeventdata.NewValue = handles.rawdata_togglebutton;
%         ImageCompare('PlotOptions_buttongroup_SelectionChangeFcn',handles.PlotOptions_buttongroup,modeeventdata,handles);
    otherwise
        % Invalid mode
        error('Invalid mode specified for ImageCompare');
end


% Update handles structure
guidata(hObject, handles);





% --- Outputs from this function are returned to the command line.
function varargout = ImageCompare_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in imagesc_pushbutton.
function imagesc_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to imagesc_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in contour_pushbutton.
function contour_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to contour_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in PlotOptions_buttongroup.
function PlotOptions_buttongroup_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in PlotOptions_buttongroup 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'imagesc_togglebutton'
        PlotImages(handles);
    case 'contour_togglebutton'
        PlotContours(handles);
    case 'mesh_togglebutton'
        PlotMesh(handles);
    case 'rawdata_togglebutton'
        PlotImages(handles);
        DataTables(handles);
    case 'profile_togglebutton'
        PlotImages(handles);
        PlotProfiles(handles);
        
        
end

function PlotImages(handles)
% Plot the images using imagesc
set(handles.Image1_table,'visible','off');
set(handles.Image2_table,'visible','off');
set(handles.image1info_text,'visible','on');
set(handles.image2info_text,'visible','on');
% set(handles.Image1_axes,'visible','on');
% set(handles.Image2_axes,'visible','on');
set(handles.SubImage1_axes,'visible','off');
set(handles.SubImage2_axes,'visible','off');
set(allchild(handles.SubImage1_axes),'visible','off');
set(allchild(handles.SubImage2_axes),'visible','off');
set(handles.xprofile_slider,'visible','off');
set(handles.xprofile_slider,'enable','off');
set(handles.yprofile_slider,'visible','off');
set(handles.yprofile_slider,'enable','off');


image1 = getappdata(handles.ImageCompare_fig,'image1');
image2 = getappdata(handles.ImageCompare_fig,'image2');
xval = getappdata(handles.ImageCompare_fig,'xvalues');
yval = getappdata(handles.ImageCompare_fig,'yvalues');
label1 = getappdata(handles.ImageCompare_fig,'label1');
label2 = getappdata(handles.ImageCompare_fig,'label2');
xaxislabel = getappdata(handles.ImageCompare_fig,'xlabel');
yaxislabel = getappdata(handles.ImageCompare_fig,'ylabel');
flipyaxis = getappdata(handles.ImageCompare_fig,'flipyaxis');
image([xval(1) xval(end)],[yval(1) yval(end)], image1,'Parent',handles.Image1_axes,'CDataMapping','scaled');
image([xval(1) xval(end)],[yval(1) yval(end)], image2,'Parent',handles.Image2_axes,'CDataMapping','scaled');
% Determine min, max values present in images
% minval = min(min(image1(isfinite(image1))),min(image2(isfinite(image2))));
% maxval = max(max(image1(isfinite(image1))),max(image2(isfinite(image2))));
contrastwindow = getappdata(handles.ImageCompare_fig,'ContrastWindow');
set(handles.Image1_axes,'Clim',contrastwindow);
set(handles.Image2_axes,'Clim',contrastwindow);
colorbar('peer',handles.Image1_axes);
colorbar('peer',handles.Image2_axes);
if flipyaxis
    set(handles.Image1_axes,'YDir','reverse');
    set(handles.Image2_axes,'YDir','reverse');
else
    set(handles.Image1_axes,'YDir','normal');
    set(handles.Image2_axes,'YDir','normal');
end
axis(handles.Image1_axes, 'image');
axis(handles.Image2_axes, 'image');
xlabel(handles.Image1_axes,xaxislabel);
ylabel(handles.Image1_axes,yaxislabel);
xlabel(handles.Image2_axes,xaxislabel);
ylabel(handles.Image2_axes,yaxislabel);
set(handles.image1_panel,'title',label1);
set(handles.image2_panel,'title',label2);

% Put crosshair lines on plot. Hide except in profile mode
image1x_line = line([xval(1) xval(end)], ...
    [yval(floor(numel(yval)/2)) yval(floor(numel(yval)/2))], ...
    'Parent',handles.Image1_axes,'Color','k','Visible','off');
setappdata(handles.Image1_axes,'crosshair_x_handle',image1x_line);
image1y_line = line([xval(floor(numel(xval)/2)) xval(floor(numel(xval)/2))], ...
    [yval(1) yval(end)], ...
    'Parent',handles.Image1_axes,'Color','k','Visible','off');
setappdata(handles.Image1_axes,'crosshair_y_handle',image1y_line);
image2x_line = line([xval(1) xval(end)], ...
    [yval(floor(numel(yval)/2)) yval(floor(numel(yval)/2))], ...
    'Parent',handles.Image2_axes,'Color','k','Visible','off');
setappdata(handles.Image2_axes,'crosshair_x_handle',image2x_line);
image2y_line = line([xval(floor(numel(xval)/2)) xval(floor(numel(xval)/2))], ...
    [yval(1) yval(end)], ...
    'Parent',handles.Image2_axes,'Color','k','Visible','off');
setappdata(handles.Image2_axes,'crosshair_y_handle',image2y_line);

function PlotContours(handles)
% Plot the images using contours
set(handles.Image1_table,'visible','off');
set(handles.Image2_table,'visible','off');
set(handles.image1info_text,'visible','on');
set(handles.image2info_text,'visible','on');
set(handles.Image1_axes,'visible','on');
set(handles.Image2_axes,'visible','on');
set(handles.SubImage1_axes,'visible','off');
set(handles.SubImage2_axes,'visible','off');
set(allchild(handles.SubImage1_axes),'visible','off');
set(allchild(handles.SubImage2_axes),'visible','off');
set(handles.xprofile_slider,'visible','off');
set(handles.xprofile_slider,'enable','off');
set(handles.yprofile_slider,'visible','off');
set(handles.yprofile_slider,'enable','off');
image1 = getappdata(handles.ImageCompare_fig,'image1');
image2 = getappdata(handles.ImageCompare_fig,'image2');
xval = getappdata(handles.ImageCompare_fig,'xvalues');
yval = getappdata(handles.ImageCompare_fig,'yvalues');
label1 = getappdata(handles.ImageCompare_fig,'label1');
label2 = getappdata(handles.ImageCompare_fig,'label2');
flipyaxis = getappdata(handles.ImageCompare_fig,'flipyaxis');
xaxislabel = getappdata(handles.ImageCompare_fig,'xlabel');
yaxislabel = getappdata(handles.ImageCompare_fig,'ylabel');
maxvalue = min(max(image1(:),max(image2(:))));
minvalue = 0.1*maxvalue;
ncontour = 8;
clevels = linspace(minvalue,maxvalue-minvalue/2,ncontour);
contour(xval, yval, image1,clevels,'Parent',handles.Image1_axes);
contour(xval, yval, image2,clevels,'Parent',handles.Image2_axes);
% May want to see about adding legend to show contour values here
% clabel is kind of ugly

% Contour y axis is reversed from other plots. Fix it here.
if flipyaxis
    set(handles.Image1_axes,'YDir','reverse');
    set(handles.Image2_axes,'YDir','reverse');
else
    set(handles.Image1_axes,'YDir','normal');
    set(handles.Image2_axes,'YDir','normal');
end
axis(handles.Image1_axes, 'image');
axis(handles.Image2_axes, 'image');
xlabel(handles.Image1_axes,xaxislabel);
ylabel(handles.Image1_axes,yaxislabel);
xlabel(handles.Image2_axes,xaxislabel);
ylabel(handles.Image2_axes,yaxislabel);
set(handles.image1_panel,'title',label1);
set(handles.image2_panel,'title',label2);

function PlotMesh(handles)
% Plot the images using contours
set(handles.Image1_table,'visible','off');
set(handles.Image2_table,'visible','off');
set(handles.image1info_text,'visible','on');
set(handles.image2info_text,'visible','on');
set(handles.Image1_axes,'visible','on');
set(handles.Image2_axes,'visible','on');
set(handles.SubImage1_axes,'visible','off');
set(handles.SubImage2_axes,'visible','off');
set(allchild(handles.SubImage1_axes),'visible','off');
set(allchild(handles.SubImage2_axes),'visible','off');
set(handles.xprofile_slider,'visible','off');
set(handles.xprofile_slider,'enable','off');
set(handles.yprofile_slider,'visible','off');
set(handles.yprofile_slider,'enable','off');
image1 = getappdata(handles.ImageCompare_fig,'image1');
image2 = getappdata(handles.ImageCompare_fig,'image2');
xval = getappdata(handles.ImageCompare_fig,'xvalues');
yval = getappdata(handles.ImageCompare_fig,'yvalues');
label1 = getappdata(handles.ImageCompare_fig,'label1');
label2 = getappdata(handles.ImageCompare_fig,'label2');
xaxislabel = getappdata(handles.ImageCompare_fig,'xlabel');
yaxislabel = getappdata(handles.ImageCompare_fig,'ylabel');
mesh(xval, yval, image1,'Parent',handles.Image1_axes);
mesh(xval, yval, image2,'Parent',handles.Image2_axes);
% axis(handles.Image1_axes, 'image');
% axis(handles.Image2_axes, 'image');
xlabel(handles.Image1_axes,xaxislabel);
ylabel(handles.Image1_axes,yaxislabel);
xlabel(handles.Image2_axes,xaxislabel);
ylabel(handles.Image2_axes,yaxislabel);
zlabel(handles.Image1_axes,'Image Signal');
zlabel(handles.Image2_axes,'Image Signal');
set(handles.image1_panel,'title',label1);
set(handles.image2_panel,'title',label2);

function DataTables(handles)
set(handles.Image1_table,'visible','on');
set(handles.Image2_table,'visible','on');
set(handles.image1info_text,'visible','off');
set(handles.image2info_text,'visible','off');
%set(handles.Image1_axes,'visible','off');
%set(handles.Image2_axes,'visible','off');
set(handles.SubImage1_axes,'visible','off');
set(handles.SubImage2_axes,'visible','off');
set(allchild(handles.SubImage1_axes),'visible','off');
set(allchild(handles.SubImage2_axes),'visible','off');
set(handles.xprofile_slider,'visible','off');
set(handles.xprofile_slider,'enable','off');
set(handles.yprofile_slider,'visible','off');
set(handles.yprofile_slider,'enable','off');
image1 = getappdata(handles.ImageCompare_fig,'image1');
image2 = getappdata(handles.ImageCompare_fig,'image2');
label1 = getappdata(handles.ImageCompare_fig,'label1');
label2 = getappdata(handles.ImageCompare_fig,'label2');
set(handles.Image1_table,'Data',image1);
set(handles.Image2_table,'Data',image2);
set(handles.image1_panel,'title',label1);
set(handles.image2_panel,'title',label2);

function PlotProfiles(handles)
% Plot the images using imagesc
set(handles.image1info_text,'visible','off');
set(handles.image2info_text,'visible','off');
set(handles.Image1_table,'visible','off');
set(handles.Image2_table,'visible','off');
set(handles.Image1_axes,'visible','on');
set(handles.Image2_axes,'visible','on');
set(handles.SubImage1_axes,'visible','on');
set(handles.SubImage2_axes,'visible','on');
set(handles.xprofile_slider,'visible','on');
set(handles.xprofile_slider,'enable','on');
set(handles.yprofile_slider,'visible','on');
set(handles.yprofile_slider,'enable','on');

image1 = getappdata(handles.ImageCompare_fig,'image1');
image2 = getappdata(handles.ImageCompare_fig,'image2');
xval = getappdata(handles.ImageCompare_fig,'xvalues');
yval = getappdata(handles.ImageCompare_fig,'yvalues');
label1 = getappdata(handles.ImageCompare_fig,'label1');
label2 = getappdata(handles.ImageCompare_fig,'label2');
xaxislabel = getappdata(handles.ImageCompare_fig,'xlabel');
yaxislabel = getappdata(handles.ImageCompare_fig,'ylabel');

% Get profile positions from slider
pixx = get(handles.xprofile_slider,'Value');
x0value = xval(round(pixx));
pixy = get(handles.yprofile_slider,'Value');
y0value = yval(round(pixy));

% Get profile positions from user
[numpixy numpixx] = size(image1);

% Valid pixels chosen for profiles at this point
% Compute profiles and display
xim1profile = improfile(image1,[1 numpixx],[pixy pixy],numpixx);
xim2profile = improfile(image2,[1 numpixx],[pixy pixy],numpixx);
plot(handles.SubImage1_axes,xval,[xim1profile,xim2profile]);
legend(handles.SubImage1_axes,label1,label2);
xlabel(handles.SubImage1_axes,xaxislabel);
%title(handles.SubImage1_axes,'X Profile')
%ylabel(handles.Image1_axes,'Fluence (cGy)')
yim1profile = improfile(image1,[pixx pixx],[1 numpixy],numpixy);
yim2profile = improfile(image2,[pixx pixx],[1 numpixy],numpixy);
plot(handles.SubImage2_axes,yval,[yim1profile,yim2profile]);
legend(handles.SubImage2_axes,label1,label2);
xlabel(handles.SubImage2_axes,yaxislabel);

% Get the line handles
h_image1_x = getappdata(handles.Image1_axes,'crosshair_x_handle');
h_image1_y = getappdata(handles.Image1_axes,'crosshair_y_handle');
h_image2_x = getappdata(handles.Image2_axes,'crosshair_x_handle');
h_image2_y = getappdata(handles.Image2_axes,'crosshair_y_handle');

% Update the line positions
set(h_image1_x,'XData',[xval(1) xval(end)]);
set(h_image1_x,'YData',[y0value y0value]);
set(h_image1_x,'visible','on');
set(h_image2_x,'XData',[xval(1) xval(end)]);
set(h_image2_x,'YData',[y0value y0value]);
set(h_image2_x,'visible','on');
set(h_image1_y,'XData',[x0value x0value]);
set(h_image1_y,'YData',[yval(1) yval(end)]);
set(h_image1_y,'visible','on');
set(h_image2_y,'XData',[x0value x0value]);
set(h_image2_y,'YData',[yval(1) yval(end)]);
set(h_image2_y,'visible','on');

%title(handles.SubImage2_axes,'Y Profile')
%ylabel(handles.Image2_axes,'Fluence (cGy)')
% set(handles.image1_panel,'title',['X Profile: y = ' num2str(y0value) ' cm']);
% set(handles.image2_panel,'title',['Y Profile: x = ' num2str(x0value) ' cm']);




% --- Executes on button press in gamma_pushbutton.
function gamma_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to gamma_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image1 = getappdata(handles.ImageCompare_fig,'image1');
image2 = getappdata(handles.ImageCompare_fig,'image2');
xp = getappdata(handles.ImageCompare_fig,'xvalues');
yp = getappdata(handles.ImageCompare_fig,'yvalues');
flipyaxis = getappdata(handles.ImageCompare_fig,'flipyaxis');

questionarray = {'Dose Tolerance (%)'; ...
    'Distance to Agreement (mm)'; ...
    'Calculation threshold (%)'};
defaultvalues = {'2';'2';'10'};

% Get the gamma settings from the user
answer = inputdlg(questionarray,'Gamma Settings',1,defaultvalues);

if ~isempty(answer)
    validdata = true;
    answernum = str2double(answer);
    if any(isnan(answernum))
        % Non-numeric entries
        validdata = false;
    else
        % All entries numeric
        if any(answernum<0)
            % Negative values
            validdata = false;
        else
            % All values positive
            dosetol = answernum(1);
            dta = answernum(2);
            thresh = answernum(3);

            % Ensure sane values
            if dosetol > 100
                dosetol = 100;
            end
            if thresh > 100
                thresh = 100;
            end
            % Determine search radius. Ensure that shift values up to and a
            % bit beyond the DTA are included
            res_x = xp(2) - xp(1);
            res_y = yp(2) - yp(1);
            radius_cm = dta/10*1.5;
            thresh = thresh/100;
            dosetol = dosetol/100;
            dta = dta/10;       % Convert to cm
            rad_pix = min(ceil(radius_cm/res_x),ceil(radius_cm/res_y));
            [gmap,npass,gmean,ncheck] = Gamma(image1,image2,xp,yp,dosetol,dta,thresh,rad_pix);
            
            % Construct textbox to include on graph
            totalpoints = numel(image1);
            graphlabel = {['Mean Gamma: ' num2str(gmean) '       ']; ...
                ['Pass fraction: ' num2str(npass) '      ']; ...
                ['Threshold Fraction: ' num2str(ncheck/totalpoints) '       ']};
            
            hplot = EImage(gmap,[xp(1) xp(end)],[yp(1) yp(end)],'Title','Gamma Map', ...
                'xlabel', 'x (cm)', 'ylabel', 'y (cm)','flipyaxis',flipyaxis);
            cmap = [ 0,0,0.7; 0,0,0.7; 0,0,1; 0,1,0; 0.7,1,0.2; 0.8,0,0]; % no orange
            colormap(hplot,cmap);
            caxis(hplot,[0,1.2]);
            colorbar('peer',hplot);
            
%             figure;
%             imagesc(gmap);
%             axis('image');
%             
%             cmap = [ 0,0,0.7; 0,0,0.7; 0,0,1; 0,1,0; 0.7,1,0.2; 0.8,0,0]; % no orange
%             colormap(cmap);  
%             caxis([0,1.2]); 
%             set(hgamma,'units','normalized');
%             text(0.75,0.75,graphlabel);
            
            %colorbar;
            msgbox(graphlabel,'Gamma Summary');
            
        end
        
    end
end


% --- Executes on button press in percentdiff_pushbutton.
function percentdiff_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to percentdiff_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Compute percent difference of the two images: (Im2 - Im1)/Im1*100
image1 = getappdata(handles.ImageCompare_fig,'image1');
image2 = getappdata(handles.ImageCompare_fig,'image2');
xp = getappdata(handles.ImageCompare_fig,'xvalues');
yp = getappdata(handles.ImageCompare_fig,'yvalues');
flipyaxis = getappdata(handles.ImageCompare_fig,'flipyaxis');

pd = (image2 - image1)./image1*100;

% Any zeros in image1 will give INF for percent difference. Replace these
% with zeros for percent difference
invalid = isinf(pd);
pd(invalid) = 0;

% Plot the result
EImage(pd,[xp(1) xp(end)],[yp(1) yp(end)],'Title','Percent Difference Map', ...
    'flipyaxis',flipyaxis);

% --- Executes on button press in roi_pushbutton.
function roi_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to roi_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in stats_pushbutton.
function stats_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to stats_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uitoggletool4_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in comparesettings_pushbutton.
function comparesettings_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to comparesettings_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uiprinttool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uiprinttool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Find and disable the controls on the GUI
%panels = [handles.PlotOptions_buttongroup;handles.stats_panel;handles.compare_panel];
%set(panels,'visible','off');

printpreview(handles.ImageCompare_fig);
%printdlg('-setup',handles.ImageCompare_fig);

%set(panels,'visible','on');

% --- Executes on slider movement.
function xprofile_slider_Callback(hObject, eventdata, handles)
% hObject    handle to xprofile_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
PlotProfiles(handles);


% --- Executes during object creation, after setting all properties.
function xprofile_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xprofile_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function yprofile_slider_Callback(hObject, eventdata, handles)
% hObject    handle to yprofile_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
PlotProfiles(handles);


% --- Executes during object creation, after setting all properties.
function yprofile_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yprofile_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes when selected cell(s) is changed in Image1_table.
function Image1_table_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to Image1_table (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uitoggletool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ratio_pushbutton.
function ratio_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to ratio_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Compute percent difference of the two images: (Im2 - Im1)/Im1*100
image1 = getappdata(handles.ImageCompare_fig,'image1');
image2 = getappdata(handles.ImageCompare_fig,'image2');
label1 = getappdata(handles.ImageCompare_fig,'label1');
label2 = getappdata(handles.ImageCompare_fig,'label2');
xp = getappdata(handles.ImageCompare_fig,'xvalues');
yp = getappdata(handles.ImageCompare_fig,'yvalues');
flipyaxis = getappdata(handles.ImageCompare_fig,'flipyaxis');

rat = image2./image1;

% Any zeros in image1 will give INF for ratio. Replace these
% with zeros for percent difference
invalid = isinf(rat);
rat(invalid) = 0;

% Plot the result
titlestring = ['Ratio ' label2 ' / ' label1];
EImage(rat,[xp(1) xp(end)],[yp(1) yp(end)], 'Title',titlestring,'flipyaxis',flipyaxis);


% --------------------------------------------------------------------
function savefigs_pushtool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to savefigs_pushtool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Export the images to separate figure windows for further manipulation
figure;
axes;
copyobj(allchild(handles.Image1_axes),gca);
title(get(handles.image1_panel,'Title'));
axis image

figure;
axes;
copyobj(allchild(handles.Image2_axes),gca);
title(get(handles.image2_panel,'Title'));
axis image

subimage1_vis = get(handles.SubImage1_axes,'visible');
if strmatch(subimage1_vis,'on')
    figure;
    copyobj(handles.SubImage1_axes,gcf);
    legend('show');
    %copyobj(allchild(handles.SubImage1_axes),gca);
end

subimage2_vis = get(handles.SubImage2_axes,'visible');
if strmatch(subimage2_vis,'on')
    figure;
    copyobj(handles.SubImage2_axes,gcf);
    legend('show');
    %copyobj(allchild(handles.SubImage2_axes),gca);
end



% --------------------------------------------------------------------
function editplots_toggletool_OnCallback(hObject, eventdata, handles)
% hObject    handle to editplots_toggletool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Find all of the controls, pushbuttons etc and disable them.
panels = [handles.PlotOptions_buttongroup;handles.stats_panel;handles.compare_panel];
set(panels,'visible','off');
propertyeditor(handles.ImageCompare_fig,'on');


% --------------------------------------------------------------------
function editplots_toggletool_OffCallback(hObject, eventdata, handles)
% hObject    handle to editplots_toggletool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
propertyeditor(handles.ImageCompare_fig,'off');
plotedit off
panels = [handles.PlotOptions_buttongroup;handles.stats_panel;handles.compare_panel];
set(panels,'visible','on');


% --------------------------------------------------------------------
function contrast_toggletool_OnCallback(hObject, eventdata, handles)
% hObject    handle to contrast_toggletool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Find all of the controls, pushbuttons etc and disable them.
panels = [handles.PlotOptions_buttongroup;handles.stats_panel;handles.compare_panel];
set(panels,'visible','off');
imhandle = findobj(handles.Image1_axes,'Type','image');
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

% Equalize contrast settings for both images. Update the contrast window so
% it is kept during later manipulations
imagewindow = get(handles.Image1_axes,'Clim');
setappdata(handles.ImageCompare_fig,'ContrastWindow',imagewindow);
set(handles.Image2_axes,'Clim',imagewindow);

% Re-enable the panel buttons
panels = [handles.PlotOptions_buttongroup;handles.stats_panel;handles.compare_panel];
set(panels,'visible','on');
