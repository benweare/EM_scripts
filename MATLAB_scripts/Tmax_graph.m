sz=10;
hold on;
scatter(Results_Carbon12.Accelerating_voltage,Results_Carbon12.tmax_eV,sz,'x','LineWidth',4,'MarkerEdgeColor',1/255*[0 0 255]);
%scatter(Results_1kV.Atomic_Mass,Results_1kV.tmax_eV,sz,'x','LineWidth',4,'MarkerEdgeColor',1/255*[0 102 0]);
%scatter(Results_80V.Atomic_Mass,Results_80V.tmax_eV,sz,'x','LineWidth',4,'MarkerEdgeColor',1/255*[0 0 153]);
hold off;
%xlim([1,20]);
ylim([-inf, inf]);
clear sz;
xlabel('Atomic Mass / Da','FontSize',36,'FontName','Calibri');
ylabel('T_{max} / eV','FontSize',36,'FontName','Calibri');
%title('IR spectra of MIL-53(Al)-NH_2 and 2-aminoterephthalic acid','FontSize',28);
legend('30 eV','1 eV','200 kV');
legend('boxoff');
set(0,'defaultfigurecolor',[1 1 1])
set(gca,'FontName','Calibri')
set(gca, 'linewidth', 2);
set(gca, 'FontSize', 28);
%set(gca,'Yticklabel',[]);%removes the y axis numbers
%set(gca,'Ytick',[]);
set(gca,'TickDirMode','auto');
set(gca,'TickDir','out');
axis square;