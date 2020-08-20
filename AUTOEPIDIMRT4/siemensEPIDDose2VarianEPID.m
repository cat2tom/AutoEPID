function xio_plane_dose_dcm=siemensEPIDDose2VarianEPID(simens_epid_dose)

% convert the xio dose txt file into dicom file using eclipse dicom as
% template
% input: xio_tps_file-the dose plane file from xio
% output: xio_plane_dose_dcm-the converted dose in dcm format.

%   [row1,col1,dose_plane2]=readXioDose(xio_tps_file);

 
  s_header=dicominfo(simens_epid_dose);
  
  siemens_epid_dose=dicomread(simens_epid_dose);
  % get eclipse header
  
  [row1,col1]=size(siemens_epid_dose);
  e_header=dicominfo('varian_template.dcm');
  
   
  e_header.ImagePlanePixelSpacing=s_header.ImagePlanePixelSpacing;
    
  e_header.Rows=s_header.Rows;
  e_header.Columns=s_header.Columns;

  e_header.RTImageSID=s_header.RTImageSID;
  
  scale_slope=e_header.RescaleSlope;
  
  scale_inter=e_header.RescaleIntercept;
  
  xio_dcm_name='siemen_varian_epid.dcm';
  
%   dose_plane2=int16(dose_plane2*100);

  siemens_epid_dose1=double(siemens_epid_dose);
  
  siemens_epid_dose=siemens_epid_dose1;
  
  siemens_epid_dose=siemens_epid_dose;

  dicomwrite(siemens_epid_dose,xio_dcm_name,e_header,'CreateMode','copy');
  
  xio_plane_dose_dcm=xio_dcm_name;
  