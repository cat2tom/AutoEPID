function optimal_shift =optimizeProfileShift(x_cor,y_cor,reference_pixel_vect,target_pixel_vect )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


asize=length(reference_pixel_vect); 

shift_vect=[-wrev(1:asize) 0 1:asize];

%loop through to get gamma array. 
gamma_array=[];

progressbar('Optimizing the profile shift,Please wait.....');

m=length(shift_vect);

for k= 1:length(shift_vect)
    
    progressbar(k/m);, 
    
    shift=shift_vect(k);
    trans=[shift,0];
    
    shifted_pixel=imageTranslate(target_pixel_vect,trans);
    
    gamma= get1DGammaRate(x_cor,y_cor,reference_pixel_vect,shifted_pixel );
    
    gamma_array(k)=gamma;
    
      
end 

max_index=findMaxValIndex(gamma_array);



opt_shift=shift_vect(max_index);
if opt_shift>0
    
    opt_shift3=shift_vect(max_index+2);
    
else
    if max_index-2>=0
    opt_shift3=shift_vect(max_index-2);
    else
    opt_shift3=shift_vect(max_index);   
    end 
    
end 

optimal_shift=opt_shift3;

end

