function topoplot_links_g2(graf,color)
% inputs:
% A = matriz de adycacencia. No tiene que ser simétrica
% folder = carpeta donde esta el .set para sacar información de la cantidad y posición de electrodos 
% SetFile = archivo .set que tenga la estructura de EEG.chanlocs
% numCh   = número de electrodos. 30 Akonic
%%
addpath('F:\JUANI\DOCUMENTOS\DF\tesis\eeglab13_5_4b');
eeglab
%IMPORTANTE: Ojo con el path del EEGLAB
folder='F:\JUANI\DOCUMENTOS\DF\tesis\marcas\prepro';
SetFile='niih_eeg.set';
EEG = pop_loadset('filename',SetFile,'filepath',folder);
numCh=30;
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

    figure('Units','centimeters','Position',[0 0 19 12],'PaperPositionMode','auto');
% colormap
 
S=12;
n=0;    
for j=1:2
%         prom=mean(reshape(abs(dif),1,[]));
%     desvi=mean(reshape(abs(dif),1,[]));
%     um=prom+1.6*desvi;
%     Dif=dif>um;
   
for g=1:2
for t=1:6
n=n+1;
% subplot(4,6,n)
subplot_tight(4,6,n,[.02 .02])

    hold on
if g==1;
M=max(reshape(graf(1,j).z_score,1,[]));
m=min(reshape(graf(1,j).z_score,1,[]));
D=M-m;
mm=m:D/3:M;

w=-m/D;    
W=(graf(g,j).z_score-m)/D;
V=W(t,:);

C=colormap(parula);
    
    pos = [-.55 -.55 1.1 1.1]; 
    rectangle('Position',pos,'Curvature',[1 1],'FaceColor',[1 1 1]*0,'EdgeColor',[1 1 1]*.5)
    plot(0,.55,'^','markersize',8,'markerfacecolor',[1 1 1]*0,'markeredgecolor','none')
    for i=1:length(V)
        plot(x(i),y(i),'o','markersize',round(V(i)*S)+1,...
            'markerfacecolor',C(round(V(i)*63)+1,:),'markeredgecolor',C(round(V(i)*63)+1,:))
    end
%     if t==6
%         barra=colorbar('Ticks',[0,w,1],'TickLabels',round([m,0,M],1));
%     barra.Label.String = {'PE'};
%     end

elseif g==2
    dif=graf(1,j).z_score-graf(2,j).z_score;
    Dif=abs(dif);

    m=min(reshape(dif,1,[]));
    M=max(reshape(abs(dif),1,[]));
    N=max(reshape(dif,1,[]));
    D=2*M;
    dd=-M:D/3:M;
    W1=(dif+M)/D;
    w=-M/D;
    W2=Dif/N
    V1=W1(t,:);
    V2=W2(t,:);
    CC=colormap(jet);
    um=mean(reshape(Dif,1,[]))+.8*std(reshape(Dif,1,[]));
    
    
    pos = [-.55 -.55 1.1 1.1]; 
    rectangle('Position',pos,'Curvature',[1 1],'FaceColor',[1 1 1]*.5,'EdgeColor',[1 1 1]*.5)    
    plot(0,.55,'^','markersize',8,'markerfacecolor',[1 1 1]*.5,'markeredgecolor','none')
for i=1:length(V1)
    if Dif(t,i)>um
        plot(x(i),y(i),'o','markersize',round(V2(i)*S)+1,...
            'markerfacecolor',CC(round(V1(i)*63)+1,:),'markeredgecolor',CC(round(V1(i)*63)+1,:))
    else
        plot(x(i),y(i),'.k')
    end
end
%     if t==6
%         barra=colorbar('Ticks',[0,w,1],'TickLabels',round([m,0,M],1));
%     barra.Label.String = {'\Delta PE'};
%     end
    
end
  
    axis tight    
    axis off  
end
end
    

end
% tightfig
print('GRAFICOS/redes_4','-dpng')
    print('vec/redes_4','-dsvg')
end