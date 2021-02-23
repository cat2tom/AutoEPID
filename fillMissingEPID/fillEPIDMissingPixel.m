function [Ex,Ey,extended_epiddose]=fillEPIDMissingPixel(tps_dose_file,epiddose)
% Calculate the distance from iso to the pixel point. 
% Input: tps_dose_file: 
% ouput: iso_distance[m]: matrix 

% read in the dose and x/y

% EPID active area: 409.6mm X 409.6mm. The distance is 160cm. The ratio is
% 100/160=0.625. 
%At isocenter, is 256mm X 256mm.  half size is :128mm.(12.8cm).
% resolution: 0.253mm.
% dist_threshold=12.8; %cm.
% 
% resolution=0.253;% at isocenter.

tps_file_in=tps_dose_file;

epiddose_in=epiddose;

max_epid_dose=max(epiddose_in(:));

[dist_vect,dose_vect,row_cor,col_cor]=calIsoDistTPS(tps_file_in);


% converted from tps dose to epiddsoe using 

coverted_tps_dose=dose_vect/max(dose_vect(:))*max_epid_dose;

coverted_tps_dose(1:10)


selected_point_index=dist_vect>=12.8;


selected_row=row_cor(selected_point_index);

selected_col=col_cor(selected_point_index);

% converted into mm and into epid matrix row,col number. 

missing_epid_row_index=int16(selected_row*10/0.253)+512;

missing_epid_col_index=int16(selected_col*10/0.253)+512;


missing_epiddose=coverted_tps_dose(selected_point_index);


% fill the missing epiddose

for k=1:length(missing_epid_row_index)
    
    row_index=missing_epid_row_index(k)
    
    col_index=missing_epid_col_index(k)
    
    missing_epiddose(k)
    
    if row_index<0
        
       row_index=abs(row_index);
    end   
    
    if col_index<0
        
       col_index=abs(col_index);
        
    end 
    
    if row_index>2048
        
        row_index=2048;
    end 
    
     if col_index>2048
        
        col_index=2048;
    end 
    
    epiddose(row_index,col_index)=missing_epiddose(k);
    
end 

% epiddose(missing_epid_row_index,missing_epid_col_index)=missing_epiddose;

extended_epiddose=epiddose;

[row,col]=size(extended_epiddose);


% make sure the epiddose size is even

if isodd(row)
    
    extended_epiddose(end+1,:)=0;
    
end 
    

if isodd(col)
    
    extended_epiddose(:,end+1)=0;
    
end    
    

[new_row,new_col]=size(extended_epiddose);


Ex=(-(new_col/2):(new_col/2))*0.253;

Ey=(-(new_row/2):(new_row/2))*0.253;


end

