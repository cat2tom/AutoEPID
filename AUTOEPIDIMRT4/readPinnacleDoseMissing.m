function [xgrid,ygrid, dose_plane2]=readPinnacleDoseMissing(pin_dose_file_name)

% This is the version used for reading dose files from Pinnalce. 
  

% input: pin_dose_file_name-the name of xio dose file
% output: dose_plane-a matlab matrix containg the dose plane data in Gy 
%         row1 and col1 -the number of points in x and y directions.

% function test

% pin_dose_file_name='pin.txt';
s={}; 
fid = fopen(pin_dose_file_name);
tline = fgetl(fid); 
while ischar(tline)   
    s=[s;tline];   
    tline = fgetl(fid);
end 

% get the dose data into a cell array

dose_cell=s(12:end);

% get dose row and col dimension

row=length(dose_cell);

% get first cell containing the first line

first_dose_line1=s(12);

first_dose_line2=first_dose_line1{1};

first_dose_line3=str2num(first_dose_line2);

y0=first_dose_line3(1)

ygrid=(y0:0.1:-y0)';

xcor_line=s(11);
xcor_line2=s{11};
xcor_line3=str2num(xcor_line2);

x0=xcor_line3(1);

xgrid=(x0:0.1:-x0)';






col=length(first_dose_line3);

dose_plane=zeros(row,col);

for i=1:length(dose_cell)
    
    tmp=dose_cell(i);
    tmp2=tmp{1};
    dose_plane(i,:)=str2num(tmp2);
end 

row1=row;
col1=col-1;

dose_plane2=dose_plane(:,2:end);

% [m,n]=size(dose_plane2);

% ygrid=(-m/2+1:m/2)';
% xgrid=(-n/2+1:n/2)';
% convered into mm from cm to mm
xgrid=xgrid*10;
ygrid=ygrid*10;

% converted dose to cgray.

dose_plane2=dose_plane2*100;




