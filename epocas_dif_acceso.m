function [data,even]=epocas_dif(sujname,folderIn,folderOut,freq,tipo)

clear data; clear even; clear quesi;
addpath('C:\Users\juani\Documents\DF\tesis\eeglab13_5_4b');
eeglab;

name=strcat(sujname,'.set');
    EEG = pop_loadset('filename',name, 'filepath', folderIn);
    EEG = eeg_checkset( EEG );
    
    filepathOut=folderOut;
     
n=0;
numero=2*tipo-1;
    quiero=[EEG.event(:).type]==numero;
    quesi=[];
    
for i=1:length(EEG.event)
    if EEG.event(i).type==numero
        n=n+1;
        EEG.event(i).type=n;
        quesi=[quesi i];
    else
        EEG.event(i).type=0;
    end
end

%     EEG.event(i).acceso=EEG.event(i-1).duracion;
% end
% end
    
tiempito=.5*freq;
% n=0; m=0;

for i=1:n
    clear OUTEEG
[OUTEEG,indices] = pop_epoch(EEG,{num2str(i)},[0 EEG.event(quesi(i)).duracion/1000]);
    OUTEEG = eeg_checkset( OUTEEG );
    quesi(i)
    num2str(i)
    EEG.event(quesi(i)).type
    
 data(i).matriz=OUTEEG.data;
 even(i)=OUTEEG.event(1);
 
end
%     OUTEEG = pop_saveset(OUTEEG, 'filename',name, 'filepath', filepathOut);
%      OUTEEG = eeg_checkset( OUTEEG );

end
     