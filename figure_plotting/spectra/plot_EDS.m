%% EDX spectra
% coordinates = cell2mat({cursor_info.Position}')
x1=bw068_2_2345.eV;
y1=bw068_2_2345.Counts/71640+5;
x2=BW095_1_COFgraphite.eV;
y2=BW095_1_COFgraphite.Counts/19230+4;
x3=BW065_1_COF_GNF_3163.eV;
y3=BW065_1_COF_GNF_3163.Counts/148405+3;
x4=bw101_1_COFMWNT.eV;
y4=bw101_1_COFMWNT.Counts/197322+2;
x5=BW116_1_COFSWNT.eV;
y5=BW116_1_COFSWNT.Counts/34026+1;
x6=BW117_1_COFsilica.eV;
y6=BW117_1_COFsilica.Counts/57350;
%}
%x=eV;
%y=Counts;
hold on;
%plot(x,y,'Color',1/255*[0 0 0],'LineWidth',4);
subplot(6,1,1);
plot(x1,y1,'Color',1/255*[0 0 0],'LineWidth',4);
subplot(6,1,2);
plot(x2,y2,'Color',1/255*[0 0 0],'LineWidth',4);
subplot(6,1,3.);
plot(x3,y3,'Color',1/255*[0 0 0],'LineWidth',4);
subplot(6,1,4);
plot(x4,y4,'Color',1/255*[0 0 0],'LineWidth',4);
subplot(6,1,5);
plot(x5,y5,'Color',1/255*[0 0 0],'LineWidth',4);
subplot(6,1,6);
plot(x6,y5,'Color',1/255*[0 0 0],'LineWidth',4);
hold off;
%% Formatting Options
xlabel('Energy / keV','FontSize',36,'FontName','Calibri');
ylabel('Counts','FontSize',36,'FontName','Calibri');
xlim([0.1, 10])
ylim([-inf,inf]);
%yticks([]);
%xticks([]);
%legend('BW-COF@GNF','BW-COF@GNF with DCTB','Location','northeast');
%legend('boxoff');
clear x y;
set(0,'defaultfigurecolor',[1 1 1]);
set(gca,'FontName','Calibri');
set(gca, 'linewidth', 2);
set(gca, 'FontSize', 28);
set(gca,'TickDir','out');
box off;
%% Textbox settings
%annotation(figure1,'textbox',...
%    [0.379761904761905 0.701036443183404 0.0383928561760556 0.0643086800749024],...
%    'String',{'1'},...
%    'FontWeight','bold',...
%    'FontSize',30,...
%    'FontName','Calibri',...
%    'EdgeColor','none');