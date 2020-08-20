% loading the java package. 
import java.io.FileOutputStream

import java.io.IOException

% In order to make compiled version work, the dynamic path has to be added
% here. 

javaaddpath('C:/autoMRISimQAResource/javaJarFiles/sqlite-jdbc-3.8.11.2.jar')% for compiling.

javaaddpath('C:/autoMRISimQAResource/javaJarFiles/itextpdf-5.5.7.jar')

javaaddpath('C:/autoMRISimQAResource/javaJarFiles/itext-pdfa-5.5.7.jar')

javaaddpath('C:/autoMRISimQAResource/javaJarFiles/itext-xtra-5.5.7.jar')

javaaddpath('C:/autoMRISimQAResource/javaJarFiles/itext-xtra-5.5.7.jar')

import com.itextpdf.text.*

import com.itextpdf.text.Document

import com.itextpdf.text.DocumentException
import com.itextpdf.text.PageSize
import com.itextpdf.text.Paragraph
import com.itextpdf.text.pdf.PdfWriter

import com.itextpdf.text.pdf.PdfPTable

import com.itextpdf.text.pdf.PdfPCell

import com.itextpdf.text.pdf.BaseFont

import com.itextpdf.text.BaseColor

import com.itextpdf.text.Image

import com.itextpdf.text.Font

import com.itextpdf.text.FontFactory


% Start of practice of codes. 


% file name
  
f_cb=BaseFont.createFont('c:\\windows\\fonts\\arial.ttf',BaseFont.WINANSI,BaseFont.EMBEDDED);



% document obj

document =Document(PageSize.A4);% set landscape to portrait.

% get page size width and hight

width=PageSize.A4.getWidth();

height=PageSize.A4.getHeight();

% file name using datetiem 

file_name=strcat('MRISim_DailyQA_report_performed on_','test','.pdf');

% file_name=fullfile(pdf_dir,file_name);

% file obj


file_obj=FileOutputStream(file_name);

% associate pdf writer obj with document obj

writer=PdfWriter.getInstance(document,file_obj);
 
 % open the document 
document.open();
  
% get DC object.

cb=writer.getDirectContent(); % establish a direct content.
 
% write head and footer information.

cb.saveState();
color=BaseColor.BLUE;
generateHeadFooterAutoEPID(writer,cb,f_cb,width,height,color);
 
cb.restoreState();


document.add(Paragraph(' '));


patient_name='tom,cat';

mrn='123456';
machine='M1';

physicist='ax';

addPatientAndPhysicist(cb,f_cb,height,patient_name,mrn,machine,physicist)

% table head.

cb.beginText()

cb.setFontAndSize(f_cb,15);
 
 
cb.setTextMatrix(width/2-100,height-200);% left and top (x,y) is the position where to write the text. 
 
cb.showText('Summary of QA results');

cb.endText()

% add summary table

gammaSummaryS=struct();

gammaSummaryS(1).beam_name='101';

gammaSummaryS(1).m3p3_gamma=96.7;
gammaSummaryS(1).m2p2_gamma=92.3;
gammaSummaryS(1).mean_gamma_m2p2=1.2;
gammaSummaryS(1).mean_gamma_m3p3=1;


gammaSummaryS(2).beam_name='102';
gammaSummaryS(2).m3p3_gamma=95.7;
gammaSummaryS(2).m2p2_gamma=92.3;
gammaSummaryS(2).mean_gamma_m2p2=1.2;
gammaSummaryS(2).mean_gamma_m3p3=1;


gammaSummaryS(3).beam_name='102';
gammaSummaryS(3).m3p3_gamma=95.7;
gammaSummaryS(3).m2p2_gamma=92.3;
gammaSummaryS(3).mean_gamma_m2p2=1.2;
gammaSummaryS(3).mean_gamma_m3p3=1;

gammaSummaryS(4).beam_name='102';
gammaSummaryS(4).m3p3_gamma=95.7;
gammaSummaryS(4).m2p2_gamma=92.3;
gammaSummaryS(4).mean_gamma_m2p2=1.2;
gammaSummaryS(4).mean_gamma_m3p3=1;


gammaSummaryS(5).beam_name='102';
gammaSummaryS(5).m3p3_gamma=95.7;
gammaSummaryS(5).m2p2_gamma=92.3;
gammaSummaryS(5).mean_gamma_m2p2=1.2;
gammaSummaryS(5).mean_gamma_m3p3=1;


gammaSummaryS(6).beam_name='102';
gammaSummaryS(6).m3p3_gamma=95.7;
gammaSummaryS(6).m2p2_gamma=92.3;
gammaSummaryS(6).mean_gamma_m2p2=1.2;
gammaSummaryS(6).mean_gamma_m3p3=1;

addGammaSummaryTable(document,f_cb,gammaSummaryS)

% document.newPage();
% 
% generateHeadFooterAutoEPID(writer,cb,f_cb,width,height,color);
% 
% document.add(Paragraph('This is Page 2'));

gammaProfileS(1).beam_name='101';

gammaProfileS(1).profile_image_file_name=which('profile.jpg');
gammaProfileS(1).gamma_image_file_name=which('gamma.jpg');

gammaProfileS(2).beam_name='102';

gammaProfileS(2).profile_image_file_name=which('profile.jpg');
gammaProfileS(2).gamma_image_file_name=which('gamma.jpg');


addBeamGammaProfile(document,writer,cb,f_cb,width,height,color,gammaProfileS)


document.close()
