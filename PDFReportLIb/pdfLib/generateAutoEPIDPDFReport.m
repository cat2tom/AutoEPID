function generateAutoEPIDPDFReport(handles)
%{
Wrapped up function for generate pdf report. 
fixed the issues 3m/3% to 3mm/3%.

%}

% get all data from handles

pdf_path_file_name=handles.pdf_report_file_name;

patient_name=handles.patient_name;

mrn=handles.mrn;

machine=handles.machine;

version_info=handles.version_info;


% physicist=handles.selected_physicist;

% using login name and computer

% physicist=strcat(getenv('computername'),'\',getenv('username'));

% as use full user name 

physicist=getFullUserName();



gammaSummaryS= handles.gammaSummaryS;


gammaProfileS=handles.gammaProfileS;



% pdf_cal=handles.pdf_cal;
% 
% pdf_cal_date=handles.pdf_cal_date;

% get pdf_cal and pdf_cal_date direclty from main windows

main_figure_cf_handle=findobj('Tag','default_cf');

pdf_cal=get(main_figure_cf_handle,'String');

main_figure_cf_date_handle=findobj('Tag','cf_date');

pdf_cal_date=get(main_figure_cf_date_handle,'String');



comments=handles.comments;

% call function

generatePDFReport(pdf_path_file_name,patient_name,mrn,machine,physicist,pdf_cal,pdf_cal_date,gammaSummaryS,gammaProfileS,version_info,comments)




end

