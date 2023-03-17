
% set the file name

configFileName='V:\CTC-LiverpoolOncology-Physics\IMRT\PatientQA\autoEPIDConfigfile\autoEPIDDirConfig.ini';

% test function.

[deleteNetWork,mapNetWork,patientInputDir,dicomTemplateDir,imrtOutputDir,vmatOutputDir,epidCalFile,version_info,escan_dir,backupPatientInputFolder,patient_mat_dir,jar_dir] = readAutoEPIDConfigFile(configFileName)
