opg_file='miller.opg';

[xgrid1,ygrid1, dose_plane3]=readOPG(opg_file);


figure

imshow(dose_plane3)