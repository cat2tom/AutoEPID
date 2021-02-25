function [clinical_configFile,beta_configFile] = readAutoEPIDRootConfigFile(conFigFileName )
%{

Read configuration from configure file for the program. 

Input: configFileName-path included file name

output: imDir-where the images were sent.
        dbPath,dbName-the database path and name
        pdfDir-direcotry where pdf reports are save.
        
        qaTrackExe-path and exe file name
        matFile-file path and name to record the history of processing

        jarPath-direcotry where java files are instored.
        

%}

% initilize the class object
ini = IniConfig();

ini.ReadFile(conFigFileName);

sections = ini.GetSections();

% configure file section.

[keys, ~] = ini.GetKeys(sections{1});
values=ini.GetValues(sections{1}, keys);

clinical_configFile=values{1}; 
beta_configFile=values{2};


end

