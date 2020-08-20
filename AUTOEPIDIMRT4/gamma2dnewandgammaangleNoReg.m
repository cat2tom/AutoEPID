function [G, gammaAngle ] = gamma2dnewandgammaangleNoReg ( Reference, Evaluated ,DTA, dosed , minLim , localorglobal )
% this fucntion is used to calculate gamma map for 2D dose distribution.  

%This f u n ct i o n s doe s a gamma e v a l u at i o n out of th e two 2Dinput mat ri c e s
 %The r e s o l u t i o n of th e 2D input mat ri c e s should be in mm.They should be
 %s p a t i a l l y matched b e f o r e running t h i s f un cti on and have thesame s i z e .
 %DTA should be specified in mm, ex 3mm, and 
 %dose specified in %, ex 3 % is 0.03
 %minLim i s th e minimum t o l e r a n c e and can be s e t to z e ro i tshould a l s o be
 %s p e c i f i e l d in %, ex 5% i s i s 0 . 0 5 .
 
 
 size1 = size ( Reference );
 size2 = size ( Evaluated );
 %dosed = dosed ?max( Refe rence ( : ) );%D efin e s th e g l o b a l gamma
 
 % the maximum dose is 1 gy=100cm.
 
 tmp_max=100;%cGy to match the way how omimipro does.
 
%  minLim = minLim*max( Reference ( : ) ) ;
 
 minLim=minLim*tmp_max;
 %G = z e r o s ( s i z e 1 ) ;
 %gammaAngle = z e r o s ( s i z e 1 ) ;
 searchRange = round(2*DTA+1) ; % changed to 2 times of DTA to match OmiiPro.

if size1 == size2
  tic
 %This p a rt s adds a " bo rd e r " around both input mat ri c e so t h at th e gamma
 %e v a l u at i o n can be done f o r a l l p i x e l s
 tempReference = zeros ( size1+searchRange*2) ;
 tempReference(searchRange+1: size1( 1 )+searchRange,searchRange+1: size1(2)+searchRange ) = Reference ;
 tempEvaluated = zeros ( size2+searchRange*2) ;
 tempEvaluated ( searchRange+1: size1(1)+searchRange,searchRange+1: size1(2)+searchRange ) = Evaluated ;
 Reference = tempReference ;
 Evaluated = tempEvaluated ;
 G = zeros(size(Reference)) ;
 gammaAngle = zeros(size(Reference ) ) ;
 
 %d e f i n e s  the  global or  local  criteria
 if strcmpi( localorglobal, 'global')
     
     
    %dosed = zeros(size(Reference))+dosed*max(Reference(:)); 
    
    dosed = zeros(size(Reference))+dosed*tmp_max; % to match the OminiPro dose.
    
    elseif strcmpi(localorglobal,'local')
        
        dosed = Reference.*dosed ;
 end
     
 %Create the DTAsearch range and the DTAMatrix
 %The DTAMatrix is the same for each evaluated pixel
 DTAMatrix = zeros (2*searchRange+1,2*searchRange+1);
 %Sets the center position to 1
 DTAMatrix(searchRange+1,searchRange+1)= 1;
 %DTAMatrixSave = bwdist (DTAMatrix) ;
 %Calulates the euclidean distance to a l l points from the center point ,
 %divides with DTA?criterion and quadrates this matrice .
DTAMatrix=(bwdist(DTAMatrix)/DTA).^2;

positionAngle=zeros(size(Reference)) ;
X=zeros(size(positionAngle)) ;
Y=zeros(size(positionAngle)) ;
Size=(2*searchRange+1) ;

X(1:Size,round(Size/2))=1;
Y(round(Size/2),1:Size) = 1;
X=bwdist(X) ;
Y=bwdist(Y) ;
X(:,1:round(Size/2))= X(:,1:round(Size/2))*-1;
Y(round(Size/2):Size,:)=Y(round(Size/2):Size,:)*-1;
Angle=(atan2(Y,X)/pi*180) ;

%Defines the vectors for dose difference calculation
x =-(searchRange):1:(searchRange);
y =-(searchRange):1:(searchRange);

for i = searchRange +1: size1(1)+searchRange
  for j = searchRange +1: size1(2)+ searchRange
     if Reference ( i , j ) < minLim %This part skips "unessecary" pixels
        G(i,j)= 0;
       continue
     end

    doseDiffSave =((Reference(i,j)-Evaluated(i+x,j+y))) ;%/dosed ) .^2;
    doseDiff =(doseDiffSave./dosed(i,j)).^2;

    %The Gamma matrice
    Ga =DTAMatrix+doseDiff;   
    
  %minimum of Gamma
 G(i,j)=min(Ga(:));
 MinGa=min(Ga(:));
 [r c ]=find(Ga==MinGa) ;
 [mr nr]=size(r);
 [mc nc]=size(c);
 if numel(r)~= 0
     
    if mr==1&&mc==1&&nr==1 && nc==1

       gammaAngle(i,j)=atan(DTAMatrix(r(1),c(1))/abs(doseDiff(r(1),c(1)))) ;
       positionAngle(i,j)=Angle(r(1),c(1));
    elseif(r(1)-(searchRange+1) )^2 + (c(1)-(searchRange+1))^2==(r(2)-(searchRange+1))^2+(c(2)-(searchRange+1))^2
        
       gammaAngle(i,j)=atan(DTAMatrix(r(1),c(1))/abs(doseDiff(r(1), c(1)))) ;
       positionAngle(i,j)= Angle(r(1), c(1)) ;
    elseif(r(1)-(searchRange+1))^2+(c(1)-(searchRange+1) )^2 >(r(2)-(searchRange+1))^2+(c(2)-(searchRange+1) )^2
        
       gammaAngle(i,j)=atan(DTAMatrix(r(2),c(2))/abs(doseDiff(r(2),c(2)))) ;
       positionAngle(i,j)= Angle ( r ( 2 ) , c ( 2 ) ) ;
    elseif(r(1)-(searchRange+1))^2 +(c(1)-(searchRange+1))^2 <(r(2)-(searchRange+1))^2 +(c(2)-(searchRange+1) )^2
        
       gammaAngle(i,j)=atan(DTAMatrix(r(1),c(1))/abs(doseDiff(r(1), c(1)))) ;
       positionAngle(i,j)=Angle(r(1), c(1)) ;
    end
  end 
 end
end 

%c a l c u l a t e s th e gamma
G = sqrt (G) ;
fprintf( 'Elapsed?time?for?gamma?evaluation:?%6.4 f?seconds \n' ,toc ) ;

%Removes the added border

G(1:searchRange,:)=[ ];
G(:,1:searchRange)=[ ] ;
G(size1(1)+1:size1(1)+searchRange,:)=[ ];
G(:,size1(2)+1:size1(2)+searchRange ) = [ ] ;
gammaAngle ( 1 : searchRange , : ) = [ ] ;
gammaAngle ( : , 1 : searchRange ) = [ ] ;
gammaAngle(size1(1)+1:size1(1)+searchRange,: ) = [ ] ;
gammaAngle(:,size1(2)+1:size1(2)+searchRange ) = [ ] ;
positionAngle(1:searchRange,:)=[ ] ;
positionAngle (:,1:searchRange)=[ ] ;
positionAngle(size1(1)+1:size1(1)+searchRange,: ) = [ ] ;
positionAngle(:, size1(2)+1:size1(2)+searchRange ) = [ ] ;

else
   fprintf('Matrix?sizes?does?not?agree\n' );
end


end
    
    