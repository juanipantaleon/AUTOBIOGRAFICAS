% heat map p/cada banda p/cada tipo de pregunta, promedios canales vs t
% c/cluster vs t
% fp1 fpz fp2 afz frontal
% pz p3 p4 poz o1 o2 central
% fz fc1 fc2 cz cp1 cp1 trasero
% c4 t8 cpz cp6 p8 izquierdo 
% c3 t7 cp5 p7 cp5 derecho

clear all
close all
set(0,'DefaultFigureWindowStyle','docked')
load('datos_lim.mat','datos_lim')
datos=datos_lim;
clear datos_lim

tipo={'primera vez que...','ultima vez que...','adivinanza'};
bandas={'theta','alpha','gamma'};

clusters(1).n=[1 30 9 28];%frontal
clusters(2).n=[19 4 12 29 5 13];%occipital
clusters(3).n=[17 20 21 18 24 25];%central
clusters(4).n=[11 14 15 27 16 23];%derecho
clusters(5).n=[3 6 7 26 8 22];%izquierdo

tiempos=[0:length(datos(1,1).sujetes(1).matriz)-1]/256-3;
largo=length(tiempos);
ventanas=linspace(1,largo,10);
S=10;

for j=1:3
    for g=1:3
        for i=1:S
            datos(j,g).sujetes(i).matriz_prom=mean(datos(j,g).sujetes(i).matriz,3);
            datos(j,g).matriz(:,:,i)=datos(j,g).sujetes(i).matriz_prom;
            datos(j,g).sujetes(i).epocas=size(datos(j,g).sujetes(i).matriz,3);

            for m=1:datos(j,g).sujetes(i).epocas
            datos(j,g).sujetes(i).hilbert(:,:,m)=hilbert(datos(j,g).sujetes(i).matriz(:,:,m)')';
            
            for h=1:30
            for k=1:30
                
                a=datos(j,g).sujetes(i).hilbert(h,:,m);
                b=datos(j,g).sujetes(i).hilbert(k,:,m);
                
            s=a.*conj(b);
            datos(j,g).sujetes(i).  PLI(h,k,m)=mean(sign(imag(s)));%/(mean(abs(imag(S))));
            end
            end
            end
        end
    end
end

% save('datos_PLI.mat','datos')
% load('datos_PLI.mat','datos')

% rangos=512:(largo-512)/4:(largo-512);
rangos=[0,384:384:largo-384];

%dinamic
%promedio por epocas
for j=1:3
    for g=1:3
        for i=1:S
            
            for m=1:datos(j,g).sujetes(i).epocas
            for t=1:length(rangos)-1
                for h=1:30
                    for k=1:30
%                 clear angulo angulo_dif angulo_prom
                
                a=datos(j,g).sujetes(i).hilbert(h,rangos(t)+1:rangos(t+1),m);
                b=datos(j,g).sujetes(i).hilbert(k,rangos(t)+1:rangos(t+1),m);
                
            s=a.*conj(b);
%             datos(j,g).sujetes(i).PLIvsT(h,k,t,m)=abs(mean(sign(imag(S))));%/(mean(abs(imag(S))));
            datos(j,g).sujetes(i).PLIvsT(m,t).pli(h,k)=mean(sign(imag(s)));
                end
            end
            end
            end
%             datos(j,g).red(h,k)=angulo_prom;
            end
            end
end

save('datos_PLI.mat','datos')
% load('datos_PLI.mat','datos')

%
rangos=[0,384:384:largo-384];
clear DATOS
S=10;
    for j=1:3
        for i=1:S
              
            
        n=0;
        for g=1:2
            for m=1:datos(1,g).sujetes(i).epocas
            if g<3
                n=n+1;
                for t=1:length(rangos)-1
            DATOS(j,1).sujetes(i).PLIvsT(n,t).pli=datos(j,g).sujetes(i).PLIvsT(m,t).pli;
            DATOS(j,1).sujetes(i).PLI(n).pli=datos(j,g).sujetes(i).PLI(:,:,m);
            
%             DATOS(j,1).sujetes(i).pli_prom=datos(j,g).sujetes(i).PLI_pro
                end
            end
            end
        end
        DATOS(j,2).sujetes(i).PLIvsT=datos(j,3).sujetes(i).PLIvsT;
        DATOS(j,1).trials(i)=n;
        DATOS(j,2).trials(i)=size(DATOS(j,2).sujetes(i).PLIvsT,1);
        end
    end
    
    
  save('DATOS_ela.mat','DATOS')

% 
% 
% for i=1:8
%     for j=1:3
%         for g=1:3
%         
% %             CONEC(j,g).prom(i,:)=degrees_und(datos(j,g).sujetes(i).PLIprom_binario);
% %             
%             for m=1:datos(j,g).sujetes(i).epocas
%                 
%             CONEC(j,g).epocas(i).elec(m,:)=degrees_und(datos(j,g).sujetes(i).PLI_binario(:,:,m));
%             
%             for t=1:length(rangos)-1
%             
%             CONEC(j,g).plivst(i).elec(t,:,m)=degrees_und(datos(j,g).sujetes(i).PLIvsT_binario(m,t).pli);
%             
%             end
%             end
%             CONEC(j,g).promvst.uno(:,:,i)=mean(CONEC(j,g).plivst(i).elec,3);
%             
%             CONEC(j,g).promvst.dos(:,:)=mean(CONEC(j,g).promvst.uno,3);
%             CONEC(j,g).promvst.tres(:)=mean(CONEC(j,g).promvst.dos(:,i),2);
%     end
%     end
% end

% save('datos_PLI.mat','datos')            
