reference=imread('cameraman.tif');

trans=[10,20];

target=imageTranslate(reference,trans);

[max_gamma,max_gamma_map] =optimizeGammaShift(reference,target,10,20);