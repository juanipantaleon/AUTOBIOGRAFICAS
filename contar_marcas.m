close all
clear all
set(0,'DefaultFigureWindowStyle','docked')
%elegir sujeto
s=2
% sujetes={'juani','josefina','nacho',''}
sujetes={'niih','jmc','IV','cgv','ec','fm','lme','bm','josefina','lp','rocio'};
sujetes1={'niih','jmc','nacho','cristian','elias','federico','lucio','bruno','josefina','lucila','rocio'};
% abre el programa
% addpath('/home/usuario/matlab/eeglab13_5_4b');


addpath('C:\Users\juani\Documents\DF\tesis\eeglab13_5_4b');
eeglab
% for s=1:length(sujetes)
archivo2=strcat('marcas_eeg_',sujetes(s),'.mat')
archivo1=strcat(sujetes(s),'_datos.mat')
A1=importdata(archivo1{1});
A2 = importdata(archivo2{1});
puntajes=[A1.preguntas.t(:,2:3);A1.adivinanzas.t(:,2:3)];
lat=[A2.lat_marcas A2.lat_marcas_adi];
typ=[A2.typ_marcas A2.typ_marcas_adi];
%cambio typ
typ1=typ(1,:); typ1(typ1==3)=5; typ1(typ1==2)=3;
typ2=typ(2,:); typ2(typ2==2)=4;typ2(typ2==1)=2; typ2(typ2==3)=6;
typ(1,:)=typ1; typ(2,:)=typ2;
%de matriz a vector
vec_lat=reshape(lat,1,[])*1000;
vec_typ=reshape(typ,1,[]);
archivo3=strcat('C:\\Users\\juani\\Documents\\DF\\tesis\\marcas\\MAT\\',sujetes1(s),'-auto.TXT')
EEG = pop_importdata('dataformat','ascii','nbchan',0,'data',archivo3{1},'srate',256,'pnts',0,'xmin',0);
EEG.setname='DATOS';
EEG = eeg_checkset( EEG );
freq=256; tiempos=EEG.times;
ext=EEG.data(20:21,:); flancos=diff(ext,1,2);
flan=sum(flancos,1);
[m,marcas]=findpeaks(double(double(flan)),'MinPeakHeight',200);
% a=findpeaks(double(flancos(2,:)),'MinPeakHeight',200);
figure; hold on;
plot(marcas,m,'sr')
plot(flancos')
for i=1:length(marcas)
t_marcas(i)=tiempos(marcas(i));
end
hola=diff(t_marcas/1000)';
lat_marcas=diff(t_marcas);

l1=length(t_marcas)
l2=length(vec_lat)
vec_lat=vec_lat-vec_lat(1);
t_marcas=t_marcas-t_marcas(1);
figure
hold on
plot(vec_lat)
plot(t_marcas)

if l1==l2
CHECK=[vec_lat',t_marcas',[vec_lat-t_marcas]'];
% saca los canales externos
EEG = pop_select( EEG,'channel',[1:19 22:32] );
EEG = eeg_checkset( EEG );
t_mat=reshape(t_marcas,3,[]);
dif_mat=diff(t_mat);
marcas_mat=reshape(marcas,3,[]);
dif_mat_marcas=diff(marcas_mat);
n=0;
for i=1:length(t_mat)
if typ(3,i)~=0
for j=1:2
n=n+1;
EEG.event(n).latency=marcas_mat(j,i);
EEG.event(n).type=typ(j,i);
EEG.event(n).duracion=dif_mat(j,i);
EEG.event(n).emotidifi=puntajes(i,1);
EEG.event(n).detalles=puntajes(i,2);
if n>1
    EEG.event(n).acceso=EEG.event(n-1).duracion;
end
end
end
end
%     n=0;
% for i=1:length(puntajes)
%     if vec_typ(i)~=0
%         n=n+1;
%     EEG.event(n).emotidifi=puntajes(n,1);
%     EEG.event(n).detalles=puntajes(n,2);
%     %emocion difucultas
%     end
% end
EEG=pop_chanedit(EEG, 'load','30locations.xyz');
EEG = eeg_checkset( EEG );
archivo_out=strcat(sujetes1(s),'_eeg.set');
% Guarda los datos como .set
fileOut = ['C:\\Users\\juani\\Documents\\DF\\tesis\\marcas\\prepro','/']
EEG = pop_saveset( EEG, 'filename',archivo_out{1},'filepath',fileOut);
EEG = eeg_checkset( EEG );
% end
end