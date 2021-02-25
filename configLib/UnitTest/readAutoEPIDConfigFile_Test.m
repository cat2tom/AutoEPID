
% set the file name

configFileName='C:\AitangResearch\inHouseSoftWare\AutoEPID\configLib\TestFile\autoEPIDDirConfig.ini';

% test function.

[deleteNetWork,mapNetWork,patientInputDir,dicomTemplateDir,imrtOutputDir,vmatOutputDir,epidCalFile,version_info,escan_dir,backupPatientInputFolder] = readAutoEPIDConfigFile(configFileName)
