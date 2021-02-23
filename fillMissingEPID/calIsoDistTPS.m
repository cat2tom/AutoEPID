function [dist_vect,dose_vect,row_cor,col_cor]=calIsoDistTPS(tps_dose_file)
% Calculate the distance from iso to the pixel point. 
% Input: tps_dose_file: 
% ouput: iso_distance[m]: matrix 

% read in the dose and x/y

tps_file_in=tps_dose_file;

[xgrid,ygrid,tpsdose]=readPinnacleDose3(tps_file_in);

x_cor=xgrid;
y_cor=ygrid;
dose_matrix=tpsdose;

[dist_vect,dose_vect,row_cor,col_cor]=calculateIsoDistanceDoseMatrix(x_cor,y_cor,dose_matrix);
 

end

