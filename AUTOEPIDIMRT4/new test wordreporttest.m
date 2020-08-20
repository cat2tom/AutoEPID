    reportFilename = fullfile(pwd,'newtest.doc');
     wr = wordreport5(reportFilename);
     wr.setstyle('Heading 1');
     wr.addtext('TOC', [1 1]); % line break before and after text
     wr.createtoc(1, 3);
     wr.addpagebreak();    % 
     wr.setstyle('Heading 2');
     wr.addtext('MATLAB data', [1 1]); % line break before and after text
     % ---
     wr.setstyle('Heading 3');
     wr.addtext('Sample table', [0 1]); % line break after text
     dataCell = { ...
         'Test 1', num2str(0.3) , 'OK'; ...
         'Test 2', num2str(1.8) , 'KO'};
     [nbRows, nbCols] = size(dataCell);
     wr.addtable(nbRows, nbCols, dataCell, [1 1]); % line break before table
     
     wr.setstyle('Heading 4');
     wr.addtext('Sample figure', [0 1]); % line break after text

      fnam1='ax_profile.jpg';
      fnam2='ax_profile.jpg';

      wr.addfigure('ax_profile.jpg','ax_profile.jpg');
%        
     % ---
      wr.addpagenumbers('wdAlignPageNumberRight');
     
%     wr.insertimage('ax_profile.jpg','ax_profile.jpg');
     
      wr.updatetoc();
     
%      print('-dps','foo.doc')
%      % ---
      wr.close();
     % ---
          
     open(reportFilename);