function [deleteNetWork,mapNetWork,patientInputDir,dicomTemplateDir,imrtOutputDir,vmatOutputDir,epidCalFile,version_info,escan_dir,backupPatientInputDir,patient_mat_dir, jar_dir] = readAutoEPIDConfigFile(conFigFileName )
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

% SharedNetWorkDriver Section.

[keys, ~] = ini.GetKeys(sections{1});
values=ini.GetValues(sections{1}, keys);

deleteNetWork=values{1}; 
mapNetWork=values{2};

% DefaultPatientInputFolder Section

[keys, ~] = ini.GetKeys(sections{2});
values= ini.GetValues(sections{2}, keys);

patientInputDir=values{1};

backupPatientInputDir=values{2};

% DICOMTemplateFolder section
[keys, ~] = ini.GetKeys(sections{3});
values= ini.GetValues(sections{3}, keys);

dicomTemplateDir=values{1};

% IMRTOutPutFolder section

[keys, ~] = ini.GetKeys(sections{4});
values= ini.GetValues(sections{4}, keys);

imrtOutputDir=values{1};

% VMATOutPutFolder section

[keys, ~] = ini.GetKeys(sections{5});
values= ini.GetValues(sections{5}, keys);

vmatOutputDir=values{1};

% vmatOutputDir

[keys, ~] = ini.GetKeys(sections{6});
values= ini.GetValues(sections{6}, keys);

epidCalFile=values{1};

% version info

[keys, ~] = ini.GetKeys(sections{7});
values= ini.GetValues(sections{7}, keys);

version_info=values{1};

% escan
[keys, ~] = ini.GetKeys(sections{8});
values= ini.GetValues(sections{8}, keys);

escan_dir=values{1};

% patient mat dir
[keys, ~] = ini.GetKeys(sections{9});
values= ini.GetValues(sections{9}, keys);

patient_mat_dir=values{1};

% jar dir 

[keys, ~] = ini.GetKeys(sections{10});
values= ini.GetValues(sections{10}, keys);

jar_dir=values{1};

end

