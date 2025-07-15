%% Plotting 
% coordinates = cell2mat({cursor_info.Position}')
x1=data.mz; y1=data.I*0.1+10000;%COF
hold on;
%spectrumColour = [0 0 0]; massSpectrum(BW149_TMT,spectrumColour);
plot(x1,y1,'Color',1/255*[144, 215, 67],'LineWidth',2);
hold off;
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
%legend(
%legend('boxoff');
clear x y w z a b;
%% Defaults
set(0,'defaultfigurecolor',[1 1 1]);
set(gca,'FontName','Calibri');
set(gca, 'linewidth', 2);
set(gca, 'FontSize', 28);
set(gca,'TickDir','out');
box off;

function massSpectrum(spectrumData, spectrumColour)
plot(spectrumData.mz,spectrumData.I,'Color',1/255*spectrumColour,'LineWidth',2);
clear spectrumColour;
end