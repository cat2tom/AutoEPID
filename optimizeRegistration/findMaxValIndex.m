function [x_max,y_max ] =findMaxValIndex(matrix)
% FindMaxValIndex find the colum and row index corresponding the maximum
% value of the matrrix. 
% Input: matrix
% output: x_max-col index
%         y_max-row index.

[max_num,max_idx] =max(matrix(:));

[y_max, x_max]=ind2sub(size(matrix),max_idx);


end

