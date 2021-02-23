function [Ex,Ey,extended_epiddose]= extendEPIDImagem(tpsdose,epiddose )
% Extend the EPIDdose to missing part.
% tps_dose and epiddose are dose matrix 400X400 over 40cm By 40cm field
% size. 

tpsdose_in=tpsdose;

epiddose_in=epiddose;

% normiazed the tps dose

max_epiddose=max(epiddose_in(:));

max_tpsdose=max(tpsdose_in(:));

norm_tpsdose=(tpsdose_in/max_tpsdose)*max_epiddose;

% 13 mm is maxim EPID magign area. get missing area 

row_index=[1:130  313:401];

col_index=[1:130  313:401];

epiddose_in(row_index,col_index)=norm_tpsdose(row_index,col_index);

Ex=-200:200;

Ey=-200:200;


extended_epiddose=epiddose_in;




end

