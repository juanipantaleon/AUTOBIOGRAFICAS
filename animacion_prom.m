clear all
close all

load('graf.mat','graf')

set(0,'DefaultFigureWindowStyle','docked')
figure
for i=1:7
plot(i,i);
end
ax=gca;
color=ax.ColorOrder;
% color=[1,2,3,4,7];
Color=[1,6];

addpath('F:\JUANI\DOCUMENTOS\DF\tesis\eeglab13_5_4b');
eeglab
folder='F:\JUANI\DOCUMENTOS\DF\tesis\marcas\prepro';
SetFile='niih_eeg.set';
numCh=30;
S=50;
EEG = pop_loadset('filename',SetFile,'filepath',folder);
if numCh ==30
    t         = load('pos_elec_topoplot_r1.txt');
    x         = t(:,1);
    y         = t(:,2);
    z         = t(:,3);
else
    [eloc, labels, theta, radius, indices] = readlocs(EEG.chanlocs);
    Th = pi/180*theta;
    allchansind = 1:length(Th);
    [x,y]     = pol2cart(Th,radius);
end

    tiempos=-12:1.5:12;
    fig=figure;
    text(0,0,['tiempo = ','-12',' seg'],'Color','k','FontSize',14,'FontName','Cambria')   
%     drawnow
    
    bandas={'Theta','Alfa'};
    pos = [-.55 -.55 1.1 1.1]; 
    
    g=1;
    
for t=1:16
    clf    
    for j=1:2
    M=max(reshape(sum(graf(g,j).redes,1),1,[]));    
    W=sum(graf(g,j).redes(:,:,t));
%     X=matriz(t,:);
    subplot(2,2,j*2-1)
%     clf
        colormap hot
%     C=colormap(jet)

    hold on
    imagesc(graf(g,j).matriz_or(:,:,t),[graf(g,j).minimo graf(g,j).maximo])
    axis tight
    axis square
    axis off
    
%     text(-10,15,bandas{j},'Color','k','FontSize',14,'FontName','Cambria');
    if j==1
    text(+26,-3,['Tiempo = ',num2str(tiempos(t)),' seg'],'Color','k','FontSize',14,'FontName','Cambria');
    title('Matrices de probabilidad')
        if t<9
        text(+30,-10,'Acceso','Color','k','FontSize',14,'FontName','Cambria');
        else
        text(+30,-10,'Elaboración','Color','k','FontSize',14,'FontName','Cambria');
        end
    end

    subplot(2,2,j*2)
    hold on
    colormap hot
    C=colormap(hot);

    rectangle('Position',pos,'Curvature',[1 1],'FaceColor',[1 1 1]*0,'EdgeColor',[1 1 1]*.5)
    plot(0,.55,'^','markersize',8,'markerfacecolor',[1 1 1]*0,'markeredgecolor','none')
       
       for i=1:30
           for k=1:30
               if graf(g,j).redes(i,k,t)==1
                plot([x(i),x(k)],[y(i),y(k)],'-','color',color(Color(j),:),'linewidth',1)
               end
           end
       end
       for i=1:30
           if max(W)>0
                plot(x(i),y(i),'o','markersize',round(W(i)/2)+1,'markerfacecolor',C(round(W(i)/M*63)+1,:),'markeredgecolor','k')
           end
       end
       
    axis off
    axis tight
    
    if j==1
    title('Redes promedio')
    end
    end 
    
 drawnow
 frame = getframe(fig);
    im = frame2im(frame);
    [A,map] = rgb2ind(im,256);
    if t == 1
        imwrite(A,map,'animacion.gif','gif','LoopCount',Inf,'DelayTime',1.5);
    else
        imwrite(A,map,'animacion.gif','gif','WriteMode','append','DelayTime',1.5);
    end
    pause(1)
    tic
    
end

clf
drawnow
frame = getframe(fig);
    im = frame2im(frame);
    [A,map] = rgb2ind(im,256);
        imwrite(A,map,'animacion.gif','gif','WriteMode','append','DelayTime',1.5);
