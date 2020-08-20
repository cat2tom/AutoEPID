function mainConfigs= readMainConfigFileMO(mainConfigFileName )
%{

Read main configuration from configure file for automMonthly QA.

Input: mainConfigFileName-path included file name for where all configures
are.

output: mainConfigs-a cell structure containing the following elements.

        configFileSE-configure for SE seqences.
       
        configFileGE-configure for GE sequence
        
        configFileDixon-configure for DIXON

        configFileUTE-configue for UTE.



%}

% initilize the class object
ini = IniConfig();

ini.ReadFile(mainConfigFileName);

sections = ini.GetSections();

% section 1 SE.

[keys, ~] = ini.GetKeys(sections{1});
values=ini.GetValues(sections{1}, keys);

configFileSE=values{1};

% secton 2 GE

[keys, ~] = ini.GetKeys(sections{2});
values= ini.GetValues(sections{2}, keys);

configFileGE=values{1};


% secton 3 Dixon  .
[keys, ~] = ini.GetKeys(sections{3});
values= ini.GetValues(sections{3}, keys);

configFileDIXON=values{1};

% section 4. UTE

[keys, ~] = ini.GetKeys(sections{4});

values= ini.GetValues(sections{4}, keys);

configFileUTE=values{1};

% put all the values into a cell data structrues.

mainConfigs={configFileSE,configFileGE,configFileDIXON,configFileUTE};
end

