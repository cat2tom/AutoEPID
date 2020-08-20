
function gantry_angle_dicom_file_list=renameEPIDDicomFile(epid_file_list)

% rename the EPID dicom file name using gantry angle.

%read dicom image

gantry_angle_dicom_file_list={}

for i=1:length(epid_file_list)
    
    
    tmp=epid_file_list{i}
    
    header=dicominfo(tmp); %save dicom info


    header.NumberOfFrames=1;

% get patient information


   gantry_angle=header.GantryAngle;

   gantry_angle2=num2str(gantry_angle);
   
   new_name=[gantry_angle2 '.dcm'];
   
   movefile(tmp,new_name);
   
   delete tmp;
   
   gantry_angle_dicom_file_list{i}=new_name;
   
   
end 



 




