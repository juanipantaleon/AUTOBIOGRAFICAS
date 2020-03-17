clear all
close all

load('DATOS_ela.mat','DATOS')
S=10;
vec=[];
T=11;


for j=1:3
    for g=1:2
        for i=1:S
            n=0;
            for m=1:DATOS(j,g).trials(i)
                for t=1:T
                
                    todo(1).tipo(g).banda(j).sujetes(i).epocas(m).pli(:,:,t)=abs(DATOS(j,g).sujetes(i).PLIvsT(m,t).pli);
                    todo(1).tipo(g).banda(j).sujetes(i).tiempo(t).epocas(m).pli=abs(DATOS(j,g).sujetes(i).PLIvsT(m,t).pli);
                    
                    
                    n=n+1;
                    todo(1).tipo(g).banda(j).sujetes(i).pli_matriz(:,:,n)=abs(DATOS(j,g).sujetes(i).PLIvsT(m,t).pli);
                    
                end
            end
        end
    end
end

clear DATOS
load('DATOS_acc.mat','DATOS')

for j=1:3
    for g=1:2
        for i=1:S
            n=0;
            for m=1:length(DATOS(j,g).sujetes(i).epocas)
                for t=1:length(DATOS(j,g).sujetes(i).epocas(m).PLIvsT)
                
                    todo(2).tipo(g).banda(j).sujetes(i).epocas(m).pli(:,:,t)=abs(DATOS(j,g).sujetes(i).epocas(m).PLIvsT(t).pli);
                    todo(2).tipo(g).banda(j).sujetes(i).tiempo(t).epocas(m).pli=abs(DATOS(j,g).sujetes(i).epocas(m).PLIvsT(t).pli);
                    
                    n=n+1;
                    todo(2).tipo(g).banda(j).sujetes(i).pli_matriz(:,:,n)=abs(DATOS(j,g).sujetes(i).epocas(m).PLIvsT(t).pli);
                    
                end
            end
        end
    end
end


for j=1:3
        for i=1:S
            vec=[];
            for g=1:2
            vec=[vec reshape(todo(1).tipo(g).banda(j).sujetes(i).pli_matriz,1,[])...
                reshape(todo(2).tipo(g).banda(j).sujetes(i).pli_matriz(:,:,1:8),1,[])];
%                 vec=reshape(mat,1,[]);                 
%             umbrales(j,i).tipo(g).PLI_prom=mean(vec);
%             umbrales(j,i).tipo(g).PLI_desvi=std(vec);
%             umbrales(g).datos(j,i).PLIt_prom(h)=mean(vec);
%             umbrales(g).datos(j,i).PLIt_desvi(h)=std(vec);
            end
            umbrales.prom(j,i)=mean(vec);
            umbrales.desvi(j,i)=std(vec);
end
end
%                 
save('todo.mat','todo')
save('umbrales.mat','umbrales')


% 
% for j=1:3
%     for g=1:3 
%         for i=1:S
%             for t=1:T
%                 for m=1:d(j,g).sujetes(i).epocas
%             DATOS(j,1).sujetes(i).PLIvsT_binario(n,t).pli=abs(datos(j,g).sujetes(i).PLIvsT(m,t).pli)>=...
%                 umbrales(1).t_prom(j,i)+umbral*umbrales(1).t_desvi(j,i);
%             DATOS(j,1).sujetes(i).PLIvsT(n,t).pli=abs(datos(j,g).sujetes(i).PLIvsT(m,t).pli);
% %             DATOS(j,1).sujetes(i).pli_prom=datos(j,g).sujetes(i).PLI_prom;
%             
%             elseif g==3
%             DATOS(j,2).sujetes(i).PLIvsT_binario(m,t).pli=abs(datos(j,g).sujetes(i).PLIvsT(m,t).pli)>=...
%                 umbrales(2).t_prom(j,i)+umbral*umbrales(2).t_desvi(j,i);
%             
%             DATOS(j,2).sujetes(i).PLIvsT(m,t).pli=abs(datos(j,g).sujetes(i).PLIvsT(m,t).pli);
%             end
%             
%             
%             end
%         end
