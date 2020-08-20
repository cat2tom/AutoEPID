function  speakFinished(  )
% small function to speak out when the autoEPID anaysis was finished.

% get voice enginee.
sp_voice=actxserver('SAPI.SpVoice');

sp_voice.Speak('Analysis was finished. Please check patient QA report and attached it to MOSAIQ. Thank you');


end

