
function [xgrid_epid,ygrid_epid,epiddose]=epidElektaDicomToDose(epid_image_file)
%By P. Vial and modified by Aitang
%this code opens a dicom EPID image, converts it to double
%generates an integral pixel map of the composite IMRT image
%converts the image to dose and displays it

%read dicom image
warning off 
newpath = epid_image_file;
header=dicominfo(newpath); %save dicom info
SiemensEPIDimage=dicomread(header); %save image (includes image of each segment + composite image)
DI = double(SiemensEPIDimage);%convert 16bit data to double

%SID distance from the dicom header
SID = double(char(header.RTImageSID)); %may be used for XY dimension scaling

% get the col and row form header

row=header.Rows;
col=header.Columns;
res=header.ImagePlanePixelSpacing;

position=header.RTImagePosition;

% res=[0.408,0.408];

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

% xgrid_epid2=xgrid_epid1*res(1)*1000/SID;
% 
% ygrid_epid2=ygrid_epid1*res(2)*1000/SID;

xgrid_epid2=xgrid_epid1*res(1);

ygrid_epid2=ygrid_epid1*res(2);


xgrid_epid=xgrid_epid2(2:end);

ygrid_epid=ygrid_epid2(2:end);

% xgrid_epid=xgrid_epid';
% 
% ygrid_epid=ygrid_epid';

%  DoseImage3=flipud(DoseImage2);


 DI=imrotate(DI,-180,'bilinear','loose');

 epiddose=DI;

end

