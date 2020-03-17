function topoplot_links(graf,Color)
% inputs:
% A = matriz de adycacencia. No tiene que ser simétrica
% folder = carpeta donde esta el .set para sacar información de la cantidad y posición de electrodos 
% SetFile = archivo .set que tenga la estructura de EEG.chanlocs
% numCh   = número de electrodos. 30 Akonic
%%
bandas={'Theta','Alpha','gamma'};
addpath('F:\JUANI\DOCUMENTOS\DF\tesis\eeglab13_5_4b');
eeglab
%IMPORTANTE: Ojo con el path del EEGLAB
folder='F:\JUANI\DOCUMENTOS\DF\tesis\marcas\prepro';
SetFile='niih_eeg.set';
numCh=30;
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


    figure('Units','centimeters','Position',[0 0 19 7],'PaperPositionMode','auto')
    C=colormap(parula);
    g=1;
    S=9;
    n=0;
for j=1:2
  B=graf(g,j).redes; 
 color=Color(j,:);

M=max(reshape(sum(B,1),1,[]));
m=0:M/3:M;
mm=round(m);
for t=1:6
n=n+1;
A=B(:,:,t);
V=degrees_und(A);
W=V/M;
Z=V/M*64;
%%
if (size(A,1)==size(A,2) & size(A,1)==length(EEG.chanlocs) & length(EEG.chanlocs)==numCh)
%     subplot_tight(2,6,n,[.04 .04])
    subplot(2,6,n)
    hold on
    pos = [-.5 -.5 1 1]; 
    plot(0,.5,'^','markersize',7,'markerfacecolor',[1 1 1]*.25,'markeredgecolor','k')
    
    rectangle('Position',pos,'Curvature',[1 1],'FaceColor',[1 1 1]*.25,'EdgeColor','k')
    
    
    for i=1:size(A,1)
        temp = [];
        temp = find(A(i,:));
        if ~isempty(temp)
            for j=1:length(temp)
                plot([x(i),x(temp(j))],[y(i),y(temp(j))],'-','color',color,'linewidth',.7)
            end
        end
    end
    for i=1:size(A,1)
        plot(x(i),y(i),'o','markersize',round(W(i)*S)+1,'markerfacecolor',C(round(W(i)*63)+1,:),'markeredgecolor',[1 1 1]*0)
    end
    
    
    set(gca,'Units','normalized','FontUnits','points','FontSize',9,'FontName','Cambria')
    axis tight
    axis off
   
    if t==6
    barra=colorbar('Ticks',0:1/3:1,'TickLabels',mm);
    
    barra.Label.String = {'# conexiones'};
    end
    
    
    
%     barra.Position=[.91 .2 .01 .6];   
%     topoplot(zeros(1,numCh),EEG.chanlocs,'electrodes','on',...
%         'headrad',1,'style','both','hcolor',[.5 .5 .5],'emarker',{'.','k',15,1});

else
    disp('Error de dimensiones')
end
end
%         fig = gcf; fig_pos = fig.PaperPosition; fig.PaperSize = [fig_pos(3) fig_pos(4)];
 
end
% % tightfig
   print('GRAFICOS/redes_2c','-dpng')
    print('vec/redes_2c','-dsvg')
end