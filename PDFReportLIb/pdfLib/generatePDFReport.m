
function pdf_path_file_name=generatePDFReport(pdf_path_file_name,patient_name,mrn,machine,physicist,pdf_cal,pdf_cal_date,gammaSummaryS,gammaProfileS,version_info,comments)
%{
 Generate pdf report using itext given the pdf file name and QA resutls. 

 Input: pdf_path_file_name-pdf file to be generated
        gammaSummaryS-struct array containig sumary of gamma statistics
        gammaProfileS-struct array containing gamma and profile images.
        patient_name
        machine
        physicist
        comments

 output: pdf_path_file_name-generated pdf file 
       
%}


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


file_name=pdf_path_file_name;


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
generateHeadFooterAutoEPID(writer,cb,f_cb,width,height,color,version_info);
 
cb.restoreState();

document.add(Paragraph(' '));

addPatientAndPhysicist(cb,f_cb,height,patient_name,mrn,machine,physicist,pdf_cal,pdf_cal_date,comments)

% add table head

cb.beginText()

cb.setFontAndSize(f_cb,15);
 
 
cb.setTextMatrix(width/2-100,height-300);% left and top (x,y) is the position where to write the text. 
 
cb.showText('Summary of QA results');

cb.endText()

% add gamma summary table
addGammaSummaryTable(document,f_cb,gammaSummaryS)

% add gammma image and profile image.

addBeamGammaProfile(document,writer,cb,f_cb,width,height,color,gammaProfileS,version_info)


document.close()
