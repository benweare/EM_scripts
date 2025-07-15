%%TGA graph
x1= BW134_2_COF_5_repeat.Temperature; y1 =BW134_2_COF_5_repeat.Weight/0.631000;
x2= BW129_2_COF5graphite.Temperature; y2= BW129_2_COF5graphite.Weight/11.1380;
x3= bw134_3_COF5_GNF.Temperature; y3=bw134_3_COF5_GNF.Weight/2.673;
x4= BW144_2_COF_5_MWNT.Temperature; y4= BW144_2_COF_5_MWNT.Weight/5.7750;
x5= BW129_4_COF5SWNT.Temperature; y5=BW129_4_COF5SWNT.Weight/9.48500;
%x6= PR19GNF_pyrolysis.Temperature; y6= PR19GNF_pyrolysis.Weight/2.743;

hold on;
%spectrumColour = [0 0 0]; massSpectrum(BW149_TMT,spectrumColour);
plot(x1,100*y1,'Color',1/255*[144, 215, 67],'LineWidth',2);%GNF
plot(x2,100*y2,'Color',1/255*[53, 183, 121],'LineWidth',2);%COF
plot(x3,100*y3,'Color',1/255*[33, 145, 140],'LineWidth',2);%COF@GNF
plot(x4,100*y4,'Color',1/255*[49, 104, 142],'LineWidth',2);%pyro COF
plot(x5,100*y5,'Color',1/255*[68, 57, 131],'LineWidth',2);%pyro COF@GNF
%plot(x6,100*y6,'Color',1/255*[68, 1, 84],'LineWidth',2);
hold off;

%1
%{
x1=bw134_3_COF5_GNF.Temperature;
y1=(bw134_3_COF5_GNF.Weight/2.67300)*100;
z1=(bw134_3_COF5_GNF.Derivative_weight/2.67300)*100;
%2
x2=BW134_2_COF_5_repeat.Temperature;
y2=(BW134_2_COF_5_repeat.Weight/0.631000)*100;
z2=(BW134_2_COF_5_repeat.Derivative_weight/0.631000)*100;
%3
x3=benzeneparadiboronicacid.Temperature;
y3=(benzeneparadiboronicacid.Weight/13.7980)*100;
z3=(benzeneparadiboronicacid.Derivative_weight/13.7980)*100;
%4
x4=hexahydroxytriphenylene.Temperature;
y4=(hexahydroxytriphenylene.Weight/22.7460)*100;
z4=(hexahydroxytriphenylene.Derivative_weight/22.7460)*100;
%5
x5=BW_PR19GNF_pristine.Temperature;
y5=(BW_PR19GNF_pristine.Weight/3.24200)*100;
z5=(BW_PR19GNF_pristine.Derivative_weight/3.24200)*100;
%6
x6=BW144_5_COF5_pyrolysis.Temperature;
y6=(BW144_5_COF5_pyrolysis.Weight/11.5420)*100;
z6=(BW144_5_COF5_pyrolysis.Derivative_weight/11.5420)*100;
hold on;
%}

%% 1
%plot(x1,y1,'Color',1/255*[255 0 0],'LineWidth',1.5);
%plot(x1,z1,'Color',1/255*[0 0 255],'LineWidth',1.5);
%% 2
%plot(x2,y2,'Color',1/255*[0 0 0],'LineWidth',1.5);
%plot(x2,z2,'Color',1/255*[0 0 255],'LineWidth',1.5);
%% 3
%plot(x3,y3,'Color',1/255*[0 0 255],'LineWidth',1.5);
%plot(x3,z3,'Color',1/255*[0 0 0],'LineWidth',1.5);
%% 4
%plot(x4,y4,'Color',1/255*[0 0 255],'LineWidth',1.5);
%plot(x4,z4,'Color',1/255*[0 0 0],'LineWidth',1.5);
%% 5
%plot(x5,y5,'Color',1/255*[0 0 255],'LineWidth',1.5);
%plot(x5,z5,'Color',1/255*[255 0 0],'LineWidth',1.5);
%% 6
%plot(x6,y6,'Color',1/255*[0 0 255],'LineWidth',1.5);
%plot(x6,z6,'Color',1/255*[0 0 0],'LineWidth',1.5);
hold off;
xlim([100,1000]);
ylim([0,100]);
xlabel('Temperature / ^oC','FontSize',36,'FontName','Calibri');
ylabel('Weight / %','FontSize',36,'FontName','Calibri');
%legend('Weight %','Derivative Weight','Location','northeast');
legend('COF-5','COF-5/graphite','COF-5/GNF','COF-5/MWNT','COF-5/SWNT','GNF','pyro(GNF)','Location','southwest');
legend('boxoff');
set(0,'defaultfigurecolor',[1 1 1]);
set(gca,'FontName','Calibri');
set(gca, 'linewidth', 2);
set(gca, 'FontSize', 28);
set(gca,'TickDir','out');
box off;
clear x1 y1 z1 x2 y2 z2 x3 y3 z3 x4 y4 z4 x5 y5 z5 x6 y6 z6
%s.DataTipTemplate.Interpreter = 'none';
%s.DataTipTemplate.FontName = 'Calibri';
%s.DataTipTemplate.FontSize = 20;
%set(DataTipTemplate,'FontSize',20,'FontName','Calibri','Interpreter','none');

%{
x1=BW0632cHBCCOF.Temperature; y1=BW0632cHBCCOF.Weight/2.169;%COF
x2=BW095_1_COFgraphite.Temperature; y2=BW095_1_COFgraphite.Weight/2.426;%COF@graphite
x3=BW065_2_COFGNF.Temperature; y3=BW065_2_COFGNF.Weight/3.938;%COF@GNF
x4=BW101_1_COF_MWNT.Temperature; y4=BW101_1_COF_MWNT.Weight/3.237;%COF@MWNT
x5=BW1161cHBCCOFSWNT.Temperature; y5=BW1161cHBCCOFSWNT.Weight/2.691;%COF@SWNT
x6=BW1171cofsilica.Temperature; y6=BW1171cofsilica.Weight/1.124;%COF@silica
%}
