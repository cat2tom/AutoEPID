function  generateHeadFooterDailyQA( writer,cb,f_cb,width,height,BaseColor, version_info )
%set the page header and footer for daily QA report. 
% 
% Added handles to pass version info via handles. 


%   Detailed explanation goes here
 cb.saveState();
 %% draw header 
 cb.setFontAndSize(f_cb,20);
 
 cb.beginText()
 
 head_txt='LCTC MRISim Daily QA Report';
 
 cb.setTextMatrix(width/2-120,height-30);% left and top (x,y) is the position where to write the text. 
 
 cb.showText(head_txt);
 
 % draw a line
 
  
 cb.endText()
 
 % Direclty draw a line on PDFContentByte. 
 
%  cb.saveState();
 cb.setLineWidth(1.5);
 
 cb.moveTo(0,height-40);% move to upper left 
 
 cb.lineTo(width,height-40);
 
 cb.setColorStroke(BaseColor);
 cb.stroke();
 
 %% draw footer
 % set foot infor
%  cb.restoreState();

 cb.setLineWidth(1.5);
 
 cb.moveTo(0,40);% bottom left
 
 cb.lineTo(width,40);
 
 cb.setColorStroke(BaseColor);
 cb.stroke();
 
 % get current date
 
 date_time=char(datetime('now','TimeZone','local','Format','d-MMM-y HH:mm'));
 
 footer1=date_time;
 
%  footer2='MRISimQA V1.0';
 
 footer2=version_info;
 
 cb.setFontAndSize(f_cb,10);
 
 cb.beginText()
 
 a=writer.getPageNumber();
 
 
 
 page_footer=strcat('Page  ',' ', num2str(a));
 
 cb.setTextMatrix(10,20);% left and top (x,y) is the position where to write the text. 
 
 cb.showText(footer1);
 
 
 cb.setTextMatrix(width-100,20);% use to adjust the header position. 
 
 cb.showText(footer2);
 
 cb.setTextMatrix(width-300,20)
 
 cb.showText(page_footer);
 
 cb.endText()
 
 cb.restoreState();
 


end

