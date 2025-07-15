%% Define Variables
% Define x as the wavelength (nm) and y as the absorbance (A) of the spectrum
x=bw107_1_1in5.nm;
y=bw107_1_1in5.A;
a=bw119_1_1in5.nm;
b=bw119_1_1in5.A;
c=bw119_2_1in5.nm;
d=bw119_2_1in5.A;
e=BW119_2_3_in_5.nm;
f=BW119_2_3_in_5.A;
%% Plotting spectrum
hold on
plot(x,y,'Color',1/255*[0 0 0],'LineWidth',2);
plot(a,b,'Color',1/255*[0 255 0],'LineWidth',2);
plot(c,d,'Color',1/255*[0 0 255],'LineWidth',2);
plot(e,f,'Color',1/255*[255 0 0],'LineWidth',2);
hold off
%% Formatting options
xlabel('Wavelength / nm','FontSize',36,'FontName','Calibri');
ylabel('Absorbance','FontSize',36,'FontName','Calibri');
%title('IR spectra of MIL-53(Al)-NH_2 and 2-aminoterephthalic acid','FontSize',28);
%legend('COF','Monomer','Location','southwest');
%legend('boxoff');
xlim([-inf,inf]);
ylim([-inf,inf]);
%ylim([60,100]);
clear a b c d e f x y;
%% Defaults 
set(0,'defaultfigurecolor',[1 1 1])
set(gca,'FontName','Calibri')
set(gca, 'linewidth', 2);
set(gca, 'FontSize', 28);
%set(gca,'Yticklabel',[]);%removes the y axis numbers
set(gca,'TickDir','out');
set(0,'defaultfigurecolor',[1 1 1]);
%{
[111]=white
[000]=black
[110]=yellow
[101]=pink
[011]=cyan
[100]=red
[010]=green
[001]=blue
%}
