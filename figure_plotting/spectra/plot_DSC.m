%%DSC graph
%time=;
sampleTemperature=CoF5.SampleTemp; %x axis
sampleHeatFlow=CoF5.Unsubtracted-CoF5.Baseline; %yaxis, unsubtracted heat flow minus baseline heat flow
hold on;
plot(sampleTemperature(1:15023),sampleHeatFlow(1:15023),'Color',1/255*[0 0 0],'LineWidth',1.5);
plot(sampleTemperature(15025:61700),sampleHeatFlow(15025:61700),'Color',1/255*[0 0 255],'LineWidth',1.5);
%plot(sampleTemperature(61702:154455),sampleHeatFlow(61702:154455),'Color',1/255*[255 0 0],'LineWidth',1.5);
%plot(sampleTemperature,sampleHeatFlow,'Color',1/255*[0 255 0],'LineWidth',1.5);
%plot(sampleTemperature,sampleHeatFlow,'Color',1/255*[0 0 255],'LineWidth',1.5);
hold off;
%xlim([0,1000]);
%ylim([0,100]);
xlabel('Temperature / ^oC','FontSize',36,'FontName','Calibri');
ylabel('Heat Flow / ','FontSize',36,'FontName','Calibri');
%legend('Weight %','Derivative Weight','Location','northeast');
legend('boxoff');
set (gca, 'ydir', 'reverse')
set(0,'defaultfigurecolor',[1 1 1]);
set(gca,'FontName','Calibri');
set(gca, 'linewidth', 2);
set(gca, 'FontSize', 28);
set(gca,'TickDir','out');
box off;