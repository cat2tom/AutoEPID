 reportFilename = fullfile(pwd,'fooAITANG5.doc');
    wr = wordreport5(reportFilename);

    wr.setstyle('Heading 1');
    wr.addtext('IMRT patient QA report', [15 15]); % line break before and after text
    wr.addpagebreak()
    wr.setstyle('Heading 1');
    wr.addtext('Table of content');
    wr.createtoc(1, 3);
    wr.addpagebreak();
    % ---
    wr.setstyle('Heading 1');
    wr.addtext('MATLAB data', [1 1]); % line break before and after text
    % ---
    wr.setstyle('Heading 2');
    wr.addtext('Sample table', [0 1]); % line break after text
    dataCell = { ...
        'Test 1', num2str(0.3) , 'OK'; ...
        'Test 2', num2str(1.8) , 'KO'};
    [nbRows, nbCols] = size(dataCell);
    wr.addtable(nbRows, nbCols, dataCell, [1 1]); % line break before table
    % ---
    wr.setstyle('Heading 2');
    wr.addtext('Sample figure', [0 1]); % line break after text
%     figure; plot(1:10);
%     title('Figure 1'); xlabel('Temps [s]'); ylabel('Amplitude [A]');
%     wr.setstyle('Normal');
%     
    wr.setstyle('Heading 3');
    wr.addtext('Beam 1 results');
    fwmf1='ax_profile.jpg';
    fwmf2='ax_gamma.jpg';

    fcwd='C:\aitang research\EPID IMRT commisioning\report matlab codes\wordreport\';
    fnam2=[fcwd  fwmf2];

    fnam1=[fcwd  fwmf1]
    wr.addfigure(fnam1,fnam2);
    % ---
    wr.addpagenumbers('wdAlignPageNumberRight');
    wr.updatetoc();
    % ---
    wr.close();
    % ---
    open(reportFilename);
