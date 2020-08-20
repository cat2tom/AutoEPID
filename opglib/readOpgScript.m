
opgFileName='Gamma Angle_004.opg';

% read all lines into a cell and ignore the empty line.
lineCellArray={}; 
fid = fopen(opgFileName);
tline = fgetl(fid); 
while ischar(tline)   
    lineCellArray=[lineCellArray;tline];   
    tline = fgetl(fid);
end 

% data start from line No.28;

dataCellArray=lineCellArray(28:end-2);

% set data matrix size

rowLength=length(dataCellArray);

colLength=length(str2num(dataCellArray{1}))-1;


dataMatrix=zeros(rowLength,colLength);

% loop through to get all data;

for i=1:rowLength
    
    tmp=dataCellArray{i};
    
     
    tmpNum=str2num(tmp);
    
    tmpNum2=tmpNum(2:end);
    
             
    dataMatrix(i,:)=tmpNum2;
end 



% convert to actual value by timing 0.001;
dataMatrix=dataMatrix*0.001;

imagesc(dataMatrix);



tmp6=dataMatrix(dataMatrix>0);



tmp7=tmp6(tmp6<=1);

gamma_pass=length(tmp7)/length(tmp6)

length(tmp6)

length(tmp7)

length(dataMatrix(:))

tmp9=dataMatrix(dataMatrix>=0);

tmp10=length(tmp9(tmp9<=1))



tmp9=length(dataMatrix(dataMatrix>=0))

gamma_pass2=tmp10/tmp9



