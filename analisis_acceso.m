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
load('datos_ac_lim.mat','datos_ac_lim')
datos=datos_ac_lim;
clear datos_ac

tipo={'primera vez que...','ultima vez que...','adivinanza'};
bandas={'theta','alpha','gamma'};

clusters(1).n=[1 30 9 28];%frontal
clusters(2).n=[19 4 12 29 5 13];%occipital
clusters(3).n=[17 20 21 18 24 25];%central
clusters(4).n=[11 14 15 27 16 23];%derecho
clusters(5).n=[3 6 7 26 8 22];%izquierdo

% tiempos=[0:length(datos(1,1).sujetes(1).matriz)-1]/256-2;
% largo=length(tiempos);
% ventanas=linspace(1,largo,10);
S=10;

j=1;
    for g=1:3
        for i=1:S
            hola=[];
            datos(j,g).sujetes(i).cant=length(datos(j,g).sujetes(i).epocas);
            for m=1:datos(j,g).sujetes(i).cant
            hola(m)=length(datos(j,g).sujetes(i).epocas(m).matriz);
            end
            largos(i,g)=max(hola);
        end
    end
    Largos=max(largos);
    

for j=1:3
    for g=1:3
        for i=1:S
            
            for m=1:datos(1,g).sujetes(i).cant
            datos(j,g).sujetes(i).epocas(m).hilbert=hilbert(datos(j,g).sujetes(i).epocas(m).matriz')';
            
            for h=1:30
            for k=1:30
%                 
                a=datos(j,g).sujetes(i).epocas(m).hilbert(h,:);
                b=datos(j,g).sujetes(i).epocas(m).hilbert(k,:);
%                 
            s=a.*conj(b);
            datos(j,g).sujetes(i).epocas(m).PLI(h,k)=mean(sign(imag(s)));%/(mean(abs(imag(S))));
            end
            end
%             
            datos(j,g).sujetes(i).epocas(m).hil_r=flip(datos(j,g).sujetes(i).epocas(m).hilbert,2);
            end 
        end
    end
end
% save('datos_PLI.mat','datos')
% load('datos_PLI.mat','datos')

for g=1:3
Rangos(g).vec=[0,384:384:Largos(g)];
T(g)=length(Rangos(g).vec)-1;
end


%dinamic
%promedio por epocas
for j=1:3
    for g=1:3
        for i=1:S
            
            for m=1:datos(1,g).sujetes(i).cant
            largo=length(datos(j,g).sujetes(i).epocas(m).matriz);
                rangos=[0,384:384:largo,largo];
                ti=length(rangos);
                for t=1:ti-1
                for h=1:30
                    for k=1:30

                a=datos(j,g).sujetes(i).epocas(m).hil_r(h,rangos(t)+1:rangos(t+1));
                b=datos(j,g).sujetes(i).epocas(m).hil_r(k,rangos(t)+1:rangos(t+1));
                
            s=flip(a).*conj(flip(b));
            
            datos(j,g).sujetes(i).epocas(m).PLIvsT(t).pli(h,k)=mean(sign(imag(s)));
                end
                end
%                     else
%             datos(j,g).sujetes(i).PLIvsT(m,t).pli(1:30,1:30)=NaN;
%                     end
            end
            end
%             datos(j,g).red(h,k)=angulo_prom;
            end
            end
end

save('datos_ac_PLI.mat','datos')
% load('datos_ac_PLI.mat','datos')

    for j=1:3
        for i=1:S
        n=0;
        for g=1:3 
            for m=1:datos(1,g).sujetes(i).cant
            DATOS_ac_3(j,g).sujetes(i).epocas(m).PLIvsT=datos(j,g).sujetes(i).epocas(m).PLIvsT;
                
                if g<3
                n=n+1;
            DATOS(j,1).sujetes(i).epocas(n).PLIvsT=datos(j,g).sujetes(i).epocas(m).PLIvsT;
            DATOS(j,1).sujetes(i).epocas(n).PLI=datos(j,g).sujetes(i).epocas(m).PLI;
            
            
            elseif g==3
%             DATOS(j,2).sujetes(i).epocas(m).PLIvsT_binario(t).pli=abs(datos(j,g).sujetes(i).PLIvsT_binario(m,t).pli);
            DATOS(j,2).sujetes(i).epocas(m).PLIvsT=datos(j,g).sujetes(i).epocas(m).PLIvsT;
            DATOS(j,2).sujetes(i).epocas(m).PLI=datos(j,g).sujetes(i).epocas(m).PLI;
            
                end
            end
        end
        trials(1,i)=n;
        trials(2,i)=m;
    end
    end
    
  save('DATOS_acc.mat','DATOS')
    
    
save('DATOS_ac_3.mat','DATOS_ac_3')