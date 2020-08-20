function [gammaMap,realGammaPassRate,ominiProGammaPassRate]=readOPGGamma(gammaOPGFileName)

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
gammaMap=dataMatrix;

% recalculate the pass rate.

tmp6=dataMatrix(dataMatrix>0);

tmp7=tmp6(tmp6<=1);

gamma_pass=length(tmp7)/length(tmp6); 

disp(['The total pixels:'   num2str(length(tmp6))])

mean_gamma=mean(tmp6(:))

min_gamma=min(tmp6(:))

max_gamm=max(tmp6(:))

realGammaPassRate=gamma_pass;

disp(['The real gamma pass rate is : ' num2str(gamma_pass)])

% pass rate given by OminPro.
tmp9=dataMatrix(dataMatrix>=0);

tmp10=length(tmp9(tmp9<=1));

tmp9=length(dataMatrix(dataMatrix>=0));

gamma_pass2=tmp10/tmp9;

ominiProGammaPassRate=gamma_pass2;

disp(['The OminiProIMRT gamma pass rate is : ' num2str(gamma_pass2)])





