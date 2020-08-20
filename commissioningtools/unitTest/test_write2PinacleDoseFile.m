

[xCor,yCor,oldImageData]=readPinnacleDose3('tpsFile2.txt');

size(oldImageData)

figure;



imagesc(oldImageData);

pinDoseFileName = write2PinacleDoseFile('pinFileTest.txt',oldImageData );


[xCor1,yCor1,newImageData]=readPinnacleDose3(pinDoseFileName');

figure

imagesc(newImageData);

