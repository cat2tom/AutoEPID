
function beam_name_dicom_file_list=renameEPIDDicomFile2(epid_file_list)

% rename the EPID dicom file name using gantry angle.

%read dicom image

beam_name_dicom_file_list={};

for i=1:length(epid_file_list)
    
    
    tmp=epid_file_list{i}
    
    header=dicominfo(tmp); %save dicom info


    header.NumberOfFrames=1;

% get patient information


%    gantry_angle=header.GantryAngle;
% 
%    gantry_angle2=num2str(gantry_angle);
   
   beam_name=header.RTImageLabel;
   tmp_index=findstr(':',beam_name);

   beam_name2=beam_name(1:tmp_index-1);
   
   new_name=[beam_name2 '.dcm'];
   
   movefile(tmp,new_name);
   
%    delete tmp;
   
   beam_name_dicom_file_list{i}=new_name;
   
   
end 



 




