
opgFileName='Imported Fluence 001.opg';


fluenceMap=readOPGFluence(opgFileName);

tmp_max=max(fluenceMap(:));

fluenceMap=fluenceMap./tmp_max;
tmp3=0.1*tmp_max;
tmp2=fluenceMap(fluenceMap>tmp3);
total_pixel=numel(tmp2(:))
