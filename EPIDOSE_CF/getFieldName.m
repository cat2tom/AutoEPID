function   field_name=getFieldName(structure, value)

% This function is to return  a field name according to his value for a struncture
% input: structure-the name of structrue 
%        value-the value of field to be returned

% output: the name of field having the vale.

% if there is no this value and field, the return name is empty.

field_name_list=fieldnames(structure);

field_name='';
for i=1:length(field_name_list)
    
    tmp_name=field_name_list{i};
    
    tmp_field_value=getfield(structure,tmp_name);
    
    if strcmp(tmp_field_value,value)
        
        field_name=tmp_name;
        
    end 
end 

end 
    





  

