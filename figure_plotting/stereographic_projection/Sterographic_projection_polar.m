%% Stereographic Projection for Hexagonal Projections
%Polar projection
x=0;
y=0;
sz = 200;
MarkerEdgeColour = 'none';
hold on
%% Plotting Circles
for r = 0:3:12
angle=0:0.01:2*pi; 
xData=r*cos(angle);
yData=r*sin(angle);
plot(x+xData,y+yData,'Color',1/255*[0 0 0]);
end
%% Scattering Projection Markers
FO=scatter(([0,0,0,r,-r,8.5,8.5,-8.5,-8.5]), ([r,-r,0,0,0,8.5,-8.5,8.5,-8.5]),sz,'s','MarkerFaceColor',1/255*[0 0 0],'MarkerEdgeColor',MarkerEdgeColour); %FO
SO=scatter(([0,0,r/2,-r/2,4.2, 4.2, -4.2, -4.2]), ([r/2,-r/2,0,0,4.2,-4.2,4.2,-4.2]),sz,'^','MarkerFaceColor',1/255*[0 0 0],'MarkerEdgeColor',MarkerEdgeColour); %SO
ZZ=scatter(([0,0,0,0]), ([r/4,-r/4,r/(1+(1/3)),-r/(1+(1/3))]),sz,'o','MarkerFaceColor',1/255*[0 0 0],'MarkerEdgeColor',MarkerEdgeColour); %ZZ
AC=scatter(([r/4,-r/4,r/(1+(1/3)),-r/(1+(1/3))]),([0,0,0,0]),sz,'d','MarkerFaceColor',1/255*[0 0 0],'MarkerEdgeColor',MarkerEdgeColour);%AC
%% Plotting Dashed Circles
%{
for r = 1.5:3:10.5
angle=0:0.01:2*pi; 
xData=r*cos(angle);
yData=r*sin(angle);
plot(x+xData,y+yData,'Color',1/255*[200 200 200]);
end
%}
for r = 1.5:3:10.5
angle=0:0.01:2*pi; 
xData=r*cos(angle);
yData=r*sin(angle);
plot(x+xData,y+yData,'Color',1/255*[0 0 0]);
end
%% Adding Straight Lines
axis equal;
yline(0,'Color',1/255*[0 0 0]);
xline(0,'Color',1/255*[0 0 0]);
plot(-r:r,-r:r,'Color',1/255*[0 0 0]);
plot(-(-r:r),-r:r,'Color',1/255*[0 0 0]);
%%
hold off
xlim([-13,13])
ylim([-13,13])
xticks([-12 -9 -6 -3 0 3 6 9 12])
xticklabels({'180','135','90','45','0','45','90','135','180'})
yticks([-12 -9 -6 -3 0 3 6 9 12])
yticklabels({'180','135','90','45','0','45','90','135','180'})
ylabel('\theta / degrees','FontSize',36,'FontName','Calibri');
xlabel('\rho / degrees','FontSize',36,'FontName','Calibri');
legend([FO,SO,ZZ,AC],'Face-On','Side-On','Zigzag','Armchair','FontSize',20,'FontName','Calibri')
legend('boxoff')
legend('Location','southeastoutside')
set(gca,'TickDir','out');
set(0,'defaultfigurecolor',[1 1 1])

%% Texture mapping sphere
%{
r=12;
[I,map] = imread('ObraDinnColour.png');
[x,y,z] = sphere;
x2=x*r;
y2=y*r;
z2=z*r;
warp(x2,y2,z2,I)
axis equal
%}
