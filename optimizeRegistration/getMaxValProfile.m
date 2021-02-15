function [xx_cor,xy_cor,x_pixel,yx_cor,yy_cor,y_pixel ] = getMaxValProfile(matrix )
%getMaxValProfile return the profile cordinates passing the maximum value
%of a given matrix and return the cors and pixel intensities. 
%   

I=matrix;
[x_max,y_max ] =findMaxValIndex(I); 

[row,col]=size(I);

xprof_x=[1 col];
xprof_y=[y_max y_max];

[xx_cor,xy_cor,x_pixel] = improfile(I,xprof_x,xprof_y);


yprof_x=[x_max x_max];
yprof_y=[1 row];

[yx_cor,yy_cor,y_pixel] = improfile(I,yprof_x,yprof_y);




end

