function [Ex,Ey,inter_dose ] = interDoseTo40by40(x_cor,y_cor,dose_matrix )
%Interpolate dose over domain x_cor and y_cor into 400mX400mm domain. 
%Input: x_grid[grid]/y_grid[grid]: x, y cordinate in mm.
%        dose_matrix[m]: dose array in cGy. 
%outpu: 
%      Ex/Ey: grid in mm from -200:200mm in step of 1mm.
%      inter_dose[m]: interpolated dose in cGy. 


% get  grid points over 400mm X 400 mm and converted to double.

x=-200:200; % mm (col)
y=-200:200; % mm. (row)

[xgrid_out,ygrid_out]=meshgrid(x,y);

xgrid_out=double(xgrid_out);
ygrid_out=double(ygrid_out);

[xgrid_in,ygrid_in]=meshgrid(x_cor,y_cor);



% filling out domain with 0.

inter_dose=interp2(xgrid_in,ygrid_in,dose_matrix,xgrid_out,ygrid_out,'nearest');

Ex=xgrid_out;
Ey=xgrid_out;


end

