function [xgrid,ygrid, dose_plane]=readXioDose2(xio_dose_file_name)

% input: xio_dose_file_name-the name of xio dose file
% output: dose_plane-a matlab matrix containg the dose plane data in Gy 
%         xgrid and ygrid -the number of points in x and y directions.

s={}; 
fid = fopen(xio_dose_file_name);
tline = fgetl(fid); 
while ischar(tline)   
    s=[s;tline];   
    tline = fgetl(fid);
end 

% get the dose data into a cell array

dose_cell=s(17:end);

% get dose x and y dimension

y_size=length(dose_cell);

% get first cell containing the first line

first_dose_line1=s(17);

first_dose_line2=first_dose_line1{1};

first_dose_line3=str2num(first_dose_line2);

x_size=length(first_dose_line3);

dose_plane=zeros(x_size,y_size);

for i=1:length(dose_cell)
    
    tmp=dose_cell(i);
    tmp2=tmp{1};
    
    dose_plane(:,i)=str2num(tmp2);
end 

xgrid2=x_size;
ygrid2=y_size;

ygrid=((1:x_size)-x_size/2)*0.1;
xgrid=((1:y_size)-y_size/2)*0.1;

fclose(fid);

