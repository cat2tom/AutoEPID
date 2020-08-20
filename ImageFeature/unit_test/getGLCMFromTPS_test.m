% runing from test dir.

cd .. % back one up level from unit_test.

test_file_name='0466626_Beam_245_102_G245.0_C0.0-TotalDose.txt';

test_file_dir=fullfile(pwd,'test_file',test_file_name);

[GLCM_EPIDS,tps_dose] = getGLCMFromTPS(test_file_dir);

