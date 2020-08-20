
% set the file name

configFileName='H:\IMRT\PatientQA\AUTOEPIDRESOURCE\autoEPIDDirConfig.ini';

% test function.

[deleteNetWork,mapNetWork,patientInputDir,dicomTemplateDir,imrtOutputDir,vmatOutputDir,epidCalFile,version_info] = readAutoEPIDConfigFile(configFileName)
