hold on;
patternColour = [144, 215, 67];
plot(data.x2Theta,data.I,'Color',1/255*patternColour,'LineWidth',2);
hold off;
%% Formatting
xlabel('2\theta / ^o','FontSize',36);
ylabel('Intensity / a.u.','FontSize',36);
%title('Pawley fitting of MIL-53(Al)-NH_2','FontSize',28);
%legend(
%legend('boxoff');
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