function OUTEEG=epocas_dif(sujname,folderIn,folderOut,freq,tipo)

addpath('C:\Users\juani\Documents\DF\tesis\eeglab13_5_4b');
eeglab;

name=strcat(sujname,'.set');
 EEG = pop_loadset('filename',name, 'filepath', folderIn);
    EEG = eeg_checkset( EEG );
    
    filepathOut=folderOut;
     
n=0;
for i=1:length(EEG.event)
if i>1
    EEG.event(i).acceso=EEG.event(i-1).duracion;
end
end
    

tiempito=.5*freq;
n=0; m=0;

numero=2*tipo;

[OUTEEG,indices] = pop_epoch(EEG,{num2str(numero)},[-3 15]);
    OUTEEG = eeg_checkset( OUTEEG );
    
    OUTEEG = pop_saveset(OUTEEG, 'filename',name, 'filepath', filepathOut);
     OUTEEG = eeg_checkset( OUTEEG );

end
     