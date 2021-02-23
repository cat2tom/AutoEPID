function extended_epiddose= extendEPID(tpsdose,shifted_epiddose )
% Extend the EPIDdose to missing part.
% tps_dose and epiddose are dose matrix 400X400 over 40cm By 40cm field
% size. 

tpsdose_in=tpsdose;

epiddose_in=shifted_epiddose;

% fill isnan with 0

epiddose_in(isnan(epiddose_in))=0;

% normiazed the tps dose

max_epiddose=max(epiddose_in(:));

max_tpsdose=max(tpsdose_in(:));

norm_tpsdose=(tpsdose_in/max_tpsdose)*max_epiddose;

% get croped epid index

cropped_epid=shifted_epiddose>0;

norm_tpsdose(cropped_epid)=0;

% extended the epid.

extended_epiddose=norm_tpsdose+epiddose_in; 


end

