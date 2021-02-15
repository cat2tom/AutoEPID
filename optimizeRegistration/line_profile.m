I = imread('liftingbody.png');
% imshow(I);
% x = [1 512];
% y = [1 1];

% I=[1,3,6;
%    8,5,20];


ref_image=I;

tar_image=imageTranslate(I,[10,8]);

[shifted_tar_image,xshift,yshift] = optimizeImageRegistration(ref_image,tar_image );

xshift

yshift

imshow(I);

figure;

imshow(tar_image);

figure;

imshow(shifted_tar_image);


% [xx_cor,xy_cor,x_pixel,yx_cor,yy_cor,y_pixel ] = getMaxValProfile(I ); 

% [x_max,y_max ] =findMaxValIndex(I)
% 
% [row,col]=size(I);
% 
% xprof_x=[1 col];
% xprof_y=[y_max y_max];
% 
% [x_cor,~,x_pixel] = improfile(I,xprof_x,xprof_y);

% figure;
% 
% plot(x_cor,x_pixel);

% 
% yprof_x=[x_max x_max];
% yprof_y=[1 row];
% 
% [~,y_cor,y_pixel] = improfile(I,yprof_x,yprof_y);

% figure;
% 
% plot(y_cor,y_pixel);

% Image1=x_pixel; 
% Image2=x_pixel;

% Xpoints=xx_cor;
% Ypoints=xy_cor;
% Dose_tol=0.03;
% FE_thresh=0.1;

DTA_tol=3; 

rad=6; 

% [GammaMap2, numpass, avg, numWithinField] = Gamma(Image1, Image2, Xpoints, Ypoints, Dose_tol, DTA_tol, FE_thresh, rad)

% x_cor=xx_cor;
% y_cor=yy_cor;
% pixel_1=x_pixel; 
% pixel_2=y_pixel;
% 
% trans=[11,0];

% shifted_pixel_test=imageTranslate(x_pixel,trans);
% 
% 
% reference_pixel_vect=x_pixel;
% target_pixel_val=shifted_pixel_test;
% 
% 
% optimal_shift =optimizeProfileShift(x_cor,y_cor,reference_pixel_vect,target_pixel_val );
% 
% optimal_shift




% 
% 
% asize=length(shifted_pixel_test); 
% 
% 
% 
% half_size=0;
% 
% shift_vect=[];
% 
% if rem(asize,2)==0
%     
%     half_size=asize/2;
%     shift_vect=-half_size:(half_size-1);
%     
% else
%     half_size=(asize-1)/2;
%     
%     shift_vect=-half_size:half_size;
% end 
% 
% 
% shift_vect=[-wrev(1:asize) 0 1:asize];
% 
% gamma_array=[];
% for k= 1:length(shift_vect)
%     
%     shift=shift_vect(k);
%     trans=[shift,0];
%     
%     shifted_pixel_2=imageTranslate(shifted_pixel_test,trans);
%     
%     gamma= get1DGammaRate(x_cor,y_cor,pixel_1,shifted_pixel_2 );
%     
%     gamma_array(k)=gamma;
%     
%    
%     
%     
%     
% end 
% 
% max_index=findMaxValIndex(gamma_array)


% 
% opt_shift=shift_vect(max_index);
% if opt_shift>0
%     
%     opt_shift3=shift_vect(max_index+2)
%     
% else
%     
%     opt_shift3=shift_vect(max_index-2)
    
% end 
% 
% if rem(asize,2)==0
%   opt_shift=shift_vect(max_index-2);
%   
% else
%     
%   opt_shift=shift_vect(max_index-1);
%     
% end 

% trans_test=[opt_shift,0];
% 
% shifted_pixel_3=imageTranslate(shifted_pixel_test,trans_test);
% 
% plot(x_cor,pixel_1);
% 
% hold on;
% 
% plot(x_cor,shifted_pixel_3);
% optimal_shift =optimizeProfileShift(reference_pixel_vect,target_pixel_val )


% pixel_2=shifted_pixel;



%figure;



%gamma_rate = get1DGammaRate(x_cor,y_cor,pixel_1,pixel_2 );

% plot(x_cor,pixel_1);
% 
% hold on;
% plot(x_cor,pixel_2);
% 



% [cx,cy,c] = improfile(I,x,y);
% 
% figure;
% 
% 
% plot(cx,c);