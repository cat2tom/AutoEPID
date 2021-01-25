
function elektaHISToDosePinnacle5_CFM(header, his_structure_array,pixel_to_dose_factor,epid_file)

% input: his_structure-one element of structure
%        header-the header information of template Elekta dicom image.
%        his_dir_parth-the directory where his files sit 
% output: a series of dose image 

warning off

% his_file_name2=his_structure.file_name;

epid_full_file_name=epid_file;

log_struct_array= his_structure_array;
his_structure=getEPIDLogStruct(log_struct_array,epid_full_file_name );


%index=findstr('.',his_file_name);

%fist_part=his_file_name(1:index-1);

PSF=his_structure.pixel_factor;

his_image_uid=his_structure.image_uid;

his_patient_name=his_structure.patient_name;

his_station_name=his_structure.station_name;

his_treatment_name=his_structure.treatment_name;

his_field_name=his_structure.field_name;


ElektaEPIDimage=readHISfile(epid_full_file_name); %readHISfile returns image
DI = double(ElektaEPIDimage);%convert 16bit data to double

%invert and offset data into correct format

% only inverted for M1 but not for M2

% if strcmp(his_station_name,' M2-IVIEW')
%      
%     DI=-(DI-2^16); 
%  
% end


DI=-(DI-2^16);


%integrate pixel values
DISum = DI/PSF;
 
%calibrate to dose. units pix/cGy at reference condition - isocentre, 5.4
%cm depth, 10x10 cm jaw settings

% M1_PixelCalFact=0.0001045387; %measured 22/5/2012 P.Vial
% M2_PixelCalFact=0.0001045387; %measured
% 
% PixelCalFact=M1_PixelCalFact;
% 
% if strcmp(his_station_name,' M1-IVIEW')
%     
%    
%     PixelCalFact=M1_PixelCalFact;
%     
% end
% 
% if strcmp(his_station_name,' M2-IVIEW')
%     
%     PixelCalFact=M2_PixelCalFact;
% 
% end   

PixelCalFact=pixel_to_dose_factor;


DoseImage=DISum*PixelCalFact; %final dose image to be used for analysis

% convert from double into 16 bit integer

DoseImage2=uint16(round(DoseImage));

% final dose image name

% epid_dose_image_name=[ 'Patient ' his_patient_name...
%                      '_Treatment ' his_treatment_name ...
%                      '_Field '  his_field_name...
%                      '_ImageUID ' his_image_uid...
%                      '_Machine ' his_station_name ...
%                      '.dcm'];


% get the full path and file name and use name1 to make a file name for
% converted dicom dose file.

his_file_name=epid_full_file_name;

[path1,name1,ext1]=fileparts(his_file_name);

% epid_dose_image_name1=[ name1 '_'  his_field_name...
%                        '_Treatment ' his_treatment_name ...
%                        '_Patient ' his_patient_name...
%                        '_' his_station_name ...
%                        '.dcm'];
                 
epid_dose_image_name1=[ 'Field '  his_field_name...
                       '_Treatment ' his_treatment_name ...
                       '_Patient ' his_patient_name...
                       '_' his_station_name ...
                       '.dcm'];
% full path name to the ouput dcm file


epid_dose_image_name=fullfile(pwd,epid_dose_image_name1); 


                   
dicomwrite(DoseImage2,epid_dose_image_name,header,'CreateMode','copy');


% rescaled the dose image

 machine_name=his_station_name

 dicomImageResize3ScaleFactor(epid_dose_image_name, machine_name);
 
 % move dicom image origin
 
 dicomMoveOrigin3(epid_dose_image_name);
 
 % turn image to 90 degree for pinalce
 
 %dicomImageTurn90(epid_dose_image_name);

 


