function  writeCalFactorTxt( txtFileName,calFactorCellArray )
%{ 
Write daily QA resutls to a txt file for later analysis.

Input: 

txtFileName-file name to be written.

calFactorCellArray-the cell array containing call factor.

%}

testData=calFactorCellArray;


newTableQA=cell2table(testData,'VariableNames',{'Machine',	'CalibrationFactor','Date',...
    'CalibrationFile',	'Physicist'});




if exist(txtFileName,'file')==2
    
   oldTableQA=readtable(txtFileName,'Format','%s%f%f%f%f%f%f%f%f%f%f%s');
   
   tableQASum=[oldTableQA;newTableQA];
   
     
   writetable(tableQASum,txtFileName);
  
else
    
  writetable(newTableQA,txtFileName); 

end 


end

