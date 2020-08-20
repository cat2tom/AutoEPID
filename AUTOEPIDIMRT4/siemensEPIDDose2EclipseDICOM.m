function xio_plane_dose_dcm=siemensEPIDDose2EclipseDICOM(simens_epid_dose)

% convert the xio dose txt file into dicom file using eclipse dicom as
% template
% input: xio_tps_file-the dose plane file from xio
% output: xio_plane_dose_dcm-the converted dose in dcm format.

%   [row1,col1,dose_plane2]=readXioDose(xio_tps_file);

 
  s_header=dicominfo(simens_epid_dose);
  
  siemens_epid_dose=dicomread(simens_epid_dose);
  % get eclipse header
  
  [row1,col1]=size(siemens_epid_dose);
  e_header=dicominfo('eclipse_template.dcm');
  
  e_header.MediaStorageSOPClassUID='1.2.840.10008.5.1.4.1.1.481.1';
  
  e_header.SOPClassUID='1.2.840.10008.5.1.4.1.1.481.1';
  
  e_header.RTImageLabel='xio';

  e_header.DoseGridScaling=s_header.DoseGridScaling;
  
  e_header.PixelSpacing=s_header.PixelSpacing;
  
  e_header.DoseUnits='cGy';
  
  e_header.Rows=s_header.Rows;
  e_header.Columns=s_header.Columns;
  e_header.DoseGridScaling=1;
  xio_dcm_name='siemen_eclipse_epid.dcm';
%   dose_plane2=int16(dose_plane2*100);

  dicomwrite(siemens_epid_dose,xio_dcm_name,e_header,'CreateMode','copy');
  
  xio_plane_dose_dcm=xio_dcm_name;
  