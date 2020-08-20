% test data

log_struct=struct();

log_struct(1).file_name='c:\test1.txt';

log_struct(1).machine='m1';

log_struct(2).file_name='c:\test2.txt';

log_struct(2).machine='m2';

% test function

log_struct_array=log_struct;
epid_full_file_name='c:\test2.txt';


epid_log_struct=getEPIDLogStruct(log_struct_array,epid_full_file_name )