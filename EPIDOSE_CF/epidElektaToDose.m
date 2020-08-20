
function epidElektaToDose(epid_file_name,log_file_name)


%By P. Vial and modified by Aitang
%this code opens a dicom EPID image, converts it to double
%generates an integral pixel map of the composite IMRT image
%converts the image to dose and displays it

%read dicom image

newpath=epid_file_name;

header=dicominfo(newpath); %save dicom info
ElektaEPIDimage=dicomread(header); %save image (includes image of each segment + composite image)
DI = double(ElektaEPIDimage);%convert 16bit data to double

%invert and offset data into correct format
DI=-(DI-2^16);

%get PSF from log file (1/no. of frames)

logfile_name=log_file_name;

inverse_frame=getFrameNumber(logfile_name); % function reading PSF from logfile

PSF =inverse_frame; 

%integrate pixel values
DISum = DI/PSF;
 
%calibrate to dose. units pix/cGy at reference condition - isocentre, 5.4
%cm depth, 10x10 cm jaw settings

machine=header.StationName;

M1_PixelCalFact=0.0001045387; %measured 22/5/2012 P.Vial
M2_PixelCalFact=0.0001045387; %measured 22/5/2012 P.Vial
PixelCalFact=M1_PixelCalFact;

if strcmp(machine,'M1_IVIEW')
   
    
     PixelCalFact=M1_PixelCalFact;
end 
    
if strcmp(machine,'M2_IVIEW')
   
    
     PixelCalFact=M2_PixelCalFact;
end 
   
 
%M2_PixelCalFact=0.0001045387; %measured
DoseImage=DISum*PixelCalFact; %final dose image to be used for analysis

% convert from double into 16 bit integer

DoseImage2=uint16(round(DoseImage));

% Write the dose image into a dicom file which can be loaded into OmniPro
% for analysis.

% get patient name

family_name=header.PatientName.FamilyName;
given_name=header.PatientName.GivenName;

gantry_angle=header.GantryAngle;

gantry_angle2=num2str(gantry_angle);

[dir_path,filename,ext]=fileparts(epid_file_name);

head_data=dicominfo(epid_file_name);

epid_image_uid=head_data.SOPInstanceUID;

EPID_dose_name=[family_name ' ' given_name '_' 'Gantry  '  gantry_angle2  '_' 'ImageUID '  epid_image_uid   '_Elekta EPID Dose'  ext];

dicomwrite(DoseImage2,EPID_dose_name,header,'CreateMode','copy');

end 
