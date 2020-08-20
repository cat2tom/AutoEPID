

function  full_user_name=getFullUserName()

 % get user login name first
 
 user_login_name=getenv('username');
 
  
 % assemble commandline string
 
 
 command_string=strcat({'net user   '},{' '},str2Cell(user_login_name),{'  /domain'}); % use cell to keep space 
 
 
 command_string=command_string{1}; % back to string.
 
 class(command_string)

 
 [~,cmd_out]=system(command_string);
 
 % convert string to cell
 
 cmd_outC=str2Cell(cmd_out);
 
 % first name at 18 and full name at 19.
 
 first_name=cmd_outC{18};
 
 family_name=cmd_outC{19};
 
 % get full name
 
 full_name=strcat(family_name,',',first_name);
 
 
 full_user_name=full_name;
 
 
end 