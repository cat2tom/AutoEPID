function saveData(outputPath,patientID, patientName, epidDose, tpsDose)
%SAVEDATA Saves the EPID and TPS data in the directory structure used by
%AutoEPID

outputDir = [outputPath '\' patientID '_' patientName];

if exist(outputDir, 'dir') == 7
    prompt = sprintf('Directory "%s" exists!\nDelete contents of directory and continue? y/N [N]: ', strrep(outputDir,'\','\\'));
    str = input(prompt,'s');
    if isempty(str)
        str = 'N';
    end
    
    if strcmpi(str, 'Y') % case insensitive
        rmdir(outputDir, 's');
    else
        fprintf('Operation Cancelled\n');
        return
    end
end

mkdir(outputDir);

epidDir = [outputDir '\EPID'];
mkdir(epidDir);
tpsDir = [outputDir '\TPS'];
mkdir(tpsDir);

% Correct for the scale factor of HIS files
scaleFactor = 8.2004e-05;
epidDose = 65535 - (epidDose / scaleFactor);
epidDose=uint16(epidDose);
writeHISfile(epidDose,[epidDir '\' 'Field_0.HIS'], [epidDir '\' 'Field_1.LOG']);

writePinnacleDose(tpsDose, [tpsDir '\' patientID '_VMAT.txt'], 1);

fprintf('Data saved to: %s\n', outputDir);
        
end

