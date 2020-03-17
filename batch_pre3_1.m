% i=2,   no pude sacar ICA ocular
close all; clear all; clc
addpath('C:\Users\juani\Documents\DF\tesis\eeglab13_5_4b');
eeglab;

%elegir sujeto
i=1
sujetes={'jmc','niih','cristian','elias','federico','lucio','bruno','josefina','lucila','rocio'};%,'celena'};
sujname = strcat(sujetes(i),'_eeg')
sujete={'jmc','niih','cristian','elias','federico','lucio','bruno','josefina','lucila','rocio'};

folderMain  = 'C:/Users/juani/Documents/DF/tesis/marcas/prepro';

freq = 256;
params.limInf = 0.75;
params.limSup = 48;

theta=[4,8]; alfa=[8,13]; gamma=[27,45];

frecuencias=[theta;alfa;gamma];
frecs={'theta','alpha','gamma'};

%% Datos continuos
% clear all
close all
folderIn  = [folderMain]; 
folderOut = [folderMain,'/filtrados'];

% for i=1:length(sujetes)
    sujname = strcat(sujetes(i),'_eeg');
    EEG = preanalisis3_1(sujname{1},folderIn,folderOut,freq,'1',params); % Open BDF, delete unsued channels, and save as SET
% end

    
%% Calcula ICA y lo saca
folderIn = [folderMain,'/filtrados'];
folderOut = [folderMain,'/filtrados/ICA'];
% for i=1:length(sujname)
    sujname = strcat(sujetes(i),'_eeg');
    EEG = preanalisis3_1(sujname{1},folderIn,folderOut,freq,'2',params);
% end

%% Mirar los datos y decidir que canales sacars08

close all
sujname = strcat(sujetes(i),'_eeg');
addpath('C:\Users\juani\Documents\DF\tesis\eeglab13_5_4b');
eeglab;
name=strcat(sujname,'.set');
    
folderIn = [folderMain,'/filtrados/ICA'];
folderOut = [folderMain,'/filtrados/ICA'];

filepathIN  = folderIn;
    filepathOUT = folderOut;

    freqname    = num2str(freq);

    EEG = pop_loadset('filename',name, 'filepath', filepathIN);
    EEG = eeg_checkset( EEG );
    EEG.setname

    eeglab redraw;
figure; 
    pop_eegplot( EEG, 1, 1, 1);
figure; 
    pop_spectopo(EEG, 1, [EEG.xmin EEG.xmax], 'EEG' , 'percent', 15, 'freqrange',[1 48],'electrodes','off');

%% Datos continuos
% clear all
close all
folderIn = [folderMain,'/filtrados/ICA'];
folderOut = [folderMain,'/filtrados/ICA/interpola1'];

% for i=1:length(sujname)
    sujname = strcat(sujetes(i),'_eeg');
    prompt = {'Canales a interpola:'};
    dlg_title = 'Input';
    num_lines = 1;
    def = {''};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    params.badCh = str2double(strsplit(char(answer)));
    EEG = preanalisis3_1(sujname{1},folderIn,folderOut,freq,'3',params);
% end


%% bandas
theta=[4,8]; alfa=[8,13]; gamma=[27,45];

frecuencias=[theta;alfa;gamma];
frecs={'theta','alpha','gamma'};

folderIn  = [folderMain,'/filtrados/ICA/interpola1']; 
% folderOut = [folderMain,'/filtrados/ICA/interpola/epocas/bandas'];

 for i=1:length(sujetes)
    for j=1:3
        close all
    folderOut = [folderMain,'/filtrados/ICA/interpola1/bandas/',frecs{j}];
    sujname = strcat(sujetes(i),'_eeg');
    
    params.limInf = frecuencias(j,1);
    params.limSup = frecuencias(j,2);

    EEG = preanalisis3_1(sujname{1},folderIn,folderOut,freq,'1',params); % Open BDF, delete unsued channels, and save as SET
    end
end


%% Datos en epocas sin filtrar
% clear all
close all
folderIn = [folderMain,'/filtrados/ICA/interpola1'];
folderOut = [folderMain,'/filtrados/ICA/interpola1/epocas'];

for i=1:length(sujete)
    for g=1:3
    close all
            tipo=g;
            folderIn = [folderMain,'/filtrados/ICA/interpola1'];
            folderOut = [folderMain,'/filtrados/ICA/interpola1/',tipos{g}];
            sujname = strcat(sujete(i),'_eeg');
            OUTEEG=epocas_dif(sujname{1},folderIn,folderOut,freq,tipo);
%             res(i,g).datos(j).matriz=OUTEEG.data;
            datos_sinfil(g).sujetes(i).matriz=OUTEEG.data;
            datos_sinfil(g).sujetes(i).eventos=OUTEEG.event;
        end
end
save('datos_sinfil.mat','datos_sinfil');
T_MIN=min(T_min);

%% por tipo de preguntas

tipos={'primera','ultima','adivinanza'};

for i=1:length(sujete)
    for j=1:3
        for g=1:3
            close all
            tipo=g;
            folderIn = [folderMain,'/filtrados/ICA/interpola1/bandas/',frecs{j}];
            folderOut = [folderMain,'/filtrados/ICA/interpola1/bandas/',frecs{j},'/',tipos{g}];
            sujname = strcat(sujete(i),'_eeg');
            
           
            OUTEEG=epocas_dif(sujname{1},folderIn,folderOut,freq,tipo);
%             res(i,g).datos(j).matriz=OUTEEG.data;
            datos(j,g).sujetes(i).matriz=OUTEEG.data;
            datos(j,g).sujetes(i).eventos=OUTEEG.event;
        end
    end
end
save('datos_1.mat','datos')

%% acceso

tipos={'primera','ultima','adivinanza'};

for i=1:length(sujete)
    for j=1:3
        for g=1:3
            close all
            tipo=g;
            folderIn = [folderMain,'/filtrados/ICA/interpola1/bandas/',frecs{j}];
            folderOut = [folderMain,'/filtrados/ICA/interpola1/bandas/',frecs{j},'/',tipos{g}];
            sujname = strcat(sujete(i),'_eeg');
           
            [data,even]=epocas_dif_acceso(sujname{1},folderIn,folderOut,freq,tipo);
%             res(i,g).datos(j).matriz=OUTEEG.data;
            datos_ac(j,g).sujetes(i).epocas=data;
            datos_ac(j,g).sujetes(i).eventos=even;
        end
    end
end
save('datos_ac.mat','datos_ac')

