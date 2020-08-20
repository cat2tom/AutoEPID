
function [xgrid_epid,ygrid_epid,epiddose,gamma_image_name]=epidSiemensToDoseXio8(epid_image_file,pixel_to_dose_factor)
%By P. Vial and modified by Aitang
%this code opens a dicom EPID image, converts it to double
%generates an integral pixel map of the composite IMRT image
%converts the image to dose and displays it

%read dicom image
warning off 
newpath = epid_image_file;
header=dicominfo(newpath); %save dicom info
SiemensEPIDimage=dicomread(header); %save image (includes image of each segment + composite image)
DI = double(SiemensEPIDimage(:,:,1,1));%convert 16bit data to double


%number of frames from dicom header
[frames,frame_2]= getSiemensSubFrameNumber(epid_image_file);

frames=double(frames);

totalframes=sum(frames);%total frames for composite image
%SID distance from the dicom header
SID = double(char(header.RTImageSID)); %may be used for XY dimension scaling

% get the col and row form header

row=header.Rows;
col=header.Columns;
res=header.ImagePlanePixelSpacing;

position=header.RTImagePosition;


% xpos=position(1);
% 
% ypos=position(2);
% xgrid_epid=(xpos:res(1):-xpos)*0.1*100/SID;
% 
% ygrid_epid=(-ypos:res(2):ypos)*0.1*100/SID;
% 
% assignin('base','row',row)


xgrid_epid1=(-double(col)/2):double(col)/2;
ygrid_epid1=(-double(row)/2):double(row)/2;

% rescaled to 100 cm SSD from the imaging plane

xgrid_epid2=xgrid_epid1*res(1)*100/SID;

ygrid_epid2=ygrid_epid1*res(2)*100/SID;

xgrid_epid=xgrid_epid2(2:end);

ygrid_epid=ygrid_epid2(2:end);

%integrate pixel values
DISum = DI*totalframes;
 
%calibrate to dose. units pix/cGy at reference condition - isocentre, 5.4
%cm depth, 10x10 cm jaw settings
machine=header.RadiationMachineName;
% 
%  M3_145cm_PixelCalFact=0.000043545; %measured 21/5/2012 P. Vial
%  M5_150cm_PixelCalFact=0.00005093; %measured 23/5/2012 P.Vial
%  
%  PixelCalFact=M5_150cm_PixelCalFact; 
% if strcmp(machine,'M3')
%     
%    
%     PixelCalFact=M3_145cm_PixelCalFact;
% end 
% 
% if strcmp(machine,'M5')
%       
%     PixelCalFact=M5_150cm_PixelCalFact;
% end 

PixelCalFact=pixel_to_dose_factor;

% final dose image 
DoseImage=DISum*PixelCalFact;

% change final dose from double into 16 bit integer

DoseImage2=uint16(round(DoseImage));

%write final dose to RT dicom image which can loaded into OminPro for analysis

%only one frame was used and change the frame number to one.
header.NumberOfFrames=1;

% get patient information

family_name=header.PatientName.FamilyName;
mrn=header.PatientID;
gantry_angle=header.GantryAngle;

gantry_angle2=num2str(gantry_angle);

aquisition_time=header.AcquisitionTime;
beam_name=header.RTImageLabel;
tmp_index=findstr(':',beam_name);

beam_name2=beam_name(1:tmp_index-1);


% epid_dose_name=[family_name '_MRN ' mrn '_Gantry ' gantry_angle2 '_' machine '_Simens EPID dose' '.dcm'];
epid_dose_name=['Beam  ' beam_name2  '_Gantry ' gantry_angle2 '_Patient ' family_name '_MRN ' mrn '_' machine   '_'  aquisition_time     '_EPID dose' '.dcm'];

gamma_image_name=['Beam  ' beam_name2  '_Gantry ' gantry_angle2 '_Patient ' family_name '_MRN ' mrn '_' machine];


% write the final dicom dose into dicom format which can be loaded into
% Ominpro for analysis.

% dicomwrite(DoseImage2,epid_dose_name,header,'CreateMode','copy');

% rescaled the dose image

%  dicomImageResize3(epid_dose_name);
 
% move dicom image origin
 
%  dicomMoveOrigin3(epid_dose_name);
 
 % flip dicom up and down for xio
 
%  flipDicomUpDown(epid_dose_name);
 
 
%  DoseImage3=flipud(DoseImage2);
 epiddose=double(DoseImage);

end

