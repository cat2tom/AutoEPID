function [xgrid,ygrid,xiodose]=readXioDose(xio_dose_file_name)

% input: xio_dose_file_name-the name of xio dose file
% output: dose_plane-a matlab matrix containg the dose plane data in Gy 
%         xgrid and ygrid-row vector for storing x and y coordinates.

s={}; 
fid = fopen(xio_dose_file_name);
tline = fgetl(fid); 
while ischar(tline)   
    s=[s;tline];   
    tline = fgetl(fid);
end 

% get central axis index

tmp_axis=s(13);

tmp_axis2=tmp_axis{1};

tmp_axis_index=findstr(',',tmp_axis2);

tmp_x=tmp_axis2(tmp_axis_index(1):tmp_axis_index(2));
tmp_y=tmp_axis2(tmp_axis_index(2)+1:end);

centcol=str2num(tmp_x);
centrow=str2num(tmp_y);

% get the dose data into a cell array

dose_cell=s(17:end);

% get dose resolution

resolution_line=s(16);

resolution_line2=resolution_line{1};

tmp2_index=findstr(',',resolution_line2);

res=resolution_line2(tmp2_index+1:end);

resolution=str2num(res);

% get dose row and col dimension

row=length(dose_cell);

% get first cell containing the first line

first_dose_line1=s(17);

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
col1=col;

xiodose=double(dose_plane)*100;

% centrow=row1/2
% centcol=col1/2

tmp_row=1:row1;
tmp_col=1:col1;

tmp_row=tmp_row;
tmp_col=tmp_col;


xgrid=double(tmp_col-centcol)*resolution/10; % convert into cm

ygrid=double((tmp_row-centrow))*resolution/10; % convert into cm

xgrid=xgrid';
ygrid=ygrid';

fclose(fid);
