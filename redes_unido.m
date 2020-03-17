clear all; close all;

set(0,'DefaultFigureWindowStyle','normal')
load('todo.mat','todo')
load('umbrales.mat','umbrales')
% (1+sqrt(5))/2
umbral=(1+sqrt(5))/2;
S=10;
T(1)=10; T(2)=8;
ancho=19;

clusters(1).n=[1 30 9 28];%frontal
clusters(2).n=[17 20 21 18 24 25];%central
clusters(3).n=[19 4 12 29 5 13];%occipital
clusters(5).n=[11 14 15 27 16 23];%derecho
clusters(4).n=[3 6 7 26 8 22];%izquierdo

nombres={'Frontal','Central','Occipital','Izquierdo','Derecho'};
nom={'Fro','Cen','Occ','Izq','Der'};
cant=[6,6,6,6,6];
lineas=[0 cumsum(cant)];
pos=[0,6,12,18,24];
cant_1=[4,6,6,6,6];

orden=[1 30 9 28 2 10 17 20 21 18 24 25 19 4 12 29 5 13 3 6 7 26 8 22 11 14 15 27 16 23];
canales={'fp1','f3','c3','p3','o1','f7','t7','p7','fp2','f4','c4','p4','o2','f8','t8','p8','fz','cz','pz','fc1','fc2','fc5','fc6','cp1','cp2','cp5','cp6','afz','poz','fpz'};

%% computos
for h=1:2
    for j=1:3
        for g=1:2
         for i=1:S   
                cuenta=zeros(1,100);
                limp(h,g).grados(i,j).vec=[];
                for m=1:length(todo(h).tipo(g).banda(j).sujetes(i).epocas)
                    todo(h).tipo(g).banda(j).sujetes(i).epocas(m).links=...
                    todo(h).tipo(g).banda(j).sujetes(i).epocas(m).pli>=umbrales.prom(j,i)+umbral*umbrales.desvi(j,i);
%                  
                    for t=1:size(todo(h).tipo(g).banda(j).sujetes(i).epocas(m).pli,3)
                    %2 desvis
                   
                    cuenta(t)=cuenta(t)+1;
                    
                    todo(h).tipo(g).banda(j).tiempo(t).sujetes(i).links(:,:,cuenta(t))=todo(h).tipo(g).banda(j).sujetes(i).epocas(m).links(:,:,t);
                    todo(h).tipo(g).banda(j).tiempo(t).sujetes(i).pli(:,:,cuenta(t))=todo(h).tipo(g).banda(j).sujetes(i).epocas(m).pli(:,:,t);
                    
                %grado epoca
                    todo(h).tipo(g).banda(j).tiempo(t).sujetes(i).medidas(1,cuenta(t))=nanmean(degrees_und(todo(h).tipo(g).banda(j).sujetes(i).epocas(m).links(:,:,t)));
                    limp(h,g).grados(i,j).vec=[limp(h,g).grados(i,j).vec nanmean(degrees_und(todo(h).tipo(g).banda(j).sujetes(i).epocas(m).links(:,:,t)))];
                    %clusterin
                    todo(h).tipo(g).banda(j).tiempo(t).sujetes(i).medidas(2,cuenta(t))=nanmean(clustering_coef_bu(todo(h).tipo(g).banda(j).sujetes(i).epocas(m).links(:,:,t)));
                    %path epoca
                    todo(h).tipo(g).banda(j).tiempo(t).sujetes(i).medidas(4,cuenta(t))=charpath(distance_bin(todo(h).tipo(g).banda(j).sujetes(i).epocas(m).links(:,:,t)),0,0);
                    %eficciency
                    todo(h).tipo(g).banda(j).tiempo(t).sujetes(i).medidas(3,cuenta(t))=efficiency_bin(todo(h).tipo(g).banda(j).sujetes(i).epocas(m).links(:,:,t));                    
                    % grado electrodos
                    todo(h).tipo(g).banda(j).tiempo(t).sujetes(i).electrodos(:,cuenta(t))=degrees_und(todo(h).tipo(g).banda(j).sujetes(i).epocas(m).links(:,:,t));
%                                     todo(h).tipo(g).banda(j)grado_medio(t,i)=nanmean(todo(h).tipo(g).banda(j).tiempo(t).sujetes(i).medidas(1,:))
                    end  
                end
                %limpieza
                prom=mean(limp(h,g).grados(i,j).vec);
                    desvi=std(limp(h,g).grados(i,j).vec);
                for t=1:T(h)
                    for m=1:size(todo(h).tipo(g).banda(j).tiempo(t).sujetes(i).medidas,2)
                        caso=todo(h).tipo(g).banda(j).tiempo(t).sujetes(i).medidas(1,m);
                        if caso>prom+5*desvi;
                            todo(h).tipo(g).banda(j).tiempo(t).sujetes(i).medidas(1,m)=nan;
                        end
                    end
                end       
         end    
                for t=1:T(h)                    
                    for i=1:S
                        
                        if length(todo(h).tipo(g).banda(j).sujetes(i).tiempo)>=t   
                 %PROMEDIOS EPOCALES
                    %matrices prom
                todo(h).tipo(g).banda(j).tiempo(t).links_prom(:,:,i)=nanmean(todo(h).tipo(g).banda(j).tiempo(t).sujetes(i).links,3);
                todo(h).tipo(g).banda(j).tiempo(t).pli_prom(:,:,i)=nanmean(todo(h).tipo(g).banda(j).tiempo(t).sujetes(i).pli,3);
                    %medidas
                    for k=1:4
                todo(h).tipo(g).banda(j).tiempo(t).medidas_media(k,i)=nanmean(todo(h).tipo(g).banda(j).tiempo(t).sujetes(i).medidas(k,:));
                todo(h).tipo(g).banda(j).medidas_suj(k).media(i,t)=todo(h).tipo(g).banda(j).tiempo(t).medidas_media(k,i);
                    end
                todo(h).tipo(g).banda(j).tiempo(t).electrodos_medio(:,i)=nanmean(todo(h).tipo(g).banda(j).tiempo(t).sujetes(i).electrodos,2);
                        end
                    end
                %PROMEDIOS INTERSUJETOS
                %matrices
                todo(h).tipo(g).banda(j).matriz_prom(:,:,t)=nanmean(todo(h).tipo(g).banda(j).tiempo(t).links_prom,3);
                
                %medidas
                for k=1:4
                todo(h).tipo(g).banda(j).medidas(k,t)=nanmean(todo(h).tipo(g).banda(j).tiempo(t).medidas_media(k,:));
                todo(h).tipo(g).banda(j).medidas_e(k,t)=nanstd(todo(h).tipo(g).banda(j).tiempo(t).medidas_media(k,:))/sqrt(S);
                end
               
                end
                
                %junto tiempos: matriz prom, z.score
   
                hola=1:2:T(h);
 
                for t=1:length(hola)
                    todo(h).tipo(g).banda(j).matriz_2(:,:,t)=mean(todo(h).tipo(g).banda(j).matriz_prom(:,:,hola(t):hola(t)+1),3);
                %z_score
                todo(h).tipo(g).banda(j).links(t).vector=sum(todo(h).tipo(g).banda(j).matriz_2(:,:,t));
                todo(h).tipo(g).banda(j).vector(t,:)=todo(h).tipo(g).banda(j).links(t).vector;
                todo(h).tipo(g).banda(j).links(t).prom_z=mean(todo(h).tipo(g).banda(j).links(t).vector);
                todo(h).tipo(g).banda(j).links(t).desvi_z=std(todo(h).tipo(g).banda(j).links(t).vector);
                todo(h).tipo(g).banda(j).z_score(t,:)=...
                              (todo(h).tipo(g).banda(j).links(t).vector-todo(h).tipo(g).banda(j).links(t).prom_z)/todo(h).tipo(g).banda(j).links(t).desvi_z;
                          [Y,todo(h).tipo(g).banda(j).canales(t,:)]=sort(todo(h).tipo(g).banda(j).z_score(t,:),2,'descend');
                          todo(h).tipo(g).banda(j).canales_n=canales(todo(h).tipo(g).banda(j).canales(t,:));
                end
                
                %orden
                for l=1:30
                todo(h).tipo(g).banda(j).z_or(:,l)=todo(h).tipo(g).banda(j).z_score(:,orden(l));
                todo(h).tipo(g).banda(j).v_or(:,l)=todo(h).tipo(g).banda(j).vector(:,orden(l));
                
                for k=1:30
                    todo(h).tipo(g).banda(j).matriz_or(l,k,:)=todo(h).tipo(g).banda(j).matriz_2(orden(l),orden(k),:);
                end
                end
                
                todo(h).tipo(g).banda(j).medidas_prom=nanmean(todo(h).tipo(g).banda(j).medidas,2);
                todo(h).tipo(g).banda(j).medidas_prom_e=nanstd(todo(h).tipo(g).banda(j).medidas,0,2);
        
                %invierto tiempo
                if h==2;
            todo(h).tipo(g).banda(j).medidas=flip(todo(h).tipo(g).banda(j).medidas,2);
            todo(h).tipo(g).banda(j).medidas_e=flip(todo(h).tipo(g).banda(j).medidas_e,2);
            for k=1:4
            todo(h).tipo(g).banda(j).medidas_suj(k).media=flip(todo(h).tipo(g).banda(j).medidas_suj(k).media,2);
            end
            todo(h).tipo(g).banda(j).matriz_2=flip(todo(h).tipo(g).banda(j).matriz_2,3);
            todo(h).tipo(g).banda(j).matriz_or=flip(todo(h).tipo(g).banda(j).matriz_or,3);
            
            todo(h).tipo(g).banda(j).z_score=flip(todo(h).tipo(g).banda(j).z_score);
            todo(h).tipo(g).banda(j).z_or=flip(todo(h).tipo(g).banda(j).z_or);
            todo(h).tipo(g).banda(j).vector=flip(todo(h).tipo(g).banda(j).vector);
            todo(h).tipo(g).banda(j).v_or=flip(todo(h).tipo(g).banda(j).v_or);
            
            
                end
        end
end
end

%% junto

for g=1:2
    for j=1:3
    
    graf(g,j).medidas=[todo(2).tipo(g).banda(j).medidas(:,1:end-2) todo(1).tipo(g).banda(j).medidas];
    graf(g,j).medidas_e=[todo(2).tipo(g).banda(j).medidas_e(:,1:end-2) todo(1).tipo(g).banda(j).medidas_e];
    for k=1:4
    graf(g,j).medidas_suj(k).media=[todo(2).tipo(g).banda(j).medidas_suj(k).media(:,1:end-2) todo(1).tipo(g).banda(j).medidas_suj(k).media];
    end
    graf(g,j).z_or=[todo(2).tipo(g).banda(j).z_or(2:3,:);todo(1).tipo(g).banda(j).z_or(1:4,:)];
    graf(g,j).z_score=[todo(2).tipo(g).banda(j).z_score(2:3,:);todo(1).tipo(g).banda(j).z_score(1:4,:)];
    graf(g,j).canales=[todo(2).tipo(g).banda(j).canales(2:3,:);todo(1).tipo(g).banda(j).canales(1:4,:)];
    graf(g,j).vector=[todo(2).tipo(g).banda(j).vector(2:3,:);todo(1).tipo(g).banda(j).vector(1:4,:)];
    graf(g,j).v_or=[todo(2).tipo(g).banda(j).v_or(2:3,:);todo(1).tipo(g).banda(j).v_or(1:4,:)];
    
    
    graf(g,j).matriz=cat(3,todo(2).tipo(g).banda(j).matriz_2(:,:,2:3),todo(1).tipo(g).banda(j).matriz_2(:,:,1:4));
    graf(g,j).matriz_or=cat(3,todo(2).tipo(g).banda(j).matriz_or(:,:,2:3),todo(1).tipo(g).banda(j).matriz_or(:,:,1:4));
    
    vec=reshape(cat(3,todo(2).tipo(g).banda(j).matriz_2,todo(1).tipo(g).banda(j).matriz_2),1,[]);
    prom=mean(vec); desvi=std(vec);
    graf(g,j).redes=graf(g,j).matriz>=prom+desvi;
    
    end
end

%% DETALLES Y ACCESO
load('eventos.mat','eventos')
EV=eventos;
clear eventos

    for i=1:S
eventos(i,1).ev=[EV(1,i).mat EV(2,i).mat];
eventos(i,2).ev=EV(3,i).mat;
    end

    n=0;
for g=1:2
    for i=1:S
        eventos(i,g).acc_m=nanmedian([eventos(i,g).ev(:).acceso]);
        eventos(i,g).det_m=nanmedian([eventos(i,g).ev(:).detalles]);
        
        eventos(i,g).acc_c(1).vec=[eventos(i,g).ev(:).acceso]>eventos(i,g).acc_m;
        eventos(i,g).det_c(1).vec=[eventos(i,g).ev(:).detalles]>eventos(i,g).det_m;
     
        eventos(i,g).acc_c(2).vec=[eventos(i,g).ev(:).acceso]<eventos(i,g).acc_m;
        eventos(i,g).det_c(2).vec=[eventos(i,g).ev(:).detalles]<eventos(i,g).det_m;
    
     h=1;for q=1:2;for j=1:3;for t=1:T(h);for k=1:4
     todo(h).tipo(g).banda(j).tiempo(t).comp(2,q).medidas(k,i)=mean(todo(h).tipo(g).banda(j).tiempo(t).sujetes(i).medidas(k,eventos(i,g).acc_c(q).vec));
     todo(h).tipo(g).banda(j).tiempo(t).comp(3,q).medidas(k,i)=mean(todo(h).tipo(g).banda(j).tiempo(t).sujetes(i).medidas(k,eventos(i,g).det_c(q).vec));
     n=n+1;
     end;end;end;end
     end
end


%% Primera y ultima
load('datos_PLI.mat','datos')
h=1; g=1;
        for j=1:2
        for t=1:T(h)
            for i=1:S
                cant=size(datos(1,1).sujetes(i).matriz,3);
     todo(h).tipo(g).banda(j).tiempo(t).comp(1,1).medidas(:,i)=nanmean(todo(h).tipo(g).banda(j).tiempo(t).sujetes(i).medidas(:,1:cant),2);
     todo(h).tipo(g).banda(j).tiempo(t).comp(1,2).medidas(:,i)=nanmean(todo(h).tipo(g).banda(j).tiempo(t).sujetes(i).medidas(:,cant+1:end),2);
            end
        end
        end
        
%% comps
                
h=1; g=1;
for z=1:3
for q=1:2
        for j=1:3
%       
        for t=1:T(h)
     todo(h).tipo(g).banda(j).comp(z,q).medidas_prom(:,t)=nanmean(todo(h).tipo(g).banda(j).tiempo(t).comp(z,q).medidas,2);
     todo(h).tipo(g).banda(j).comp(z,q).medidas_e(:,t)=nanstd(todo(h).tipo(g).banda(j).tiempo(t).comp(z,q).medidas,0,2)/sqrt(S);
%               for i=1:S
%      MATRIZ(n,:)=[tipo{g},banda{j},];

        end
        end
end
end

%% estadidis

k=1; h=2;
for h=1:2
    for j=1:2
        for t=1:T(h)
[H_ad(h).h(j,t),H_ad(h).p(j,t),H_ad(h).F(j,t).F,H_ad(h).S(j,t).s] = ttest2(todo(h).tipo(1).banda(j).medidas_suj(k).media(:,t),...
                                        todo(h).tipo(2).banda(j).medidas_suj(k).media(:,t));
    end
    end
end
            
k=1; h=1;
for g=1:2
    for j=1:2
        for t=1:T(h)
            for z=g:3
[H(g).comp(z).h(j,t),H(g).comp(z).p(j,t),H(g).comp(z).F(j,t).f,H(g).comp(z).S(j,t).stats] = ...
    ttest2(todo(h).tipo(g).banda(j).tiempo(t).comp(z,1).medidas(k,:),...
                todo(h).tipo(g).banda(j).tiempo(t).comp(z,2).medidas(k,:));
            end
        end
    end
end

clear CO
h=1;m=0;
      for g=1:2;for j=1:2;
              n=0;
              for i=1:10;
%                   cant=size(datos(1,1).sujetes(i).matriz,3);
                  CANT=length(todo(h).tipo(g).banda(j).sujetes(i).epocas);
                  cant=length(eventos(i,g).ev);
                  m=m+1;
        check(m,:)=[g,j,i,CANT,cant];          
                  for p=1:CANT
                      for t=1:4
            cosas(t)=todo(h).tipo(g).banda(j).tiempo(t+4).sujetes(i).medidas(1,p);
                      end
%                       if isnan(cosas)==0
                      n=n+1;
    CO(g,j).matriz(n,:)=[eventos(i,g).ev(p).detalles,nanmean(cosas)];
%                       end
                  end;end;end;end;
      
h=1; k=1; g=1;
for g=1:2
for j=1:2
    if g==1
[correlaciones(g,j).rho,correlaciones(g,j).val]=corr(CO(g,j).matriz,'type','Spearman','tail','left');
    elseif g==2
[correlaciones(g,j).rho,correlaciones(g,j).val]=corr(CO(g,j).matriz,'type','Spearman','tail','right');
    end
co(g).p(j)=correlaciones(g,j).val(1,2);
co(g).r(j)=correlaciones(g,j).rho(1,2);
end
end
%% defs

bandas={'Theta','Alpha','gamma'};
tipo={'Memorias','Adivinanzas'};
etapa={'Acceso','Elaboracion'};
medidas={'Grado de conectividad','Indice de clustering','Eficiencia','Camino característico'};

to(1)=-3; to(2)=-T(2)*1.5;
for h=1:2
    eje(h).t=[0:T(h)-1]*1.5+to(h)+3/4;
end

figure
hold on
for i=1:10
   plot(i,i,'.') 
end
hola=gca;
color=hola.ColorOrder;
color=[color;0 0 0;.75 .75 .75;.25 .25 .25];   
%% Grafico medidas

%medidas
% figure
% n=0;
% for j=1:2
% for k=1:4
%     n=n+1;
%     subplot(2,4,n)
%     hold on
%     for g=1:2
%         for h=1:2
%     plot(eje(h).t,todo(h).tipo(g).banda(j).medidas(k,:),'o-','color',color(g,:))
%     errorbar(eje(h).t,todo(h).tipo(g).banda(j).medidas(k,:),todo(h).tipo(g).banda(j).medidas_e(k,:),'.','color',color(g,:))
%         end
%     end
% %     legend('gran primera','gran ultima','gran gran')
%     title({bandas{j},medidas{k}})
%     if n==5
%     xlabel('tiempo (seg)')
%     end
%     ylabel('grado medio')
%     axis tight
% end
% end
% 
% %todos los sujetos
% for g=1:2
% figure
% n=0;
% for j=1:2
% for k=1:4
%     n=n+1;
%     subplot(2,4,n)
%     hold on
%     for i=1:10
%         for h=1:2
%     plot(eje(h).t,todo(h).tipo(g).banda(j).medidas_suj(k).media(i,:),'.-')
%         end
%     end
%     if n==1
%     legend(tipo)
%     end
%     title({bandas{j},medidas{k}})
%     xlabel('tiempo (seg)')
%     ylabel('grado medio')
%     axis tight
% end
% end
% end
% 
% %todos los sujetos
% figure
% k=1; n=0;
% for g=1:2
% for j=1:2
%     n=n+1;
%     subplot(2,2,n)
%     hold on
%         for h=1:2
%     plot(eje(h).t,todo(h).tipo(g).banda(j).medidas(k,:),'.-k','linewidth',2)
%     for i=1:10
%     plot(eje(h).t,todo(h).tipo(g).banda(j).medidas_suj(k).media(i,:),'.-','color',[.1*i 1-.1*i 1])
%     end
%         end
% %     legend('gran primera','gran ultima','gran gran')
%     title({bandas{j},tipo{g}})
%     xlabel('tiempo (seg)')
%     ylabel('grado medio')
%     axis tight
% end
% end

% %% grafico z score
% eje_f=[eje(2).t eje(1).t];
% 
% for j=1:2
% figure('NumberTitle', 'off', 'Name',['Hubs - ',bandas{j}])
% n=0;
%    for h=2:-1:1
%    for t=1:T(h)
%         n=n+1;
%     subplot(3,6,n)
%     hold on
%     for l=1:5
%      bar(lineas(l)+1:lineas(l+1),todo(h).tipo(g).banda(j).z_or(t,lineas(l)+1:lineas(l+1)),'FaceColor',color(l,:))
%     end
% %     axis([0.2 30.8 -9 9.2])
% %     if n==6 || n==1;
%     xlabel('electrodos')
%     ylabel('z-score')
% %     end
%     
%     title(['t=',num2str(eje_f(n)),'s'])
%     if t==5
%     legend(nombres)
%     end
%    end
% end
% end

%% definitivas
eje_t=[eje(2).t(1:end-2) eje(1).t];
eje_ticks=[-12:1.5:12];
eje_labels=[-12:1.5:12];
eje_sel=[1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1];
for i=1:length(eje_ticks)
    if eje_sel(i)==0
    eje_lab{i}='';
    else 
    eje_lab{i}=num2str(eje_labels(i))
    end
end

%% medidas todas
    c=[1,6];
    figure('Units','centimeters','Position',[0 0 ancho 10],'PaperPositionMode','auto')
    n=0; g=1;
    for j=1:2
        for k=[1,2,4]
        n=n+1;
        subplot(2,3,n)
        hold on
        plot(eje_t,graf(g,j).medidas(k,:),'*-','color',color(c(j),:),'linewidth',1.5,'markerfacecolor',color(c(j),:))
        errorbar(eje_t,graf(g,j).medidas(k,:),graf(g,j).medidas_e(k,:),'.','color',color(c(j),:)) 
        if n==1
        ylabel('Valor medio');
        elseif n==4
        xlabel('Tiempo (seg)');    
        end
        if j==1
            title(medidas{k});
        end
        axis tight;
        xlim([-12 12])
        x=xlim; y=ylim;
        patch([x(1) 0 0 x(1)],[y(1) y(1) y(2) y(2)],color(9,:),'facealpha',.2,'edgecolor','w')
        line([0 0],ylim,'color','k')
        box on
        set(gca,'Units','normalized','XTick',eje_ticks,'XTickLabel',eje_lab,... %'Position',[.15 .2 .75 .7]
            'FontUnits','points','FontSize',9,'FontName','Cambria')
        end
    end
   tightfig
    print('GRAFICOS/medidas','-dpng') 
    print('vec/medidas','-dsvg')
    print('vec/medidas','-deps')
    

%% todos sujetos
clear p
c=[1,6];
figure('Units','centimeters','Position',[0 0 ancho 8],'PaperPositionMode','auto')
k=1; n=0;
for j=1:2
    n=n+1; subplot(1,2,n); hold on;
    for i=1:10
    p(i)=plot(eje_t,graf(g,j).medidas_suj(k).media(i,:),'.-','color',[.5+.05*i 1-.05*i 0]);
    end
    p1=plot(eje_t,graf(g,j).medidas(k,:),'-','color',color(c(j),:),'linewidth',2);
    p=[p1,p];legend(p,{'promedio'})
    if n==1
    ylabel('Valor medio');title('Grado de conectividad');
    elseif n== 2
    xlabel('Tiempo (seg)');
    end
    axis tight;x=xlim; y=ylim;
      patch([x(1) 0 0 x(1)],[y(1) y(1) y(2) y(2)],color(9,:),'facealpha',.1,'edgecolor','w')
    line([0 0],ylim,'color','k')
    box on
     set(gca,'Units','normalized','XTick',eje_ticks,'XTickLabel',eje_lab,... %'Position',[.15 .2 .75 .7]
            'FontUnits','points','FontSize',9,'FontName','Cambria')
%     colorbar
end
tightfig  
  print('GRAFICOS/sujetos','-dpng')
  print('vec/sujetos','-dsvg')

%% memorias vs adivinanzas
clear p
c=[1,8;6,8];
figure('Units','centimeters','Position',[0 0 ancho 6],'PaperPositionMode','auto')
n=0; g=1;
for j=1:2
    k=1;
    n=n+1;subplot(1,2,n);hold on;
    for g=2:-1:1
    p(-g+3)=plot(eje_t,graf(g,j).medidas(k,:),'*-','color',color(c(j,g),:),'linewidth',1.5,'markerfacecolor',color(c(j,g),:));
    errorbar(eje_t,graf(g,j).medidas(k,:),graf(g,j).medidas_e(k,:),'.','color',color(c(j,g),:)) 
    end
    if n==1
    xlabel('Tiempo (seg)')
    ylabel({'Grado de conectividad';'prommedio'})
    end
        title(bandas{j});
%     if n==1
        legend(flip(p),tipo)
%     end
    axis tight;xlim([-12 12])
    x=xlim; y=ylim;
    patch([x(1) 0 0 x(1)],[y(1) y(1) y(2) y(2)],color(9,:),'facealpha',.2,'edgecolor','w')
    line([0 0],ylim,'color',color(10,:))
    box on
     set(gca,'Units','normalized','XTick',eje_ticks,'XTickLabel',eje_lab,... %'Position',[.15 .2 .75 .7]
            'FontUnits','points','FontSize',9,'FontName','Cambria')
end
tightfig
 print('GRAFICOS/medidas_adivinanzas','-dpng')
 print('vec/medidas_adivinanzas','-dsvg')

%% detalles acceso
% color={'b','r','g'};
c=[2,3;4,7;5,11];
color(11,:)=color(5,:)+[-.1 -.3 -.1];
legendas={'ED >','ed <';'TA >','ta <';'ND >','nd <'};
titulos={'Edad de la memoria','Tiempo de acceso','Nivel de detalle'};
figure('Units','centimeters','Position',[0 0 ancho 10],'PaperPositionMode','auto')
h=1; g=1;
n=0;
for j=1:2
for z=1:3
    n=n+1;
    subplot(2,3,n)
    hold on
    for q=1:2
    plot(eje(h).t,todo(h).tipo(g).banda(j).comp(z,q).medidas_prom(1,:),'*-','linewidth',1.5,'color',color(c(z,q),:))
    end
    if j==1
    title(titulos{z})
    legend(legendas{z,:},'location','northwest')
    end
    for q=1:2
    errorbar(eje(h).t,todo(h).tipo(g).banda(j).comp(z,q).medidas_prom(1,:),todo(h).tipo(g).banda(j).comp(z,q).medidas_e(1,:),'.','color',color(c(z,q),:))
    end
    if n==4
    xlabel('Tiempo (seg)')
    elseif n==1
    ylabel({'Grado de conectividad';'promedio'})
    end
%     axis tight;
    if j==1
    axis([-3 12 1.5 3.25])
    elseif j==2
    axis([-3 12 1.25 3.75])
    end
%     y=ylim;
%     ylim([y(1) y(2)+.2])
    x=xlim; y=ylim;
    patch([x(1) 0 0 x(1)],[y(1) y(1) y(2) y(2)],color(9,:),'facealpha',.2,'edgecolor','w')
    line([0 0],ylim,'color','k')
    box on
    set(gca,'Units','normalized','XTick',eje_ticks,'XTickLabel',eje_lab,... %'Position',[.15 .2 .75 .7]
            'FontUnits','points','FontSize',9,'FontName','Cambria')
end
end
 tightfig
 print('GRAFICOS/medidas_comp','-dpng')
 print('vec/medidas_comp','-dsvg')
%% mapas
% eje_t=[-9:3:9];
% eje_ticks=[-9:3:9];
% eje_labels=[-9:3:9];
% % eje_sel=[1 0 1 0 1 0 1 0 1 0 1 0 1 0 1];
% for i=1:length(eje_ticks)
%     if eje_sel(i)==0
%     eje_lab{i}=' ';
%     else 
%     eje_lab{i}=num2str(eje_labels(i));
%     end
% end

clear p
c=[1,2,3,4,7];
L=lineas(2:end-1)+.5
g=1;
colormap winter

figure('Units','centimeters','Position',[0 0 ancho 6],'PaperPositionMode','auto')
n=0;
for j=1:2
    
min_mat=min(min(min(graf(g,j).matriz)));
max_mat=max(max(max(graf(g,j).matriz)));
   colormap hot
   for t=1:6
        n=n+1;
    subplot_tight(2,6,n,[.015 .02])
    hold on
       imagesc(graf(g,j).matriz_or(:,:,t),[min_mat max_mat]);
       axis tight
       x=xlim;y=ylim;
       for l=1:5
           p(l)=plot([0 0],[lineas(l) lineas(l+1)]+.5,'-','linewidth',2,'color',color(c(l),:));
           plot([lineas(l) lineas(l+1)]+.5,[0 0],'-','linewidth',2,'color',color(c(l),:))
           if l<5
           plot([L(l) L(l)],[y(1) y(2)],'-','linewidth',.2,'color','k')    
           plot([x(1) x(2)],[L(l) L(l)],'-','linewidth',.2,'color','k')
           end
       end
        axis square
%     if t==1;  
%     ylabel('Canales')
%     ax=gca;
%     ax.YTick=[3,9,15,21,27]+.5;
%     ax.YTickLabel = nom;
%     ax.XTickLabel = {' '};
%     xlabel('Canales')
%     elseif t==6
%     barra=colorbar;
%     barra.Label.String = {'# de conexiones';'promedio'};
% %     barra.Position=[.91 .2 .01 .6];
% %     legend(p,nombres)
%     end
%     if t>1
%     ax=gca;
%     ax.XTickLabel = [];
%     ax.YTickLabel = [];
%     end
axis off
    box on
     set(gca,'Units','normalized','FontUnits','points','FontSize',9,'FontName','Cambria')
   end
   end
%    tightfig
    print('GRAFICOS/mapas','-dpng')
    print('vec/mapas','-dsvg')



%% score
clear p
for j=1:2
   for g=1:2
    figure('Units','centimeters','Position',[0 0 ancho 4],'PaperPositionMode','auto')
    n=0;
minimo=min(min(graf(g,j).z_or));
maximo=max(max(graf(g,j).z_or));
   for t=1:6
        n=n+1;
    subplot(1,6,n)
    hold on
    if t<4
    patch([0 31 31 0],[minimo minimo maximo maximo],color(9,:),'facealpha',1/3,'edgecolor',color(9,:))
    end
    for l=1:5
     p(l)=bar(lineas(l)+1:lineas(l+1),graf(g,j).z_or(t,lineas(l)+1:lineas(l+1)),'FaceColor',color(c(l),:));
    end
    axis tight
    ylim([minimo maximo])
%     set(gca,'YScale','log')
%     axis square
    ax=gca;    
    if n==1
    ylabel('Puntaje Z')
    else
    ax.YTickLabel = {''};
    end
    if n==1
    xlabel('Canales')
    ax.XTick=[3,9,15,21,27]+.5;
    ax.XTickLabel = nombres;
    ax.XTickLabelRotation=45;
%     legend(p,nombres)
    else
    ax.XTickLabel = [];
    end
    
    set(gca,'Units','normalized','FontUnits','points','FontSize',9,'FontName','Cambria')
    box on
%     axis off
    VER(g,j).mat(t,:)=(graf(g,j).canales(t,1:3));
    VER(g,j).nom(t,:)=(canales(graf(g,j).canales(t,1:3)));
   end
   VER(g,j).nom
   end
   tightfig
   print(['GRAFICOS/hubs_',bandas{j},tipo{g}],'-dpng')
    print(['vec/hubs_',bandas{j},tipo{g}],'-dsvg')
end
% 

clear p
 figure('Units','centimeters','Position',[0 0 ancho 15],'PaperPositionMode','auto')
    n=0;
for j=1:2
  
    for g=1:2 
minimo=min(min(graf(g,j).z_or));
maximo=max(max(graf(g,j).z_or));
   for t=1:6
        n=n+1;
    subplot(4,6,n)
    hold on
    if t<4
    patch([0 31 31 0],[minimo minimo maximo maximo],color(9,:),'facealpha',1/3,'edgecolor',color(9,:))
    end
    for l=1:5
     p(l)=bar(lineas(l)+1:lineas(l+1),graf(g,j).z_or(t,lineas(l)+1:lineas(l+1)),'FaceColor',color(c(l),:));
    end
    axis tight
    ylim([minimo maximo])
    ax=gca;
    ax.YTickLabel = {''}
    ax.XTickLabel = {''};
    
    set(gca,'Units','normalized','FontUnits','points','FontSize',9,'FontName','Cambria')
    box on
    axis off
    VER(g,j).mat(t,:)=(graf(g,j).canales(t,1:3));
    VER(g,j).nom(t,:)=(canales(graf(g,j).canales(t,1:3)));
   end
   VER(g,j).nom
   end
   end
tightfig
   print(['GRAFICOS/hubs2_',bandas{j},tipo{g}],'-dpng')
    print(['vec/hubs2_',bandas{j},tipo{g}],'-dsvg')
% 

%% redes
Color(1,:)=color(1,:)+.5*[1-color(1,:)];
Color(2,:)=color(6,:)+.5*[1-color(6,:)];

g=1;
% C=colormap(winter)
c=[1,2];
% figure
    
       topoplot_links_g(graf,Color);


       topoplot_links_g2(graf,color(j,:));
       topoplot_links_g2c(graf,color(j,:));
       
       topoplot_links_g2cc(graf,color(c(j),:));
%         fig = gcf; fig_pos = fig.PaperPosition; fig.PaperSize = [fig_pos(3) fig_pos(4)];
