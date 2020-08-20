function fluenceMap=readOPGFluence(gammaOPGFileName)

% Read opg file export from OminPro separated using comma  and return Gamma
% map and recalculted pass rate and ominiPassRate.

% input: 
%      gammaOPGFileName-the gamma file exported from OminPro  name including path
% output: gammaMap-the gamma map calculated by OminPro where the gamma
%         value is makred as -1 within dose threshold. 
%         realPassRate-the recalculated pass rate excludng the padding
%                     zeros
%         ominPassRate-the pass rate given by OminiPro. 


% read all lines into a cell and ignore the empty line.

opgFileName=gammaOPGFileName;
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
fluenceMap=dataMatrix;





