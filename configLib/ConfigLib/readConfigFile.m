function [imDir,dbPath,dbName,pdfDir,qaTrackExe,matFile,jarPath,dbJarFile,tolFile,qaExcel] = readConfigFile(conFigFileName )
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

% section 1.

[keys, ~] = ini.GetKeys(sections{1});
values=ini.GetValues(sections{1}, keys);

imDir=values{1};

% secton 2

[keys, ~] = ini.GetKeys(sections{2});
values= ini.GetValues(sections{2}, keys);

dbPath=values{1};

dbName=values{2};

% secton 3.
[keys, ~] = ini.GetKeys(sections{3});
values= ini.GetValues(sections{3}, keys);

pdfDir=values{1};

% section 4.

[keys, ~] = ini.GetKeys(sections{4});
values= ini.GetValues(sections{4}, keys);

qaTrackExe=values{1};

% section 5. 

[keys, ~] = ini.GetKeys(sections{5});
values= ini.GetValues(sections{5}, keys);

matFile=values{1};

% section 6
[keys, ~] = ini.GetKeys(sections{6});
values= ini.GetValues(sections{6}, keys);

jarPath=values{1};

dbJarFile=values{2};

% section 7

  [keys, ~] = ini.GetKeys(sections{7});
  values= ini.GetValues(sections{7}, keys);
 
  tolFile=values{1};
%secton 8
 [keys, ~] = ini.GetKeys(sections{8});
 values= ini.GetValues(sections{8}, keys);
 
 qaExcel=values{1};

end

