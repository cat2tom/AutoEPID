function xio_plane_dose_dcm=xioPlaneDose2DICOM(xio_tps_file)

% convert the xio dose txt file into dicom file using eclipse dicom as
% template
% input: xio_tps_file-the dose plane file from xio
% output: xio_plane_dose_dcm-the converted dose in dcm format.

  [row1,col1,dose_plane2]=readXioDose(xio_tps_file);
  
  % get eclipse header
  
  e_header=dicominfo('eclipse_template.dcm');
  
  e_header.MediaStorageSOPClassUID='1.2.840.10008.5.1.4.1.1.481.1';
  
  e_header.SOPClassUID='1.2.840.10008.5.1.4.1.1.481.1';
  
  e_header.RTImageLabel='xio';

  e_header.DoseGridScaling=1;
  
  e_header.PixelSpacing=[0.1;0.1];
  
  e_header.Rows=row1;
  e_header.Columns=col1;
  e_header.DoseGridScaling=1;
  xio_dcm_name='xio.dcm';
  dose_plane2=int16(dose_plane2*100);

  dicomwrite(dose_plane2,xio_dcm_name,e_header,'CreateMode','copy');
  
  xio_plane_dose_dcm=xio_dcm_name;
  