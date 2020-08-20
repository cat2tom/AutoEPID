function cf_factor= getCalibrationFactorFromRefField(handles )
%{
 Description: Given a reference field,calculate the CF
 
 Inpout: handles-the handles from main GUI.

 output: cf_factor-calibration factor.
   
%}

% choose which TPS first
      
  tps=questdlg('Which TPS system was used for this patient IMRT planning?',...
          'Choose TPS','Xio','Pinnacle','Pinnacle');
      

% then chose directory


current_dir='U:\\Patient_QA\\';

dir_path=uigetdir(current_dir,'Choose a Patient directory'); % ask user to select directory

cd(dir_path);







end

