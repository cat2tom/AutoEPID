function writePinnacleDose(dose_plane, filename, pixel_to_dose_factor)
%WRITEPINNACLEDOSE Write the give dose to Pinnacle txt format

    fid = fopen(filename, 'w');

    % Write the header data
    fprintf(fid, 'Version:,16.0\n');
    fprintf(fid, 'Patient:,PSEUDO, DATA\n');
    fprintf(fid, 'MR Number:,0000001\n');
    fprintf(fid, 'Plan Name:,PSEUDO\n');
    fprintf(fid, 'Plan revision:,R01.P01.D01\n');
    fprintf(fid, 'Date:,%s\n', char(datetime('now','Format','yyyy-MM-dd hh:mm:ss')));
    fprintf(fid, 'Trial:,1\n');
    fprintf(fid, 'Beam:,1\n');
    fprintf(fid, 'Machine:,ElektaVersa\n');
    fprintf(fid, 'SPD:,100.000\n');
    fprintf(fid, '\n');
    
    dose_plane = dose_plane / pixel_to_dose_factor;
    
    % Write the xgrid
    [m,n]=size(dose_plane);
    xgrid=(-n/2+0.5:n/2)';
    ygrid=(-m/2+0.5:m/2)';
    xgrid = xgrid./10;
    ygrid = ygrid./10;
    fprintf(fid,',');
    fprintf(fid,'%.3f,', xgrid);
    fprintf(fid,'\n');
    
    for i=1:m
        fprintf(fid,'%.3f,', ygrid(i));
        fprintf(fid,'%.3f,', dose_plane(i,:));
        fprintf(fid,'\n');
    end
    
    fclose(fid);
end