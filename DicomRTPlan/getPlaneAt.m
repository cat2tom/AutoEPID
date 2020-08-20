function DOSE2D = getPlaneAt(x,y,z,DOSE3D,loc,orient)

% dose2D=interPolate3D(x,y,z,DOSE3D,loc,orient);
% 
% DOSE2D=dose2D;
 DOSE2D=interPolate2D(x,y,z,DOSE3D,loc,orient);

end 

% 
function DOSE2D=interPolate2D(x,y,z,DOSE3D,loc,orient)
    
  if (orient == 'x')
    index = interp1(x,1:length(x),loc);

    if (ceil(index) == floor(index))
        DOSE2D = reshape(DOSE3D(:,index,:),[length(y),length(z)]);
    else
        Plane1 = reshape(DOSE3D(:,floor(index),:),[length(y),length(z)]);
        Plane2 = reshape(DOSE3D(:,ceil(index),:),[length(y),length(z)]);
        DOSE2D = Plane1 + (Plane2 - Plane1)*(index-floor(index));
    end
  end


if (orient == 'y')
    
    % in RS statin, y axis is the Z axis in dicom and direction is
    % opposite. y=-z. 
    
    y=-y;

    index = interp1(y,1:length(y),loc,'nearest');
    
%     loc
%     
%     y1=y(index)
%     
%     y0=y(index-1)
    
    if loc == y(index)
        DOSE2D = reshape(DOSE3D(index,:,:),[length(x),length(z)]);
    else
        
        up_index=1;
        
        down_index=1;
        
        delta_y=1;
        
        if loc>y(index)
            
            down_index=index;
            
            up_index=index+1;
            
            delta_y=loc-y(index);
            
        end
        
        if loc<y(index)
            
            down_index=index-1;
            
            up_index=index;
            
            delta_y=loc-y(index-1);
            
        end
        
        Plane1 = reshape(DOSE3D(down_index,:,:),[length(x),length(z)]);
        Plane2 = reshape(DOSE3D(up_index,:,:),[length(x),length(z)]);
        
        interpolated_dose=Plane1 +delta_y*(Plane2 - Plane1)/(y(up_index)-y(down_index));
%         figure 
%         imshow(interpolated_dose)
%         
%         figure
%         
%         imshow(Plane1)
        DOSE2D = reshape(interpolated_dose,[length(x),length(z)]);
    end
end

if (orient == 'z')
    index = interp1(z,1:length(z),loc);

    if (ceil(index) == floor(index))
        DOSE2D = reshape(DOSE3D(:,:,index),[length(y),length(x)]);
    else
        Plane1 = reshape(DOSE3D(:,:,floor(index)),[length(y),length(x)]);
        Plane2 = reshape(DOSE3D(:,:,ceil(index)),[length(y),length(x)]);
        DOSE2D = reshape(Plane1 + (Plane2 - Plane1)*(index-floor(index)),[length(y),length(x)]);
    end
end
  
    
end 
    
    


function dose2D=interPolate3D(x,y,z,DOSE3D,loc,orient)
    
    orient='y';
    
       
    yy=(1:length(y))*loc;
    
    [X,Y,Z]=meshgrid(x,y,z);
    
    [Xq,Yq,Zq]=meshgrid(x,yy,z);
    
    interDose3D=interp3(X,Y,Z,DOSE3D,Xq,Yq,Zq);
    
    dose2DTemp= reshape(interDose3D(1,:,:),[length(x),length(z)]);
    
    dose2D=dose2DTemp;
    
end 
    
    