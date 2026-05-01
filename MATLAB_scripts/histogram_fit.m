%% Histogram fitting
binning = round(sqrt(110));
binning_ac = 6;
binning_zz = 3;
hold on
histfit(bw134_1_COF_5_d_spacing,binning,'normal')
%histfit(AC,binning_ac,'normal')
%histfit(ZZ,binning_zz,'normal')
%ac_dist=fitdist(bw068_2_ac,'burr')
%zz_dist=fitdist(bw068_2_zz,'normal')
%fitdist(data,'normal')
%histfit(data,binning,'normal')
%%
%xlim([1,4]);
xlabel('d-spacing / nm','FontSize',36,'FontName','Calibri');
ylabel('Frequency','FontSize',36,'FontName','Calibri');
ylim([-inf, inf]);
set(0,'defaultfigurecolor',[1 1 1]);
set(gca,'FontName','Calibri');
set(gca, 'linewidth', 2);
set(gca, 'FontSize', 28);
set(gca,'TickDir','out');
box off;
set(gca,'XMinorTick','on','YMinorTick','on')
axis square