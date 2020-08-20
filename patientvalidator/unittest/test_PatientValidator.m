
test_dir='C:\AitangResearch\inHouseSoftWare\AutoEPIDQA\patientvalidator\testdata\0467670_FARNHAM';

% test constructor

PatientValidator_obj=PatientValidator(test_dir);

% test get property

PatientValidator_obj.patient_folder;

% test if there are folders 

is_exist=PatientValidator_obj.subFoldersExist(); 

% test no folders 

no_folder=' C:\AitangResearch\inHouseSoftWare\AutoEPIDQA\patientvalidator\testdata\0467670_FARNHAM_NoFolders  ';

PatientValidator_obj=PatientValidator(no_folder);

is_exist=PatientValidator_obj.subFoldersExist();



