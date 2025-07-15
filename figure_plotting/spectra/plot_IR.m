%% Define Variables
% Define x as the wavenumber variable and y and the intensity of spectrum
%Right click > Export Cursor Data to Workplace
% coordinates = cell2mat({cursor_info.Position}'); %This takes the data
% exported from datatips and makes it 2 column
tic;

%{
x1 =bw134_2_cof5.W; y1=bw134_2_cof5.I;
x2=BW144_3_cof5_graphite.W; y2=BW144_3_cof5_graphite.I;
x3=BW134_3_COF_5_GNF.W; y3=BW134_3_COF_5_GNF.I;
x4=BW144_2_COF5MWNT.W; y4=BW144_2_COF5MWNT.I;
x5=BW144_1_COF_5_SWNT.W; y5=BW144_1_COF_5_SWNT.I;
%x7=BW148_3_pyroGNFKBr_BC.W; y7=BW148_3_pyroGNFKBr_BC.I-0.6;
%}

%{
x1=bw068_2_FTIR.W; y1=bw068_2_FTIR.I+1;%COF
x2=BW065_2_FTIR.W; y2=BW065_2_FTIR.I+0.6;%COF@GNF
x3=bw079_1_COF_graphite.W; y3=bw079_1_COF_graphite.I+0.8;%COF@graphite
x4=BW117_1_COFSilicaNP.W; y4=BW117_1_COFSilicaNP.I;%COF@silica
x5=BW116_1_COFSWNT.W; y5=BW116_1_COFSWNT.I+0.2;%COF@SWNT
x6=bw101_1.W; y6=bw101_1.I+0.6;%COF@MWNT
%x7=amorphouscarbonfromLuke_KBr_BC.W; y7=amorphouscarbonfromLuke_KBr_BC.I;
%}


x1 =BW134_2_COF5_KBr_BC.W; y1=BW134_2_COF5_KBr_BC.I*0.2+0.8;
x2=BW134_3_COF5GNF_KBr_BC.W; y2=BW134_3_COF5GNF_KBr_BC.I-0.1;
x3=BW148_1_pyrolysedCOF_KBr_T_BC.W; y3=BW148_1_pyrolysedCOF_KBr_T_BC.I-0.2;
x4=BW148_2_COF5GNFpyrolysed_T_BC.W; y4=BW148_2_COF5GNFpyrolysed_T_BC.I-0.3;
x5=BoronoxideB2O3commericalbaselinecorrected.W; y5=BoronoxideB2O3commericalbaselinecorrected.I*0.1+0.5;
%x6=PR19GNF_KBr_BC.W; y6=PR19GNF_KBr_BC.I-0.5;
x7=BW148_3_pyroGNFKBr_BC.W; y7=BW148_3_pyroGNFKBr_BC.I-0.6;



%% Plotting spectrum
hold on
%plot(bw134_2_cof5.W,bw134_2_cof5.I,'Color',1/255*[94,201,98],'LineWidth',2)
%plot(HHTP.W,HHTP.I - 0.1,'Color',1/255*[33 145 140],'LineWidth',2)
%plot(benzeneparadiboronicacid.W,(benzeneparadiboronicacid.I*0.6),'Color',1/255*[59 82 139],'LineWidth',2)

%plot(x1,y1,'Color',1/255*[160,218,57],'LineWidth',2);%COF
%plot(x2,y2,'Color',1/255*[74,218,57],'LineWidth',2);%COF/GNF
plot(x7,y7,'Color',1/255*[31,161,135],'LineWidth',2);%pyro GNF
%plot(x3,y3,'Color',1/255*[31,161,135],'LineWidth',2);%pyroCOF
%plot(x4,y5,'Color',1/255*[39,127,142],'LineWidth',2);%pyro COF/GNF
%plot(x5,y5,'Color',1/255*[54,92,141],'LineWidth',2);%boron oxide
plot(x6,y6,'Color',1/255*[39,127,142],'LineWidth',2);%GNF


hold off
%% Formatting options
xlabel('Wavenumber / cm^-^1','FontSize',36,'FontName','Calibri');
ylabel('Transmittance / %','FontSize',36,'FontName','Calibri');
%title('IR spectra of MIL-53(Al)-NH_2 and 2-aminoterephthalic acid','FontSize',28);
legend('COF-5','COF-5/graphite','COF-5/GNF','COF-5/MWNT','COF-5/SWNT','pyro(GNF)','Location','southwest');
legend('boxoff');
%xlim([-inf,1600]);
ylim([-inf,inf]);
%ylim([60,100]);
set (gca, 'xdir', 'reverse')
%set (gca, 'ydir', 'reverse')
axis square
clear a b c d e f x y;
%% Defaults 
set(0,'defaultfigurecolor',[1 1 1])
set(gca,'FontName','Calibri')
set(gca, 'linewidth', 2);
set(gca, 'FontSize', 28);
%set(gca,'Yticklabel',[]);%removes the y axis numbers
set(gca,'TickDir','out');
toc;

