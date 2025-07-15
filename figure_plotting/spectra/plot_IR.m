%% Define Variables
% Define x as the wavenumber variable and y and the intensity of spectrum
%Right click > Export Cursor Data to Workplace
% coordinates = cell2mat({cursor_info.Position}'); %This takes the data
% exported from datatips and makes it 2 column
tic;

x1 =data.W; y1=data.I



%% Plotting spectrum
hold on
plot(x1,y1,'Color',1/255*[160,218,57],'LineWidth',2);
hold off

%% Formatting options
xlabel('Wavenumber / cm^-^1','FontSize',36,'FontName','Calibri');
ylabel('Transmittance / %','FontSize',36,'FontName','Calibri');
%title('IR spectra of MIL-53(Al)-NH_2 and 2-aminoterephthalic acid','FontSize',28);
%legend(
%legend('boxoff');
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

