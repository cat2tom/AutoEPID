old_hisfile='FIELD_1.HIS';

new_hisfile='NEWFIELD_3.HIS';

im_data=readHISfile(old_hisfile);


write2HISFile(old_hisfile,new_hisfile,im_data);


new_imdata=readHISfile(new_hisfile);



figure

imagesc(old_imdata)

figure
imagesc(new_imdata)



