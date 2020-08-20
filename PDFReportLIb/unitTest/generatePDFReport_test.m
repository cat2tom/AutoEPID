loadItextJarFiles;
% prepare the dummy data required.
 %% dumy gammaSummaryS
gammaSummaryS=struct();

gammaSummaryS(1).beam_name='101';

gammaSummaryS(1).m3p3_gamma=96.7;
gammaSummaryS(1).m2p2_gamma=92.3;
gammaSummaryS(1).mean_gamma_m2p2=1.2;
gammaSummaryS(1).mean_gamma_m3p3=1;


gammaSummaryS(2).beam_name='102';
gammaSummaryS(2).m3p3_gamma=95.7;
gammaSummaryS(2).m2p2_gamma=92.3;
gammaSummaryS(2).mean_gamma_m2p2=1.2;
gammaSummaryS(2).mean_gamma_m3p3=1;


gammaSummaryS(3).beam_name='102';
gammaSummaryS(3).m3p3_gamma=95.7;
gammaSummaryS(3).m2p2_gamma=92.3;
gammaSummaryS(3).mean_gamma_m2p2=1.2;
gammaSummaryS(3).mean_gamma_m3p3=1;

gammaSummaryS(4).beam_name='102';
gammaSummaryS(4).m3p3_gamma=95.7;
gammaSummaryS(4).m2p2_gamma=92.3;
gammaSummaryS(4).mean_gamma_m2p2=1.2;
gammaSummaryS(4).mean_gamma_m3p3=1;


gammaSummaryS(5).beam_name='102';
gammaSummaryS(5).m3p3_gamma=95.7;
gammaSummaryS(5).m2p2_gamma=92.3;
gammaSummaryS(5).mean_gamma_m2p2=1.2;
gammaSummaryS(5).mean_gamma_m3p3=1;


gammaSummaryS(6).beam_name='102';
gammaSummaryS(6).m3p3_gamma=95.7;
gammaSummaryS(6).m2p2_gamma=92.3;
gammaSummaryS(6).mean_gamma_m2p2=1.2;
gammaSummaryS(6).mean_gamma_m3p3=1;

%% dumy gammaProfileS
gammaProfileS(1).beam_name='101';

gammaProfileS(1).profile_image_file_name=which('profile.jpg');
gammaProfileS(1).gamma_image_file_name=which('gamma.jpg');

gammaProfileS(2).beam_name='102';

gammaProfileS(2).profile_image_file_name=which('profile.jpg');
gammaProfileS(2).gamma_image_file_name=which('gamma.jpg');

%% patient infomation


patient_name='tom,cat';

mrn='123456';
machine='M1';

physicist='ax';

pdf_path_file_name='AutoEPIDTest.pdf';

pdf_cal='0.0015';

pdf_cal_date='12/12/2018';

version_info='V4';

comments='These are comments';

% test fucntion

pdf_path_file_name=generatePDFReport(pdf_path_file_name,patient_name,mrn,machine,physicist,pdf_cal,pdf_cal_date,gammaSummaryS,gammaProfileS,version_info,comments);

