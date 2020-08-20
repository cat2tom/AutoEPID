function  addPatientAndPhysicist(cb,f_cb, height,patient_name,mrn,machine,physicist, pdf_cal,pdf_cal_date,comments)
%{
  Add patient name, mrn and physicist

  Input: cb-writer object.
         patient_name
         mrn
         physicist

         pdf_cal: calibration factor

         pdf_cal_date: calbration date.

         comments-user's comments.
%}


% add patient name
cb.beginText()
cb.setFontAndSize(f_cb,15);
cb.setTextMatrix(50,height-80);% left and top (x,y) is the position where to write the text. 
patient_name_str=strcat('Patient Name: ',patient_name);
cb.showText(patient_name_str);
cb.endText()


% add patient mrn 
cb.beginText()
cb.setFontAndSize(f_cb,15);
cb.setTextMatrix(50,height-100);% left and top (x,y) is the position where to write the text. 
mrn_str=strcat('MRN:  ',mrn);
cb.showText(mrn_str);
cb.endText()


% add machine 
cb.beginText()
cb.setFontAndSize(f_cb,15);
cb.setTextMatrix(50,height-120);% left and top (x,y) is the position where to write the text. 
machine_str=strcat('Machine:  ',machine);
cb.showText(machine_str);
cb.endText()

% add physicist

cb.beginText()
cb.setFontAndSize(f_cb,15);
cb.setTextMatrix(50,height-140);% left and top (x,y) is the position where to write the text. 

physicist_str=strcat('Performed by:   ','  ',physicist);
cb.showText(physicist_str);
cb.endText()

% add physicist

cb.beginText()
cb.setFontAndSize(f_cb,15);
cb.setTextMatrix(50,height-160);% left and top (x,y) is the position where to write the text. 
approval_str=strcat('Approved By:   ','  ',physicist);
cb.showText(approval_str);
cb.endText()

% add CF calibration 

cb.beginText()
cb.setFontAndSize(f_cb,15);
cb.setTextMatrix(50,height-180);% left and top (x,y) is the position where to write the text. 
approval_str=strcat('Calibration Factor:   ','  ',pdf_cal);
cb.showText(approval_str);
cb.endText()

% add CF calibration date 

cb.beginText()
cb.setFontAndSize(f_cb,15);
cb.setTextMatrix(50,height-200);% left and top (x,y) is the position where to write the text. 
approval_str=strcat('Calibration Date:   ','  ',pdf_cal_date);
cb.showText(approval_str);
cb.endText()


% add comments


% add CF calibration date 

cb.beginText()
cb.setFontAndSize(f_cb,15);
cb.setTextMatrix(50,height-220);% left and top (x,y) is the position where to write the text. 
approval_str='Comments:';
cb.showText(approval_str);
cb.endText()

cb.beginText()
cb.setFontAndSize(f_cb,15);
cb.setTextMatrix(50,height-240);% left and top (x,y) is the position where to write the text. 
approval_str=comments;
cb.showText(approval_str);
cb.endText()



end

