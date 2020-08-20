function varargout = GammaImage(varargin)
% GAMMAIMAGE M-file for GammaImage.fig
%      GAMMAIMAGE produces an extended image window that provides easy-access
%      to some more details image manipulation tools than the standard
%      image function. There is a main image axis, secondary plot axis and
%      a text box that can provide additional information about the image.
%
%      GammaImage processes all of the standard arguments of the Image function
%      and passes them through to plot the specified image in the Extended
%      image. It also recognizes an extra property value pair named 'Mode'
%      which can take the following values:
%           xprofile: show the x profile of the image in the secondary
%           window at startup
%           yprofile: show the y profile of the image in the secondary
%           window at startup
%           summary: show the summary information below the image
%
%      [H1 H2 H3] = GammaImage returns handles to the main window elements for
%      further customization as necessary.
%           H1: handle to the main image axes
%           H2: handle to the secondary plot axes
%           H3: handle to the summary information text box
%
%      GAMMAIMAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GAMMAIMAGE.M with the given input arguments.
%
%      GAMMAIMAGE('Property','Value',...) creates a new GAMMAIMAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GammaImage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GammaImage_OpeningFcn via varargin.
%

%
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GammaImage

% Last Modified by GUIDE v2.5 28-Apr-2017 11:36:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GammaImage_OpeningFcn, ...
                   'gui_OutputFcn',  @GammaImage_OutputFcn, ...
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


% --- Executes just before GammaImage is made visible.
function GammaImage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GammaImage (see VARARGIN)

% Choose default command line output for GammaImage
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
%imageargs = [imageargs 'Parent' handles.main_axes];

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

img=image(imageargs{:});

set(img,'Parent',handles.main_axes);

if p.Results.flipyaxis
    set(handles.main_axes,'YDir','reverse');
else
    set(handles.main_axes,'YDir','normal');
end
colorbar('peer',handles.main_axes);

axes(handles.main_axes);
image_data=p.Results.image;



cmap = [ 0,0,0.7; 0,0,0.7; 0,0,1; 0,1,0; 0.7,1,0.2; 0.8,0,0]; % no orange
 colormap(handles.main_axes,cmap);
 caxis(handles.main_axes,[0,1.2]);
 colorbar('peer',handles.main_axes);
xlabel(handles.main_axes,xlabel_str);
ylabel(handles.main_axes,ylabel_str);


% set Gamma summary

[infowindow_text,numpass] = CalculateSummaryData(image_data)

set(handles.infowindow_text,'String',infowindow_text);



% Update handles structure
guidata(hObject, handles);




% UIWAIT makes GammaImage wait for user response (see UIRESUME)
% uiwait(handles.Eimage_fig);

% setup image size.





% --- Outputs from this function are returned to the command line.
function varargout = GammaImage_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;
% Function will return handle for main axes, sub axes and information
% window
varargout{1} = handles.main_axes;
varargout{2} = handles.main_axes;
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

function gpassrate= calGammaPassRate2(imagedata)

Image1=imagedata;

%  make mask

Mask=ones(size(Image1));
crit_val = FE_thresh*MaxVal;

Mask(Image1>=crit_val) = 1;

Mask(Image1<crit_val)=-1;

% change Mask to logical values.
% Mask=logical(Mask);


% get gamma map less than threshold value.
% cutoff_gammamap=GammaMap(Mask);

cutoff_gammamap=GammaMap.*Mask;

% Account the total gamma map elements.
% numWithinField=numel(cutoff_gammamap);

numWithinField=numel(cutoff_gammamap(cutoff_gammamap>=0));

% get gamma value less than 1.
numpass=numel(cutoff_gammamap(cutoff_gammamap<=1 & cutoff_gammamap(cutoff_gammamap>=0 )))./numWithinField;


gpassrate=numpass;
        
        
        
        
        
        
        
function gpassrate= calGammaPassRate(imagedata)

% imagedata is masked gamma map using threshold. Out of threshold is zero.
% get mask for gamma image

% use gmap as images dataset.
% Mask = zeros(size(imagedata));
% 
% % critical_val=0.01*max(imagedata(:));  % changed from 10 to 1%.
% critical_val=0;
% Mask(imagedata>=critical_val) = 1;

numWithinField = nnz(imagedata);
%numpass = nnz(imagedata<1 & Mask)./numWithinField;

numpass=nnz(imagedata<1)./numWithinField;

avg = sum(imagedata(:))./numWithinField;

gpassrate=numpass;





% Compute the summary string to be placed in the information window
function [summarystring,numpass] = CalculateSummaryData2(imagedata,varargin)
% Compute some summary values
% imagedata is the whole gamma map with same size as tps data.

Image1=imagedata;

%  make mask

% Mask=ones(size(Image1));
% crit_val = FE_thresh*MaxVal;
% 
% Mask(Image1>=crit_val) = 1;
% 
% Mask(Image1<crit_val)=-1;

% change Mask to logical values.
% Mask=logical(Mask);


% get gamma map less than threshold value.
% cutoff_gammamap=GammaMap(Mask);

% cutoff_gammamap=GammaMap.*Mask;

cutoff_gammamap=imagedata;

% Account the total gamma map elements.
% numWithinField=numel(cutoff_gammamap);

tmp=cutoff_gammamap(cutoff_gammamap>=0);


numWithinField=numel(cutoff_gammamap(cutoff_gammamap>=0));

% get gamma value less than 1.
% numpass=numel(cutoff_gammamap(cutoff_gammamap<=1 & cutoff_gammamap(cutoff_gammamap>=0 )))./numWithinField;
numpass=numel(tmp(tmp<=1))/numWithinField;


% 
% numWithinField = nnz(Mask);
% numpass = nnz(imagedata<=1 & Mask)./numWithinField;

% avg = sum(imagedata(:))./numWithinField;

avg=sum(cutoff_gammamap(cutoff_gammamap>=0))./numWithinField;


pass_gamma_num=numel(tmp(tmp<=1));

minimage=min(tmp(:));

maximage=max(tmp(:));

% Construct summary string
% summarystring = {'Gamma Map Statistics'; ['Minimum Value: ' num2str(minimage)]; ...
%     ['Maximum Value: ' num2str(maximage)]; ['Mean Value: ' num2str(meanimage)]; ...
%     ['Median Value: ' num2str(medimage)]; ['Standard Deviation: ' num2str(devimage)];...
%     ['Gamma range (0-1)percentage:' num2str(numpass*100) '%'];...
%     ['Gamma range (>1) percentage:' num2str((1-numpass)*100) '%']...
%     }
summarystring = {'Gamma Criteria:3mm/3% of maximum TPS dose and 10% threshold';...
                 'Gamma Map Statistics'; ...
                 ['Total gamma pixel number: ',num2str(numWithinField)];
                 ['Passed gamma pixel number(gamma<1):', num2str(pass_gamma_num)];
                 ['Minimum Value: ' num2str(minimage)]; ...
    ['Maximum Value: ' num2str(maximage)]; ['Mean Value: ' num2str(avg)]; ...
    ['Gamma range (0-1):' num2str(numpass*100) '%'];...
    ['Gamma range (>1):' num2str((1-numpass)*100) '%']...
    };


% Compute the summary string to be placed in the information window
function [summarystring,numpass] = CalculateSummaryData(imagedata,varargin)
% Compute some summary values

% imagedata is the threshold cutoff gamma map.
threshed_gamampa=imagedata;

% only account the masked values.
tmp_imagedata=imagedata(imagedata>0);

minimage = min(tmp_imagedata(:));

if minimage<0
    
  minimage=0;
  
end 


maximage = max(tmp_imagedata(:));
meanimage = mean(tmp_imagedata(:));
% medimage = median(imagedata(:));
% devimage = std(imagedata(:));
[ypix xpix] = size(imagedata);

% get mask for gamma image

% use gmap as images dataset.
% Mask = zeros(size(imagedata));


% critical_val=0.01*max(imagedata(:));  % changed from 10 to 1%.

% critical_val=0;
% 
% Mask(imagedata>=critical_val) = 1;

numWithinField = nnz(imagedata);

% numpass = nnz(imagedata<1 & Mask)./numWithinField;

pass_gamma_num=nnz(tmp_imagedata<1);
numpass = nnz(tmp_imagedata<1)./numWithinField;

avg = sum(tmp_imagedata(:))./numWithinField;



% Construct summary string
% summarystring = {'Gamma Map Statistics'; ['Minimum Value: ' num2str(minimage)]; ...
%     ['Maximum Value: ' num2str(maximage)]; ['Mean Value: ' num2str(meanimage)]; ...
%     ['Median Value: ' num2str(medimage)]; ['Standard Deviation: ' num2str(devimage)];...
%     ['Gamma range (0-1)percentage:' num2str(numpass*100) '%'];...
%     ['Gamma range (>1) percentage:' num2str((1-numpass)*100) '%']...
%     }
summarystring = {'Gamma Criteria:3mm/3% of maximum TPS dose and 10% threshold';...
                 'Gamma Map Statistics'; ...
                 ['Total gamma pixel number: ',num2str(numWithinField)];
                 ['Passed gamma pixel number(gamma<1):', num2str(pass_gamma_num)];
                 ['Minimum Value: ' num2str(minimage)]; ...
    ['Maximum Value: ' num2str(maximage)]; ['Mean Value: ' num2str(avg)]; ...
    ['Gamma range (0-1):' num2str(numpass*100) '%'];...
    ['Gamma range (>1):' num2str((1-numpass)*100) '%']...
    };




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
%     copyobj(handles.sub_axes,gcf);
    %legend('show');
    %copyobj(allchild(handles.SubImage1_axes),gca);
end
