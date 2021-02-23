function [dist_vect,dose_vect,row_cor,col_cor]=calculateIsoDistanceDoseMatrix(x_cor,y_cor,dose_matrix)
% Calculate the distance from iso to the pixel point. 
% Input: tps_dose_file: 
% ouput: dist_vect: the distance for each pixe;



 dose_matrix_in=dose_matrix;

% sorted the pixe(dose ) 
 
 [sorted_dose,linear_index] = sort( dose_matrix_in(:),'descend');
 
 [row_index_vect, col_index_vect]=ind2sub(size(dose_matrix_in),linear_index(:));
 
 row_cor=y_cor(row_index_vect);
 
 col_cor=x_cor(col_index_vect);
 
 dist_vect=sqrt(x_cor(col_index_vect).^2+y_cor(row_index_vect).^2);
 
 dose_vect=sorted_dose;
 
 

end

