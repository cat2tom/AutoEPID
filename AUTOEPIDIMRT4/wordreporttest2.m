%# create plot and copy to clipboard 
plot(rand(10,1)) 
print -dmeta  %# open MS-Word 
Word = actxserver('Word.Application'); 
Word.Visible = false;  %# create new document 
doc = Word.Documents.Add;  %# paste figure from clipboard 
Word.Selection.Paste  %# crop the image 
doc.InlineShapes.Item(1).PictureFormat.CropBottom = 100;  %# save document, then close 
doc.SaveAs( fullfile(pwd,'file4.doc') ) 

print('-dps', 'file3.doc');
doc.Close(true)  %# quit and cleanup 
Word.Quit 
Word.delete 