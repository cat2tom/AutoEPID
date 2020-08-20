function xio_plane_dose_dcm=xioDose2EclipseDICOM(xio_tps_file)

% convert the xio dose txt file into dicom file using eclipse dicom as
% template
% input: xio_tps_file-the dose plane file from xio
% output: xio_plane_dose_dcm-the converted dose in dcm format.

%   [row1,col1,dose_plane2]=readXioDose(xio_tps_file);

  [xgrid,ygrid,xiodose]=readXioDose(xio_tps_file);
  
  [row1,col1]=size(xiodose);
  
  xiodose=xiodose*100;
 
   % get eclipse header
  
  e_header=dicominfo('eclipse_template.dcm');
  
  e_header.MediaStorageSOPClassUID='1.2.840.10008.5.1.4.1.1.481.1';
  
  e_header.SOPClassUID='1.2.840.10008.5.1.4.1.1.481.1';
  
  e_header.RTImageLabel='xio';

  e_header.PixelSpacing=[0.4;0.4];
  
%   e_header.DoseUnits='cGy';
  
  e_header.Rows=row1;
  e_header.Columns=col1;
  
  
%   e_header.DoseGridScaling=1;
  
  xiodose=xiodose/e_header.DoseGridScaling;
  
  xiodose=int32(xiodose);
  
  xio_dcm_name='xio_eclipse.dcm';
%   dose_plane2=int16(dose_plane2*100);

  dicomwrite(xiodose,xio_dcm_name,e_header,'CreateMode','copy');
  
  xio_plane_dose_dcm=xio_dcm_name;
  