% the code snippet below will do this:
% 1) create a fancy fig
% 2) save it as a high res WMF
% 3) start a <msword> session
% 4) create a 2x2 table
% 5) fill each cell with a copy of the fig
% 
% note:
% a) run the code in a TMP folder!
% b) the WMF will use about 10M of disk space
%     you can change the resolution in the <print(...)> statement
% c) the output/doc looks really(!) good
% d) system used:
%     R12.1 / w2k / word xp (i guess older version will behave
% similarly)
% 
% us


% set i/o stuff
fdoc='ax.doc';
% fwmf='gaga.wmf';
fwmf1='ax_profile.jpg';
fwmf2='ax_gamma.jpg';

 fcwd=cd;
fnam2=[fcwd filesep fwmf2]

fnam1=[fcwd filesep fwmf1]


% % create a <nice> figure
% s=surfl(peaks(50));
% shading interp;
% x=get(s,'xdata');
% y=get(s,'ydata');
% z=get(s,'zdata');
% hold on
% m=mesh(x,y,z);
% set(m,...
%  'facecolor','none',...
%  'edgecolor',[0 0 0]);
% hold off
% axis square
% colormap(hot(256));
% shg
% print('-dmeta','-r200',fwmf);

% start ACTIVX session


% 0 votes
%  Eric answered on 17 Feb 2011 
% Accepted answer
% Let Word_COM be the COM object associated with MS Word. You can use
% 
% Word_COM.Selection.TypeText('string');
% Word_COM.Selection.TypeParagraph;
% To add some text and a carriage return. Use
% 
% Pic = Word_COM.Selection.InlineShapes.AddPicture('picture_filename');  
% set(Pic, 'ScaleHeight', scale, 'ScaleHeight', scale);
% Word_COM.Selection.MoveRight(1);
% Word_COM.Selection.TypeParagraph;




w=actxserver('word.application');
c=w.Documents;
% 
invoke(c,'Add');
a=w.ActiveDocument;
% s=w.Selection.InlineShapes;
% 
% 
% r=w.Selection.Range;
% create 4x4 table
% t=invoke(w.ActiveDocument.Tables,'add',r,1,2);


% fill each cell with an image
% invoke(s,'addpicture',fnam1);
% invoke(w.Selection,'moveright',1,1);
% invoke(s,'addpicture',fnam2);
% invoke(w.Selection,'moveright',2,1);
% invoke(s,'addpicture',fnam1);
% invoke(w.Selection,'moveright',2,1);
% invoke(s,'addpicture',fnam1);

Word_COM=w;
Pic = Word_COM.Selection.InlineShapes.AddPicture(fnam1);  

set(Pic, 'ScaleHeight', 50, 'ScaleWidth', 50);
Word_COM.Selection.MoveRight(1);
Word_COM.Selection.TypeParagraph;
Pic = Word_COM.Selection.InlineShapes.AddPicture(fnam2);  
set(Pic, 'ScaleHeight', 50, 'ScaleWidth', 84.5);
get(w.Selection.InlineShapes);

% save doc
invoke(w,'ChangeFileOpenDirectory',fcwd);
invoke(a,'saveas',fdoc);
if 0
invoke(a,'close');
else
set(w,'visible',1);
end
