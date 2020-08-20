function addBeamGammaProfile(doc,writer,cb,f_cb,width,height,color,gammaProfileS,version_info)
%{
Add beam profile and Gamma image to pdf beam by beam.
Input: gammaProfileS-struct array containg the fields:
       beam_name
        profile_image_file_name
       gamma_image_file_name

       doc-document object.

%}

import com.itextpdf.text.Image
import com.itextpdf.text.Paragraph



% get number of beams

beamNumber=length(gammaProfileS);

% loop all beams


for k=1:beamNumber

% start a new page

doc.newPage();

generateHeadFooterAutoEPID(writer,cb,f_cb,width,height,color,version_info);

% add beam name

beam_name=gammaProfileS(k).beam_name;

title=strcat('Profile and Gamma image for Beam: ',beam_name);

doc.add(Paragraph(title));

% cb.beginText()
% 
% cb.setFontAndSize(f_cb,12);
%  
% cb.setTextMatrix(width/2-100,height-280);% left and top (x,y) is the position where to write the text. 
%  
% cb.showText(beam_name);
% 
% cb.endText()

% % add summary string
% 
% gamma_summary=gammaProfileS(k).gamma_summary;
% 
% cb.beginText()
% 
% cb.setFontAndSize(f_cb,15);
%  
% cb.setTextMatrix(width/2-100,height-260);% left and top (x,y) is the position where to write the text. 
%  
% cb.showText(gamma_summary);
% 
% cb.endText()

% add profile images

profile_image_file_name=gammaProfileS(k).profile_image_file_name;

profile_image=Image.getInstance(profile_image_file_name);
%Scale image's height
profile_image.scaleAbsoluteWidth(300);
%Scale image's width
profile_image.scaleAbsoluteHeight(300);
  
profile_image.setAbsolutePosition(150, 450);

doc.add(profile_image);

% add gamma images

gamma_image_file_name=gammaProfileS(k).gamma_image_file_name;

gamma_image=Image.getInstance(gamma_image_file_name);

%Scale image's height
gamma_image.scaleAbsoluteWidth(300);
%Scale image's width
gamma_image.scaleAbsoluteHeight(300);

gamma_image.setAbsolutePosition(150, 100);


doc.add(gamma_image);



end

end 
