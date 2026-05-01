%%TGA graph
x1= data.Temperature; y1 =data.Weight/0.631000;

hold on;
plot(x1,100*y1,'Color',1/255*[144, 215, 67],'LineWidth',2);%GNF
hold off;

xlim([100,1000]);
ylim([0,100]);
xlabel('Temperature / ^oC','FontSize',36,'FontName','Calibri');
ylabel('Weight / %','FontSize',36,'FontName','Calibri');
%legend(
%legend('boxoff');
set(0,'defaultfigurecolor',[1 1 1]);
set(gca,'FontName','Calibri');
set(gca, 'linewidth', 2);
set(gca, 'FontSize', 28);
set(gca,'TickDir','out');
box off;
clear x1 y1