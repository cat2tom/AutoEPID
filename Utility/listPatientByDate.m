function  pat_list=listPatientByDate(dir_temp)

%{

 List and sort the subdirectories acoording to modification date under an root
 directories. 

 @dir_temp: a root directory
 
 @@ pat_list-list of all subdirectories according to the modification date.

 
%}


dirS= dir(dir_temp);

% struct to table

dirT=struct2table(dirS);


% sort the table by date/time 

dirT=sortrows(dirT,'datenum','descend');


% filter the table to get dir only

dirT=dirT(dirT.isdir,:);

% back to dirlist

d=table2struct(dirT);

isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';

nameFolds(ismember(nameFolds,{'.','..'})) = [];

pat_list=nameFolds;