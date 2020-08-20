function flipDicomUpDown(dicom_file_name)

  info=dicominfo(dicom_file_name);
  data=dicomread(dicom_file_name);
  data2=flipud(data);
  dicomwrite(data2,dicom_file_name,info,'CreateMode','copy');