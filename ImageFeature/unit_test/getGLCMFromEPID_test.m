% runing from test dir.

cd .. % back one up level from unit_test.

test_file_name='Field_1.HIS';

test_file_dir=fullfile(pwd,'test_file',test_file_name);

[GLCM_EPIDS,epid_dose] = getGLCMFromEPID(test_file_dir);

