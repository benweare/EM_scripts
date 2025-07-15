%% Scaling
%% Plotting
hold on;

%patternColour = [144, 215, 67];powderPattern(BW068_2_BGsub,patternColour);%COF
%patternColour = [53, 183, 121];powderPattern(bw0951COFgraphiteP18975,patternColour);%COF@graphite
%patternColour = [33, 145, 140];powderPattern(P16252bw0722,patternColour);%COF@GNF
%patternColour = [49, 104, 142];powderPattern(bw1011COFMWNTP18976,patternColour);%COF@MWNT
%patternColour = [68, 57, 131];powderPattern(BW116COFSWNTP18466,patternColour);%COF@SWNT
%patternColour = [68, 1, 84];powderPattern(bw1171COFsilicaP18974,patternColour);%COF@silica

patternColour = [144, 215, 67];
plot(BW068_2_BGsub.x2Theta,BW068_2_BGsub.I+30000,'Color',1/255*patternColour,'LineWidth',2);
patternColour = [53, 183, 121];
plot(bw0951COFgraphiteP18975.x2Theta,bw0951COFgraphiteP18975.I+25000,'Color',1/255*patternColour,'LineWidth',2);
patternColour = [33, 145, 140];
plot(P16252bw0722.x2Theta,P16252bw0722.I+13000,'Color',1/255*patternColour,'LineWidth',2);
patternColour = [49, 104, 142];
plot(bw1011COFMWNTP18976.x2Theta,bw1011COFMWNTP18976.I+13000,'Color',1/255*patternColour,'LineWidth',2);
patternColour = [68, 57, 131];
plot(BW116COFSWNTP18466.x2Theta,BW116COFSWNTP18466.I+9000,'Color',1/255*patternColour,'LineWidth',2);
patternColour = [68, 1, 84];
plot(bw1171COFsilicaP18974.x2Theta,bw1171COFsilicaP18974.I+6000,'Color',1/255*patternColour,'LineWidth',2);

hold off;
%% Formatting
xlabel('2\theta / ^o','FontSize',36);
ylabel('Intensity / a.u.','FontSize',36);
%title('Pawley fitting of MIL-53(Al)-NH_2','FontSize',28);
legend('COF','COF@graphite','COF@GNF','COF@MWNT','COF@SWNT','COF@silica','Location','southwest');
legend('boxoff');
%ylim([0,20000]);
xlim([5,40])
set(0,'defaultfigurecolor',[1 1 1])
set(gca,'FontName','Calibri')
set(gca, 'linewidth', 2);
set(gca, 'FontSize', 28);
%set(gca,'Yticklabel',[]);%removes the y axis numbers
set(gca,'TickDir','out');
axis square
%% Cleanup
clear x y a b c d e f;

function powderPattern(powderData, patternColour)
plot(powderData.x2Theta,powderData.I,'Color',1/255*patternColour,'LineWidth',2);
clear patternColour;
end