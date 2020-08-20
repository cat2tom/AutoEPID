function pinDoseFileName = write2PinacleDoseFile(pinDoseFileName,imageData )
% Write an double square  matrix (nxn) to standard Pinnalce TPS dose file. 
%{
  Input: 
      pinDoseFileName-the file name to be written 
      imageData-matrix of double number with size (n,n)
  Output: 
      pinDoseFileName

  The coordinates of dose image is in cm. XCor=-n/2:o.1:n/2;
  YCor=-n/2:0.1:n/2. The resolution is 1mm. 

%}

% make headers 

version='Version:,9.10\n';
patient='Patient:,AutoEPId, Commisioning,\n';
mrn='MR Number:,1330779\n';
planName='Plan Name:,epid \n';
planRev='Plan revision:,R01.P01.D01\n';
planDate='Date:,2018-02-12 09:12:36\n';
trial='Trial:,1\n';
beam='Beam:,2\n';
machine='Machine:,ElektaVersa\n';
spd='SPD:,100.000\n\n,';

tpsFileHeader=[version patient mrn planName planRev trial beam machine spd];

% write the header into tps file first

fid = fopen(pinDoseFileName,'wt');

fprintf(fid, tpsFileHeader);

fclose(fid);


% make X and Y coordinates

[row,col]=size(imageData);

% row=row/10;
% col=col/10; % from mm to cm.

xCor=1:row;
yCor=1:col;


if isodd(row)
    
   
    xCor=(xCor-row/2)*0.1; % changed to cm.
    
    yCor=(yCor-col/2)*0.1; % changed to cm.
    
    
end 

if iseven(row)
    
    xCor=(xCor-row/2)*0.1;
    
    yCor=(yCor-col/2)*0.1;
    
   
    
end 


% make new Ycor to write to files

newYCor=[xCor(1) yCor];
newYCor=newYCor'; % changed to col vector


% add them to matrix

newImageData=[xCor;imageData];


newImageData=[newYCor newImageData];

% write dose to new file

dlmwrite(pinDoseFileName,newImageData,'-append','precision',4);

end

