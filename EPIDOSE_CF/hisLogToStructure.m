
function his_file_structure=hisLogToStructure(his_log_file)

  
% form a cell containing his file name,  Pixel factor, image uid, patient name,
% machine name

  his_log_file_list=readHISLog(his_log_file);
  
  tmp_file_name=getHISFileName(his_log_file_list);
  
  tmp_pixel_factor=getFramePixelFactor(his_log_file_list);
  
  tmp_image_uid=getHISImageUID(his_log_file_list);
  
  tmp_patient_name=getHISPatientName3(his_log_file_list);
  
  tmp_treatment_name=getHISTreatmentName(his_log_file_list);
  
  tmp_station_name=getHISStationName(his_log_file_list);
  
  tmp_field_name=getHISFieldName(his_log_file_list);
  
  his_structure=struct('file_name',{},'pixel_factor',{},'patient_name',{},...
      'treatment_name', {},'field_name',{},'image_uid',{},'station_name',{});
      
  
  for i=1:length(tmp_file_name)
      
     his_structure(i).file_name=tmp_file_name{i};
     his_structure(i).pixel_factor=tmp_pixel_factor(i);
     his_structure(i).patient_name=tmp_patient_name{i};
     
     his_structure(i).treatment_name=tmp_treatment_name{i};
   
     his_structure(i).field_name=tmp_field_name{i};
     
     his_structure(i).image_uid=tmp_image_uid{i};
     
     his_structure(i).station_name=tmp_station_name;
     
  end 
  
  his_file_structure=his_structure;
     
     
    
      
      
      