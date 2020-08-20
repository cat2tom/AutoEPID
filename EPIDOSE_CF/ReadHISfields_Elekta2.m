%By P. Vial and modified by Aitang
%this code opens a dicom EPID image, converts it to double
%generates an integral pixel map of the composite IMRT image
%converts the image to dose and displays it

%read dicom image
[FILENAME, dicompath] = uigetfile('*.dcm','Choose Elekta dicm template '); %select file
cd(dicompath);% add the selected path to the searched paths
newpath = [dicompath FILENAME];
header=dicominfo(newpath);

[file_name2, hispath] = uigetfile('*.HIS','Choose a HIS file'); %select file
cd(hispath)
his_path=[hispath file_name2]

ElektaEPIDimage=readHISfile(his_path); %readHISfile returns image
DI = double(ElektaEPIDimage);%convert 16bit data to double

%invert and offset data into correct format
DI=-(DI-2^16);

%get PSF from log file (1/no. of frames)

%[FILENAME2, logpath] = uigetfile('*.LOG','Choose log file'); %select file
%cd(logpath);% add the selected path to the searched paths
%logfile_name = [dicompath FILENAME2];

%inverse_frame=getFrameNumber(logfile_name); % function reading PSF from logfile

inverse_frame=0.023;
PSF =inverse_frame; 

%integrate pixel values
DISum = DI/PSF;
 
%calibrate to dose. units pix/cGy at reference condition - isocentre, 5.4
%cm depth, 10x10 cm jaw settings
M1_PixelCalFact=0.0001045387; %measured 22/5/2012 P.Vial
%M2_PixelCalFact=0.0001045387; %measured
DoseImage=DISum*M1_PixelCalFact; %final dose image to be used for analysis

% convert from double into 16 bit integer

DoseImage2=uint16(round(DoseImage));

% Write the dose image into a dicom file which can be loaded into OmniPro
% for analysis.

dicomwrite(DoseImage2,'Elekta_EPID_Dose_for OmniPro.dcm',header,'CreateMode','copy');
% display the image in matlab window to compare it with one displayed in Omnipro.
imagesc(DoseImage2);figure(gcf);


