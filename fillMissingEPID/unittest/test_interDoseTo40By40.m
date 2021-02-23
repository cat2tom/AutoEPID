tps_dose_file='1113318_VMAT_dosemapTEST__EPIDQA_312-132B.txt';

[xgrid,ygrid, dose_plane2]=readPinnacleDoseMissing(tps_dose_file);





% figure;
% 
% imagesc(dose_plane2);

dose_matrix=dose_plane2;

[Ex,Ey,inter_dose ] = interDoseTo40by40(xgrid,ygrid,dose_matrix );

figure;

imagesc(inter_dose);


[Ex,Ey,extended_epiddose]= extendEPIDImagem(inter_dose,inter_dose ); 


figure;

imagesc(inter_dose);