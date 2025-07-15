%% Plotting 
% coordinates = cell2mat({cursor_info.Position}')
x1=bw068_2_RP_12p.mz; y1=bw068_2_RP_12p.I*0.1+10000;%COF
x2=BW079COFgraphite.mz; y2=BW079COFgraphite.I*0.4+8000;%COF@graphite
x3=BW065_2_7P740P241.mz; y3=BW065_2_7P740P241.I*0.4+6000;%COF@GNF
x4=bw101_1pos.mz; y4=bw101_1pos.I*0.1+4000;%COF@MWNT
x5=BW1161RP10pnomatrix0B191.mz; y5=BW1161RP10pnomatrix0B191.I*0.1+2000;%COF@SWNT
x6=BW1171RP10pnomatrix0B211.mz; y6=BW1171RP10pnomatrix0B211.I*0.1;%COF@silica

hold on;
%spectrumColour = [0 0 0]; massSpectrum(BW149_TMT,spectrumColour);
plot(x1,y1,'Color',1/255*[144, 215, 67],'LineWidth',2);%GNF
plot(x2,y2,'Color',1/255*[53, 183, 121],'LineWidth',2);%COF
plot(x3,y3,'Color',1/255*[33, 145, 140],'LineWidth',2);%COF@GNF
plot(x4,y4,'Color',1/255*[49, 104, 142],'LineWidth',2);%pyro COF
plot(x5,y5,'Color',1/255*[68, 57, 131],'LineWidth',2);%pyro COF@GNF
plot(x6,y6,'Color',1/255*[68, 1, 84],'LineWidth',2);
hold off;
%plot(x7,y7,'Color',1/255*[0 255 0],'LineWidth',2);
%% Formatting Options
xlabel('m/z','FontSize',36,'FontName','Calibri');
ylabel('Intensity / a.u.','FontSize',36,'FontName','Calibri');
axis square
xlim([400,1600]);
%xlim([-inf,inf]);
ylim([-inf,12000]);
%ylim([-inf,inf]);
%yticks([]);
%xticks([]);
legend('COF','COF@graphite','COF@GNF','COF@MWNT','COF@SWNT','COF@silica','Location','southwest');
legend('boxoff');
clear x y w z a b;
%% Defaults
set(0,'defaultfigurecolor',[1 1 1]);
set(gca,'FontName','Calibri');
set(gca, 'linewidth', 2);
set(gca, 'FontSize', 28);
set(gca,'TickDir','out');
box off;
%% Extract data from figure
%h = findobj(gca,'Type','bar')
%x=get(h,'Xdata') ;
%y=get(h,'Ydata') ;
%hold on
%bar(x{1,1},y{1,1},'EdgeColor',1/255*[255 0 0]);

function massSpectrum(spectrumData, spectrumColour)
plot(spectrumData.mz,spectrumData.I,'Color',1/255*spectrumColour,'LineWidth',2);
clear spectrumColour;
end