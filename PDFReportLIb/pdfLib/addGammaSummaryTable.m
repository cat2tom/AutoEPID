function addGammaSummaryTable(doc,f_cb,gammaSummaryS)
%{
Add a table of summary at the begining of table. 

Input: doc-the opened doc object
       f_cb-the base font.
       gammaSummaryS-struct array containg the summary having the following
       fields: beam_name, m3p3_gamma,m2p2_gamma,
       mean_gamma_m3p3,mean_gamma_m2p2

%}

% add java path

javaaddpath('C:/autoMRISimQAResource/javaJarFiles/sqlite-jdbc-3.8.11.2.jar')% for compiling.

javaaddpath('C:/autoMRISimQAResource/javaJarFiles/itextpdf-5.5.7.jar')

javaaddpath('C:/autoMRISimQAResource/javaJarFiles/itext-pdfa-5.5.7.jar')

javaaddpath('C:/autoMRISimQAResource/javaJarFiles/itext-xtra-5.5.7.jar')

javaaddpath('C:/autoMRISimQAResource/javaJarFiles/itext-xtra-5.5.7.jar')

% import required java libs.

import com.itextpdf.text.pdf.PdfPTable
import com.itextpdf.text.pdf.PdfPCell
import com.itextpdf.text.Font
import com.itextpdf.text.Paragraph
import com.itextpdf.text.pdf.PdfPCell
import com.itextpdf.text.Phrase
import com.itextpdf.text.BaseColor


% get how many beams

beamNumber=length(gammaSummaryS);

% table settings

colNumber=uint8(beamNumber);

table=PdfPTable((colNumber+1)); % three row and one more column for headings.
table.setWidthPercentage(110);
table.setSpacingBefore(250);

% add first colum name

cell_font=Font(f_cb,10); 

r1c1_beam=Paragraph('Beam Name',cell_font);

r2c1_M3P3=Paragraph('Gamma Pass Rate(3mm/3%)',cell_font);

r3c1_M2P2=Paragraph('Gamma Pass Rate(2mm/2%)',cell_font);

r4c1_mean_gamma_3p3m=Paragraph('Mean Gamma(3mm/3%)',cell_font);
r5c1_mean_gamma_2p2m=Paragraph('Mean Gamma(2mm/2%)',cell_font);



r1c1_beam_cell=PdfPCell(r1c1_beam);
r2c1_M3P3_cell=PdfPCell(r2c1_M3P3);
r3c1_M2P2_cell=PdfPCell(r3c1_M2P2);
r4c1_mean_gamma_3p3m_cell=PdfPCell(r4c1_mean_gamma_3p3m);

r5c1_mean_gamma_2p2m_cell=PdfPCell(r5c1_mean_gamma_2p2m);

% fill adding beam name row. 

table.addCell(r1c1_beam_cell)
for k=1:beamNumber

% fill first row with beam name as head 

  beam_name=gammaSummaryS(k).beam_name;
  r1_beamName=Paragraph(beam_name,cell_font);
  r1_beamName_cell=PdfPCell(r1_beamName);
  
%   table.addCell(r1c1_beam_cell)
  table.addCell(r1_beamName_cell)
  
end 


% adding second row of 3m3p Gamma.
table.addCell(r2c1_M3P3_cell)
for k=1:beamNumber

  %fill second row with Gamma pass rate 3m/3p.

 gamma_3m3p=gammaSummaryS(k).m3p3_gamma;
  
 
  
  gamma_3m3p_str=Phrase(num2str(gamma_3m3p),cell_font);
  
  gamma_3m3p_cell=PdfPCell(gamma_3m3p_str);
   
  % set colour 
  
  if gamma_3m3p>=95
      
      gamma_3m3p_cell.setBackgroundColor(BaseColor.GREEN);
      
  else
      
      gamma_3m3p_cell.setBackgroundColor(BaseColor.RED);
      
  end 
  
  table.addCell(gamma_3m3p_cell);
  
end 
 
% fill the third row.
table.addCell(r3c1_M2P2_cell)
for k=1:beamNumber
%   
% % filled third row with gamma pass rate 2m/2p

   gamma_2m2p=gammaSummaryS(k).m2p2_gamma;
  
 
  
  gamma_2m2p_str=Phrase(num2str(gamma_2m2p),cell_font);
  
  gamma_2m2p_cell=PdfPCell(gamma_2m2p_str);
  
  
  % set colour 
 
  if gamma_2m2p>=90 % changed threshold from 95% to 90% for 2mm/2%.
      
      %gamma_2m2p_cell.setBackgroundColor(BaseColor.GREEN);
      
      gamma_2m2p_cell.setBackgroundColor(BaseColor.YELLOW);
      
  else
      
      %gamma_2m2p_cell.setBackgroundColor(BaseColor.RED);
      
      gamma_2m2p_cell.setBackgroundColor(BaseColor.YELLOW);
      
  end 
    
  table.addCell(gamma_2m2p_cell);
end  

% add mean Gamma for 3%/3p

table.addCell(r4c1_mean_gamma_3p3m_cell)

for k=1:beamNumber
    
    
    gamma_mean_3p3m=gammaSummaryS(k).mean_gamma_m3p3;
   
    
    gamma_mean_3p3m_str=Phrase(num2str(gamma_mean_3p3m));
    gamma_mean_3m3p_cell=PdfPCell(gamma_mean_3p3m_str);
    
    table.addCell(gamma_mean_3m3p_cell);
    
    
end 



% add mean gamma 2m/2p
table.addCell(r5c1_mean_gamma_2p2m_cell);
for k=1:beamNumber
    
    
   gamma_mean_2p2m=gammaSummaryS(k).mean_gamma_m2p2;
  
    
    gamma_mean_2p2m_str=Phrase(num2str(gamma_mean_2p2m));
    gamma_mean_2m2p_cell=PdfPCell(gamma_mean_2p2m_str);
    
    table.addCell(gamma_mean_2m2p_cell);
    
    
end 


doc.add(table);

end 

