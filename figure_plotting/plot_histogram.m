%% Histogram plotter
%cryst_1 is perpendicular to fringes, cryst_2 is parallel to fringes.
%Choose which histograms you want to make. All distances are in nm.
%x=BW101_1_Plus_crystal_planes.cryst_1;
%y=BW068_2_Plus_crystal_planes.dspacing;
%z=BW101_1_Plus_crystal_planes.cryst_2;
%a=BW065_2_COF_GNF_crystal_planes.dspacing;
%b=BW101_1_Plus_crystal_planes.dspacing;
%c=Py_COF_d_spacing.PXRD;
x=d_spacing_BW134_1.dspacingnm;
hold on;
%% Crystallite size histograms
%histogram(x,'BinWidth',2);
%histogram(z,'BinWidth',2);
%histogram(a,'BinWidth',0.02);
%histogram(b,'BinWidth',0.02);
%histogram(c,'BinWidth',0.02);
%% d-spacing histograms
histogram(x, 'BinLimits',([1,4]),'BinWidth',0.05);
%histogram(b, 'BinLimits',([1,4]),'BinWidth',0.2);
%histogram(a, 'BinLimits',([1,4]),'BinWidth',0.2);
%% Angle histograms 
%histogram(crystalplanes.GNF_angle,'BinWidth',4);%, 'BinLimits',([1,4]),'BinWidth',0.1);
hold off;
%% Legend
%legend('COF','COF/GNF hybrid','Location','northeast');
%legend('Perpendicular to pore channel','Parallel to pore channel','Location','northeast');
legend('COF','COF@MWNT','COF@GNF','Location','northeast');
%% Axis labels
xlabel('d-spacing / nm','FontSize',36,'FontName','Calibri');
%xlabel('Crystallite Size / nm','FontSize',36,'FontName','Calibri');
ylabel('Frequency','FontSize',36,'FontName','Calibri');
%% Axis limits
xlim([1, 2.5]);
%xlim([0,60]);
ylim([-inf, inf]);
%xlim([0,91]);
%ylim([-inf,5000]);
clear x y z;
%% Figure settings
set(0,'defaultfigurecolor',[1 1 1]);
set(gca,'FontName','Calibri');
set(gca, 'linewidth', 2);
set(gca, 'FontSize', 28);
set(gca,'TickDir','out');
box off;
set(gca,'XMinorTick','on','YMinorTick','on')