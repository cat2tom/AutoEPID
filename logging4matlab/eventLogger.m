function eventLogger(varargin)
% Event stores the current execution log to a text file log.txt, reports
% the event to the command prompt.  If varargin{2} is ERROR, will also 
% throw an error
%
% The following variables are required for proper execution: 
%   str: event to be logged (without final newline)
%   varargin{2} (optional): varargin{2} of event (INFO, WARN, ERROR, etc) 
%   varargin{3} (optinal): the progam's name or app name.
%   guihandle (optional): handle to uitable handle to display events
%
% Author: Mark Geurts, mark.w.geurts@gmail.com and modified by Aitang Xing
% Copyright (C) 2015 University of Wisconsin Board of Regents
%
% This program is free software: you can redistribute it and/or modify it 
% under the terms of the GNU General Public License as published by the  
% Free Software Foundation, either version 3 of the License, or (at your 
% option) any later version.
%
% This program is distributed in the hope that it will be useful, but 
% WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General 
% Public License for more details.
% 
% You should have received a copy of the GNU General Public License along 
% with this program. If not, see http://www.gnu.org/licenses/.

% Set GUI handle to be persistent between calls

% set log file name and path to tempdir by default.

% usage: 

% One arg: 

% eventLogger('the network connection is established')

%Two args

% eventLogger('WARN', 'This is a warning')

% Three args: 

% eventLogger('INFO','THIS IS for a program called AutoEPID', 'AutoEPID')

% For all above situations, eventLogger will write to a consoel and a temporary file to 
% system tempdir. If the third option is provided, it make a subdolder named as app under tempdir and then 
% write the log file to this folder. This feature is very convenient for a project. As you can use it anywhere in your 
% program or project. 




logfile_name=fullfile(tempdir,'log.txt');


persistent handle;

% If only one input was provided, assume varargin{2} is INFO
if nargin == 1
    
      
    logfile_name=fullfile(dir_log,'log.txt');
    
    varargin{2} = 'INFO';
    
    
end


% If three inputs were provided, update the persistent handle object

% if nargin == 3
%     handle = varargin{3};
%    
% end

if nargin==3
    
    app_name=varargin{3}; % application name.
    
    log_path=fullfile(tempdir,app_name);
    
    if ~exist(log_path,'dir')
        
        mkdir(log_path);
    end 
    
      logfile_name=fullfile(tempdir,app_name,'log.txt');
        
end 

% added caller informaton and line informaton

[caller_info, line_info]=getCallerInfo(); 

caller_string=strcat({ strcat(caller_info,'.m')}, {' '} , {'line:'} ,{num2str(line_info)},{' '});

combined_string=[caller_string{1}  varargin{1}];

% Split multi-line inputs into a cell array of strings
str = strsplit(combined_string,'\n');

% Use try-catch statement to determine if file write was successful.  If
% not, still write event to stdout but inform that the file write write was
% unsuccessful.


try
    % Attempt to obtain a write handle to the log file
    fid = fopen(logfile_name,'a');
    
    % Also append event to log
    fprintf(fid, '%s\t%s\t%s\n', datestr(now,'yyyy-mm-dd HH:MM:SS'), ...
        varargin{2}, str{1});
    
    % If multiple lines exist in the event
    for i = 2:size(str,2)
        % If the line is not empty, write additional line tab-justified
        % with first line
        if ~strcmp(str{i}, ''); fprintf(fid, '\t\t\t\t%s\n', str{i}); end
    end
    
    % Close file handle
    fclose(fid);
    
    % Write event to stdout
    fprintf('%s\t%s\t%s\n', datestr(now,'yyyy-mm-dd HH:MM:SS'), ...
        varargin{2}, str{1});
    
    % AX: write the event to progress monitor
  
    
    % If multiple lines exist in the event
    for i = 2:size(str,2)
        % If the line is not empty, write additional line tab-justified
        % with first line
        if ~strcmp(str{i}, ''); fprintf('\t\t\t\t%s\n', str{i}); end
    end
    
    % If UI handle is present, add event to UI cell string
    if ~isempty(handle) && strcmp(varargin{2},'ERROR')
        % If error, add event in red
        set(handle, 'Data', vertcat({['<html><font color="red">', ...
            datestr(now,'yyyy-mm-dd HH:MM:SS'),'</font></html>'], ...
            ['<html><font color="red">',varargin{2},'</font></html>'], ...
            ['<html><font color="red">',str{1},'</font></html>']}, ...
            get(handle, 'Data')));
    elseif ~isempty(handle) && strcmp(varargin{2},'WARN')
        % If warn, add event in orange
        set(handle, 'Data', vertcat({['<html><font color="orange">', ...
            datestr(now,'yyyy-mm-dd HH:MM:SS'),'</font></html>'], ...
            ['<html><font color="orange">',varargin{2},'</font></html>'], ...
            ['<html><font color="orange">',str{1},'</font></html>']}, ...
            get(handle, 'Data')));
    elseif ~isempty(handle)
        % Otherwise, add event in green
        set(handle, 'Data', vertcat({['<html><font color="green">', ...
            datestr(now,'yyyy-mm-dd HH:MM:SS'),'</font></html>'], ...
            ['<html><font color="green">',varargin{2},'</font></html>'], ...
            ['<html><font color="green">',str{1},'</font></html>']}, ...
            get(handle, 'Data')));
    end
    
% Catch an exception that may be thrown if write handle could not be set
catch
    % Write event to stdout
    fprintf('%s\t%s\t%s [not written to log]\n', ...
        datestr(now,'yyyy-mm-dd HH:MM:SS'), varargin{2}, str{1});
    
    % If multiple lines exist in the event
    for i = 2:size(str,2)
        % If the line is not empty, write additional line tab-justified
        % with first line
        if ~strcmp(str{i}, ''); fprintf('\t\t\t\t%s\n', str{i}); end
    end
    
    % If UI handle is present, add event to UI cell string in black
    if ~isempty(handle)
        set(handle, 'Data', vertcat({datestr(now,'yyyy-mm-dd HH:MM:SS'), ...
            varargin{2}, [str,' [not written to log]']}, get(handle, 'Data')));
    end
end

% If the event varargin{2} was error, also throw error
if strcmp(varargin{2},'ERROR') 
     errordlg(varargin{1});
     error(varargin{1});
end

% Clear temporary variables
clear str;


end 
% utility function


function [name, line] = getCallerInfo()
      
      if nargin > 0 
          name = [];
          line = [];
          return
      end
      [ST, ~] = dbstack();
      offset = min(size(ST, 1), 3);
      name = ST(offset).name;
      line = ST(offset).line;
end

