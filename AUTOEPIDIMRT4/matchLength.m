function [rowrange,colrange,choppedEx,choppedEy]=matchLength(Ex,Ey,nx,ny)

    ex_len=length(Ex);
    
    ey_len=length(Ey);

   
     if mod(nx,2)==0
         
         colrange1=(ex_len/2-nx/2):ex_len/2;
         
         colrange2=(ex_len/2+1):(ex_len/2+nx/2-1);
         
         colrange=[colrange1 colrange2];
         
         choppedEx=Ex(colrange);
         
%          choppedEx=[Ex((ex_len/2-nx/2):ex_len/2)  Ex(ex_len/2+1:(nx/2-1))];
        
         
     else
         
         
         tnx=nx+1;
        
         colrange1=(ex_len/2-(tnx/2-1):ex_len/2);
         
         colrange2=(ex_len/2+1:ex_len/2+tnx/2-1);
         
         colrange=[colrange1 colrange2];
         
         choppedEx=Ex(colrange);
         
%          choppedEx=[Ex((ex_len/2-(tnx/2-1)):ex_len/2)  Ex(ex_len/2+1:(tnx/2-2))];
        
         
     end 
     
     if mod(ny,2)==0
         
         rowrange1=(ey_len/2-ny/2):ey_len/2;
         
         rowrange2=(ey_len/2+1):(ey_len/2+ny/2-1);
         
         rowrange=[rowrange1 rowrange2];
         
         choppedEy=Ey(rowrange);
            
         
%          choppedEy=[Ey((ey_len/2-ny/2):ey_len/2)  Ey(ey_len/2+1:(ny/2-1))]; 
         
     else
         
         tny=ny+1;
         rowrange1=(ey_len/2-(tny/2-1):ey_len/2);
         
         rowrange2=(ey_len/2+1:ey_len/2+tny/2-1);
         
         rowrange=[rowrange1 rowrange2];
         
         choppedEy=Ey(rowrange);
        
%          choppedEy=[Ey((ey_len/2-(tny/2-1)):ey_len/2)  Ey(ey_len/2+1:(tny/2-2))];
         
     end 