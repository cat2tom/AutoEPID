file_dicom2d='rs_2d_dose.dcm';

offset=[0,0,0];

[ x, y,dose ] = read2DDicomDose(file_dicom2d,offset);

imshow(dose)