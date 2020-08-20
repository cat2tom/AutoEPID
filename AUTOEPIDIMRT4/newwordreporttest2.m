    
     % Create a new report in current directory, discarding any existing content
     reportFilename = 'demo.doc';
     if exist(reportFilename, 'file')
        delete(reportFilename);
     end
     reportFilename = fullfile(pwd,reportFilename);
     wr = wordreport5(reportFilename);
     headingString = 'Patient  IMRT  QA  report ';
try
    % Set style to 'Heading 1' for top level titles
    wr.setstyle([headingString '1']);
    % Define title
    textString = 'Patient IMRT QA report';
    % Insert title in the document
    wr.addtext(textString, [0 15]); % two line breaks after text
catch
    % Error when trying to insert first heading. The generic name for
    % heading styles must be wrong, problably due to Microsoft Office
    % language. Resetting to default: ENGLISH (see above for more details)
    warning('Resetting generic name for heading styles to default ''Heading '''); %#ok<WNTAG>
    headingString = 'Heading ';
    wr.setstyle([headingString '1']);
    textString = 'Patient IMRT QA report';
    wr.addtext(textString, [0 15]); % two line breaks after text
    wr.setstyle('Heading 2');
    wr.addtext('Patient Name: test')
    wr.addtext('MRN:')
    wr.addtext('DOB:');
end
     
     wr.setstyle('Heading 1');
     wr.addpagebreak()
%      wr.addtext('Table of Content', [1 2]); % line break before and after text
     wr.createtoc(1, 3);
     wr.addpagebreak();   
     
     % 
     wr.setstyle('Heading 1');
     wr.addtext('Gamma and profile analysis', [1 1]); % line break before and after text
     % ---

     
     wr.setstyle('Heading 2');
     wr.addtext('Beam 1', [0 1]); % line break after text

      fnam1='C:\aitang research\EPID IMRT commisioning\guiepid\EPIDDOSE6\tpscode\ax_profile.jpg';
      fnam2='C:\aitang research\EPID IMRT commisioning\guiepid\EPIDDOSE6\tpscode\ax_gamma.jpg';

      wr.addfigure(fnam1,fnam2);
      
      wr.addpagebreak()
      
     wr.setstyle('Heading 2');
     wr.addtext('Beam 2', [0 1]); % line break after text

      fnam1='C:\aitang research\EPID IMRT commisioning\guiepid\EPIDDOSE6\tpscode\ax_profile.jpg';
      fnam2='C:\aitang research\EPID IMRT commisioning\guiepid\EPIDDOSE6\tpscode\ax_gamma.jpg';

      wr.addfigure(fnam1,fnam2);
      
%        
     % ---
      wr.addpagenumbers('wdAlignPageNumberRight');
     
     
      wr.updatetoc();
     
%      print('-dps','foo.doc')
%      % ---
      wr.close();
     % ---
          
     open(reportFilename);