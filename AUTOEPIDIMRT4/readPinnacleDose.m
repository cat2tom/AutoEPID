function [row1,col1, dose_plane2]=readPinnacleDose(pin_dose_file_name)

% input: pin_dose_file_name-the name of xio dose file
% output: dose_plane-a matlab matrix containg the dose plane data in Gy 
%         row1 and col1 -the number of points in x and y directions.

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

