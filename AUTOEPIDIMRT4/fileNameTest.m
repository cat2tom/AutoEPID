a='Beam_G260.0_C0.0-TotalDose.txt';

tmp1=findstr('-',a)

tmp2=findstr('_',a)


[a,b]=findGangtryandCollimatorAngleFromPinTPSFile(a)