function rotated_image= rotateImage3(raw_image,degree )
%{
Rotate image around the image center(pixel matrix center) by an angle of degree. 

Input: raw_image-matrix of pixel
       degree-degree of rotation.
ouput: rotated_image

useage: im=imread('test.jpg');
        rotated_image=rotateImage(im,45);

%}

% find the middle point

if degree>155
    
  mid_x=ceil(size(raw_image,1)/2);
  mid_y=ceil(size(raw_image,2)/2);
  
else
    
  mid_x=ceil(size(raw_image,2)/2);
  
  mid_y=ceil(size(raw_image,1)/2);
    
end 
  
% get x, y grid and shifted the center to middle

[y,x]=meshgrid(1:size(raw_image,2),1:size(raw_image,1));

[t,r]=cart2pol(x-mid_x,y-mid_y);

t1=radtodeg(t)+degree;

% convert from degree to radians

t=degtorad(t1);

% convert to cartesian co-ordinates


[x,y]=pol2cart(t,r);

% add the mid points to the new co-ordinates

temp_x=round(x+mid_x);
temp_y=round(y+mid_y);

% get the maxim new image dimension
if min(temp_x(:))<0
    
   new_x=max(temp_x(:))+abs(min(temp_x(:)))+1;
   
   temp_x=temp_x+abs(min(temp_x(:)))+1;
    
else
    
    
  new_x=max(temp_x(:));  
    
end 
    
    

if min(temp_y(:))<0
    
   new_y=max(temp_y(:))+abs(min(temp_y(:)))+1;
   
   temp_y=temp_y+abs(min(temp_y(:)))+1;
    
    
else
    
    new_y=max(temp_y(:));
    
end 


temp_y(temp_y==0)=1;

temp_x(temp_x==0)=1;

% initialize the rotated image

temp_rotated_image=uint16(zeros([new_x,new_y]));

for ii=1:size(raw_image,1)
    
    for jj=1:size(raw_image,2)
    
        temp_rotated_image(temp_x(ii,jj),temp_y(ii,jj))=raw_image(ii,jj); % using the pixel from original image
        
    end 

end 

% fill the hole 

 filled_roated_image=fillImageHole(temp_rotated_image);
 
% resize the image to orginal size

filled_roated_image=imresize(filled_roated_image,size(raw_image));
 
% resize the image to orginal image  
 rotated_image=filled_roated_image;

end


% helper function 

function hole_filled_image=fillImageHole(image)

% fill the image hole using nearest neighbours
% input: image-the pixel matrix
% output: hole_filled_image-pixel array with hold filled.

temp_ouput=image;

for ii=2:size(image,1)-1
    
    for jj=2:size(image,2)-1
        
        temp=image(ii-1:ii+1,jj-1:jj+1);
        
        if temp(5)==0 && sum(temp(:))~=0
            
            pt=find(temp~=0);
            
            [~,pos]=sort(abs(pt-5));
            
            temp_ouput(ii,jj)=temp(pt(pos(1)));
            
        end
        
    end
end


hole_filled_image=temp_ouput;

end 
 

