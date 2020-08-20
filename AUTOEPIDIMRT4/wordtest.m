% Open document in 'write' mode:
     [file,status,errMsg] = officedoc('test.doc', 'open', 'mode','write');

   % Write a title line at a specific position:
     status = officedoc(file, 'write', 'title','My magic data','page',3,'line',4,'PageBreakBefore',1);

   % Write data beneath the header:
     status = officedoc(file, 'write', 'line',1,'data',magic(6),'halign','center');

   % Format the data (font, color, alignment, borders/edges):
   % Note: we could also append these properties to the end of the 'write' command above
     status = officedoc(file, 'format', 'bold','on','italic',1,'fgcolor',[1,0,0],'bgcolor','y','EdgeBottom',{4,'b'});

   % Some specific formatting not currently supported by officedoc:
     set(file.fid.PageSetup.LineNumbering,'Active',1);

   % Display the document in Word application:
     officedoc(file, 'display');

   % Loop many times and append data to the bottom of the open document page:
     for index = 1 : 10
       data = someComputation();  % e.g., magic(3) or {1,2,3; 'a','b','c'}
       status = officedoc(file, 'write', 'data',data);
     end

   % Close the document, releasing COM server:
     status = officedoc(file, 'close', 'release',1);

   % Re-display document; file is no longer valid so we must use file name:
     officedoc('test.doc', 'display');

