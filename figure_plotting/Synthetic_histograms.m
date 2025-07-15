%% Synthetic histograms
% Generates normal distributed data for plotting example histograms
stdDev = 0.47;%standarddeviation in nm
meanVal = 1.91;
meanAC = 2.3;
sampleSize = 250;
binning = round(sqrt(sampleSize));
meanZZ = 1.5;
%randVal = normrnd(meanVal,stdDev,sampleSize,1);
%randAC = normrnd(meanAC,stdDev,sampleSize,1);
%randZZ = normrnd(meanZZ,stdDev,sampleSize,1);
hold on
histfit(synthACandZZ,round(sqrt(500)),'normal')
histfit(randAC,binning,'normal')
histfit(randZZ,binning,'normal')
%histfit(randVal,binning,'normal')
%histfit(randValAC,round(sqrt(220)),'normal')
%histfit(randValZZ,round(sqrt(280)),'normal')
hold off
axis square
set(gca,'FontName','Calibri');
set(gca, 'linewidth', 2);
set(gca, 'FontSize', 28);
set(gca,'TickDir','out');
set(0,'defaultfigurecolor',[1 1 1]);
xlabel('d-spacing / nm','FontSize',36,'FontName','Calibri');
ylabel('Frequency','FontSize',36,'FontName','Calibri');
bimodality = abs(meanAC - meanZZ) / (2*sqrt(stdDev*stdDev));
disp(bimodality);