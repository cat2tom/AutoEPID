function writeHISfile(img, filename, logFilename)

fid = fopen(filename, 'w');

% Transpose the image
img = img';

if fid == -1
    warning('File could not be opened for writing');
else
    % write the header, for now just zeros other than the width and height
    header = zeros(50,1);
    [w,h] = size(img);
    header(9) = w;
    header(10) = h;
    fwrite(fid,header,'uint16');
    
    % Write the image data
    fwrite(fid,img,'uint16');

    fclose(fid);

    if exist('logFilename','var')
        % If a log filename is given, write it.
        fid = fopen(logFilename, 'w');
        if fid == -1
            warning('Log file could not be opened for writing');
        else


        fprintf(fid, 'iView images exported %s\n', datestr(datetime('now','Format','dd/MM/yyyy hh:mm:ss')));

        fprintf(fid, '\n');

        fprintf(fid, 'File: %s\n', filename);
        fprintf(fid, 'Patient: PSEUDO, DATA\n');
        fprintf(fid, 'Treatment: PSEUDO\n');
        fprintf(fid, 'Field: 101\n');

        fprintf(fid, 'Image: %s IMRT mult.\n', datestr(datetime('now','Format','dd/MM/yyyy hh:mm:ss')));
        fprintf(fid, 'Image UID: dummy.uid\n');
        fprintf(fid, 'Image Origin: M7Versa\n');
        fprintf(fid, 'Station: M7Versa\n');
        fprintf(fid, 'Creation Date (DD/MM/YYYY): %s\n', datestr(datetime('now','Format','dd/MM/yyyy')));
        fprintf(fid, 'Creation Time: %s\n', datestr(datetime('now','Format','hh:mm:ss')));
        fprintf(fid, 'Last Modified Date (DD/MM/YYYY): %s\n', datestr(datetime('now','Format','dd/MM/yyyy')));
        fprintf(fid, 'Last Modified Time: %s\n', datestr(datetime('now','Format','hh:mm:ss')));
        fprintf(fid, 'Acquired Date (DD/MM/YYYY): %s\n', datestr(datetime('now','Format','dd/MM/yyyy')));
        fprintf(fid, 'Acquired Time: %s\n', datestr(datetime('now','Format','hh:mm:ss')));


        fprintf(fid, 'Brightness (percent):46\n');
        fprintf(fid, 'Contrast (percent) : 65\n');
        fprintf(fid, 'Image width (in pixels): %d\n', w);
        fprintf(fid, 'Image height (in pixels): %d\n', h);
        fprintf(fid, 'Image bit depth: 16\n');
        fprintf(fid, 'Horizontal scale: 0.25 mm/pixel\n');
        fprintf(fid, 'Image center x (pixel): 0.00\n');
        fprintf(fid, 'Image center y (pixel): 0.00\n');
        fprintf(fid, 'Image aspect ratio: 1.00\n');
        fprintf(fid, 'TmpMatchSourceImageCenter x (pixel): 0.00\n');
        fprintf(fid, 'TmpMatchSourceImageCenter y (pixel): 0.00\n');
        fprintf(fid, 'Image file format: Lossless JPEG (.JPG)\n');
        fprintf(fid, 'TmpMatchHorz(mm): 0.00\n');
        fprintf(fid, 'TmpMatchVert(mm): 0.00\n');
        fprintf(fid, 'TmpMatchOriginPatientID:\n');
        fprintf(fid, 'TmpMatchOriginTreatmentID:\n');
        fprintf(fid, 'TmpMatchOriginFieldID:\n');
        fprintf(fid, 'TmpMatchOriginImageID:\n');
        fprintf(fid, 'TmpMatchUser:\n');
        fprintf(fid, 'TmpMatchDate (DD/MM/YYYY):\n');
        fprintf(fid, 'TmpMatchTime:\n');
        fprintf(fid, 'TmpMatchRotation(degrees): 0.00\n');
        fprintf(fid, 'FramePixelFactor (Frame1): 1\n');
        fprintf(fid, '\n');
        
        fclose(fid);
    end
    end
end