clear all

load('datos_ac.mat','datos_ac')
load('datos_1.mat','datos')

% % clear a

% save('datos_ac.mat','datos_ac')
datos_ac_lim=datos_ac;


clear check
n=0;
for j=1:3
    for g=1:3
        for i=1:10
        datos_lim(j,g).sujetes(i).matriz=datos(j,g).sujetes(i).matriz;
            
        n=0;
            for m=1:length(datos(j,g).sujetes(i).eventos)
                if datos(j,g).sujetes(i).eventos(m).type==2*g;
%                     
                    n=n+1;
                    datos_lim(j,g).sujetes(i).eventos(n)=datos(j,g).sujetes(i).eventos(m);
                    
%                     datos_lim(j,g).sujetes(i).matriz(:,:,n)=datos(j,g).sujetes(i).matriz(:,:,m);
%                     n=n-1;
                end
            end
            
            n=0;
%             for m=1:length(datos_ac(j,g).sujetes(i).Eventos)-1
%                 if datos_ac(j,g).sujetes(i).eventos(m).type==0
% %                         datos_ac(j,g).sujetes(i).Eventos(m).epoch~=datos(j,g).sujetes(i).Eventos(m+1).epoch
%                     
%                     n=n+1;
%                     datos_ac_lim(j,g).sujetes(i).eventos(n)=datos_ac(j,g).sujetes(i).Eventos(m);
%                     datos_ac_lim(j,g).sujetes(i).epocas(n).matriz=datos_ac(j,g).sujetes(i).epocas(m).matriz;
% %                     n=n-1;
%                 end
%             end
%             
                check(j,g).sujetes(i).matriz=[datos_lim(j,g).sujetes(i).eventos(:).duracion];
                check(j,g).sujetes(i).cant=length(check(j,g).sujetes(i).matriz);
                check(j,g).sujetes(i).matriz_ac=[datos_ac_lim(j,g).sujetes(i).eventos(:).duracion];
                check(j,g).sujetes(i).cant_ac=length(check(j,g).sujetes(i).matriz_ac);
                
        end
    end
end
n=0;
k=0;
l=0;
for j=1:3
    for g=1:3
        for i=1:10
            
            m1=size(datos_lim(j,g).sujetes(i).matriz,3);
            m2=length(datos_lim(j,g).sujetes(i).eventos);
            
            m3=length(datos_ac_lim(j,g).sujetes(i).epocas);
            m4=length(datos_ac_lim(j,g).sujetes(i).eventos);
            
            n=n+1;
            hola(n,:)=[m1 m2];
            
            if m1~=m2
                k=k+1;
                a(k,:)=[j,g,i,m1,m2,m3,m4];
            end
            
            if m3~=m4
                l=l+1;
                b(l,:)=[j,g,i,m3,m4];
            end
            
        end
    end
end

% % 
save('datos_lim.mat','datos_lim')


j=1;
    for g=1:3
        for i=1:10
            eventos(g,i).mat=datos_lim(j,g).sujetes(i).eventos;
        end
    end
    
    save('eventos.mat','eventos')
% save('datos_ac_lim.mat','datos_ac_lim')