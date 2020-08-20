
function jpg_file_name=gui2JPEG(guihandle,root_screen,position2,saved_file_name)

% Function: Capture screen gui into a jpeg file
% input: guihandle-the figure handle of gui to be caputured.
%        saved_file_name-the name used for jpeg file without .jpg
% output: jpg_file_name-returend file name for jpef file
 
   robo = java.awt.Robot;
   t = java.awt.Toolkit.getDefaultToolkit();



% get computer screen size

%  root_screen=get(0,'ScreenSize');
  
% get the the gui position 

ch=guihandle;
figure(ch);
set(ch,'unit','pixel');
% position2=get(ch,'position');

rectangle = java.awt.Rectangle(position2(1),root_screen(2)-position2(2),position2(3),position2(4));
% rectangle = java.awt.Rectangle(position2(1),-position2(2),position2(3),position2(4));

image5 = robo.createScreenCapture(rectangle);

jpg_fn=[saved_file_name  '.jpg']

filehandle = java.io.File(jpg_fn);
javax.imageio.ImageIO.write(image5,'jpg',filehandle);
imageview(jpg_fn);
jpg_file_name=jpg_fn;