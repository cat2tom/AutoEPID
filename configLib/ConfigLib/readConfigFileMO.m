function dirs = readConfigFileMO(conFigFileName )
%{

Read configuration from configure file for automMonthly QA.

Input: configFileName-path included file name

output: dirs-a cell structure containing the following elements.

        imDir-where the images were sent.
        tmpTxtFile-file recording the updated and new QA resutls for QA
        track.
        recordTxtFile-txt file for holding all QA resutls like database.
        
        matFile-file path and name to record the history of processing

        headCell-the cell holding the title.
        

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

tmpTxtFile=values{1};


% secton 3.
[keys, ~] = ini.GetKeys(sections{3});
values= ini.GetValues(sections{3}, keys);

recordTxtFile=values{1};

% section 4.

[keys, ~] = ini.GetKeys(sections{4});
values= ini.GetValues(sections{4}, keys);

headCell={values{1},values{2},values{3},values{4},values{5},values{6},values{7}};


% section 5. 

[keys, ~] = ini.GetKeys(sections{5});
values= ini.GetValues(sections{5}, keys);

matFile=values{1};

% put all the values into a cell data structrues.

dirs={imDir,tmpTxtFile,recordTxtFile,headCell,matFile};
end

