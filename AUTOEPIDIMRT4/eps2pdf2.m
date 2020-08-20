function eps2pdf(source, dest) 
% Construct the options string for ghostscript - create new or append 
% additional sheets if the destination exists 
if (exist(dest, 'file') == 2) 
    tmp_nam = tempname; 
    copyfile(dest, tmp_nam); 
    options = ['-q -dNOPAUSE -dBATCH -dEPSCrop -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile="' dest '" "' tmp_nam '" -f "' source '"']; 
else 
    options = ['-q -dNOPAUSE -dBATCH -dEPSCrop -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile="' dest '" -f "' source '"']; 
end 
     
% Convert to pdf using ghostscript 
ghostscript(options); 
return

