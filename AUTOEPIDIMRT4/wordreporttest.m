    reportFilename = fullfile(pwd,'ax.doc');
     wr = wordreport(reportFilename);
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
%      h=figure('Visible','off');
%      
%      plot(1:10);
%      title('Figure 1'); xlabel('Temps [s]'); ylabel('Amplitude [A]');
%      
%      print('-dps','test');
     
%      print('ax_profile.jpg','-dps','test');
%      
%      wr.setstyle('Normal');
%      
%      wr.addfigure();
%       w=actxserver('word.application');
%       c=w.Documents;
% % 
%       invoke(c,'Add');
%       a=w.ActiveDocument;
%       fnam1='ax_profile.jpg';
%       fnam2='ax_profile.jpg';
% %       res=wr.getactivexhandle;
%       Word_COM=w;
%       Pic = Word_COM.Selection.InlineShapes.AddPicture(fnam1);  
%       set(Pic, 'ScaleHeight', 50, 'ScaleWidth', 50);
%       Word_COM.Selection.MoveRight(1);
%       Word_COM.Selection.TypeParagraph;
%       Pic = Word_COM.Selection.InlineShapes.AddPicture(fnam2);  
%       set(Pic, 'ScaleHeight', 50, 'ScaleWidth', 84.5);
%         hdlActiveX = wr.getactivexhdl();
%   get(hdlActiveX);
%   get(hdlActiveX.Selection);
%   invoke(hdlActiveX.Selection);

%       wr.insertimage('ax_profile.jpg','ax_profile.jpg');
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