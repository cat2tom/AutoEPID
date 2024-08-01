

jar_dir='V:\CTC-LiverpoolOncology-Physics\IMRT\PatientQA\autoEPIDConfigfile\itextJarFiles';

if ~(ismcc || isdeployed)

javaaddpath(fullfile(jar_dir,'itextpdf-5.5.7.jar'));

javaaddpath(fullfile(jar_dir,'itext-pdfa-5.5.7.jar'));

javaaddpath(fullfile(jar_dir,'itext-xtra-5.5.7.jar'));

javaaddpath(fullfile(jar_dir,'itext-xtra-5.5.7.jar'));
end 

