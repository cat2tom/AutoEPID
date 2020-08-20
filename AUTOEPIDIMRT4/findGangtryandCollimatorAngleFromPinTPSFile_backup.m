


function  [gang_angle,coll_angle]=findGangtryandCollimatorAngleFromPinTPSFile(new_tps_file_name)



tmp1_index=findstr('-',new_tps_file_name); 

tmp2=findstr('_',new_tps_file_name);

tmp2_index4=tmp2(end-1);

tmp3_index5=tmp2(end);


coll_angle=new_tps_file_name(tmp3_index5+1:tmp1_index-1);

coll_angle=deblank(coll_angle);

coll_angle2=sscanf(coll_angle,'%*1c%f');


gang_angle=new_tps_file_name(tmp2_index4+1:tmp3_index5-1);

gang_angle=deblank(gang_angle);

gang_angle2=sscanf(gang_angle,'%*1c%f');

gang_angle=gang_angle2;

coll_angle=coll_angle2;


