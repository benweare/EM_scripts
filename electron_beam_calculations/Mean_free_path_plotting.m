%% Constant density
%plot(Mean_free_path_carbon_200keV_thickness.Thickness, Mean_free_path_carbon_200keV_thickness.Mean_free_path_nm,'Color', 1/255*[0 0 0],'LineWidth',2);
%plot(Mean_free_path_carbon_80keV_thickness.Thickness, Mean_free_path_carbon_200keV_thickness.Mean_free_path_nm,'Color', 1/255*[255 0 0],'LineWidth',2);
%% Constant thickness
hold on
plot(Mean_free_paths.F,Mean_free_paths.Diamond,'Color', 1/255*[255 0 0],'LineWidth',2);
plot(Mean_free_paths.F,Mean_free_paths.Graphite,'Color', 1/255*[0 0 255],'LineWidth',2);
plot(Mean_free_paths.F,Mean_free_paths.C60,'Color', 1/255*[0 0 0],'LineWidth',2);
hold off
%xlim([0,100]
%ylim([0,1])
xlabel('Accelerating Voltage / kV','FontSize',36,'FontName','Calibri');
%ylabel('Mean Free Path','FontSize',36,'FontName','Calibri');
ylabel('Mean Free Path / nm','FontSize',36,'FontName','Calibri');
legend('Diamond','Graphite','C60','Location','northwest');
%%
set(gca,'FontName','Calibri')
set(gca, 'linewidth', 2);
set(gca, 'FontSize', 28);
set(gca,'TickDir','out');
set(0,'defaultfigurecolor',[1 1 1]);