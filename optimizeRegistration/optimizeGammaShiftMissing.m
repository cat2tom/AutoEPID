function [max_gamma,max_gamma_map] =optimizeGammaShift(reference,target,opt_row_shift,opt_col_shift)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



% shift_length=3;% 10cm shift.
% 
% row_shift_vect=-shift_length:shift_length;
% 
% col_shift_vect=-shift_length:shift_length;

%%
% 3mm in 0.5 step 



% row_shift_vect=(opt_row_shift-3):0.5:(opt_row_shift+3);
% 
% col_shift_vect=(opt_col_shift-3):0.5:(opt_col_shift+3);

row_shift_vect=(opt_row_shift-3):0.5:(opt_row_shift+3);

col_shift_vect=(opt_col_shift-3):0.5:(opt_col_shift+3);


%%
row_length=length(row_shift_vect);
col_length=length(col_shift_vect); 

total_loop=row_length*col_length;


progressbar('Filling the missing EPID pixel value, Please wait.....');


% gamma paramters 

Dose_tol=0.03;% 3%.
DTA_tol=3;

FE_thresh=8/100; % threshold.

% FE_thresh=4/100;
rad=3*DTA_tol;

Xpoints=1:50;% not really used. 
Ypoints=1:50;

max_gamma=0;

max_gamma_map=[];

for k= 1:col_length
    
%    progressbar(k/col_length);
   for  m=1:row_length;
       
       current_loop=(k-1)*length(col_shift_vect)+m;
       
%        progressbar(m/row_length);
    
       progressbar(current_loop/total_loop);
       
       Image1=reference;
       trans=[k,m];
       Image2=imageTranslate(target,trans,1,'nearest');
    
      [GammaMap2,numpass, avg, numWithinField] = Gamma(Image1, Image2, Xpoints, Ypoints, Dose_tol, DTA_tol, FE_thresh, rad);
      
      numpass
      
      if numpass>max_gamma
          
          max_gamma=numpass; 
          
          max_gamma_map=GammaMap2;
          
          
      end 
  
    
       
   end 
    
      
end 



end

