tic;
hold on;
dataSet = 2;
totalSim = 5000;
data = Results_6_covalency_1000_repeats_5000_monomers;
while dataSet < totalSim 
    yPlotData=table2array(data(:,dataSet));
    scatter(data.steps, yPlotData,1,'.','LineWidth',3,'MarkerEdgeColor',1/255*[0 0 0]);
    dataSet = dataSet +1;
end
hold off;
xlabel('Steps','FontSize',36,'FontName','Calibri');
ylabel('Size','FontSize',36,'FontName','Calibri');
set(gca,'FontName','Calibri')
set(gca, 'linewidth', 2);
set(gca, 'FontSize', 28);
set(gca,'TickDir','out');
set(0,'defaultfigurecolor',[1 1 1]);
clear add ans Pad Plo s size steps x y noM Nom currentSim totalSim tableTick sizeT noMtotal Nomtotal;
clc;
toc;
Sum = sum(table2array(a53p_addn_50000_500(:,2:501)));
addnd = table2array(a53p_addn_50000_500(:,2:501))
A = sum(addnd,2);
scatter(a100p_addn_50000_500.steps, A,1,'.','LineWidth',3,'MarkerEdgeColor',1/255*[0 0 0]);