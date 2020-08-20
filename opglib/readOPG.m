function [xgrid,ygrid, dose_plane2]=readOPG(rs_dose_file_name)

% Read opg file export from OminPro separated using comma.


% read all lines into a cell array.

s={};
fid = fopen(rs_dose_file_name);
tline = fgetl(fid);
while ischar(tline)
    s=[s;tline];
    tline = fgetl(fid);
end


% get dose cell

doseCell=s(19:end-14);

row=length(doseCell);


% x coordinates

x_line_cell=s{17};% x coordinaes is at line 17.

x_cell=x_line_cell(8:end);% remove the X[cm].

xgrid=str2num(x_cell);

col=length(xgrid);


numPlane=zeros(row,col+1);

for i=1:length(numPlane)
    
    tmp=doseCell(i);
    tmp2=tmp{1};
    
    numPlane(i,:)=str2num(tmp2);
end

dosePlane=numPlane(:,2:end);

ygrid=numPlane(:,1);

ygrid=ygrid';
dose_plane2=dosePlane;

xgrid=xgrid';
ygrid=ygrid';


end






