%% Equatorial projection
x=0;
y=0;
sz = 200;
MarkerEdgeColour = 'none';
r=12;
hold on
angle=0:0.01:2*pi; 
xData=r*cos(angle);
yData=r*sin(angle);
plot(x+xData,y+yData,'Color',1/255*[0 0 0]);
yline(0,'Color',1/255*[0 0 0]);
xline(0,'Color',1/255*[0 0 0]);
axis equal
%% Coordinates of Points
FO=scatter(([0,0]), ([-12,12]),sz,'s','MarkerFaceColor',1/255*[0 0 0],'MarkerEdgeColor',MarkerEdgeColour);
SO=scatter([0,12,-12,6,-6],[0,0,0,0,0],sz,'^','MarkerFaceColor',1/255*[0 0 0],'MarkerEdgeColor',MarkerEdgeColour);
%ZZ=scatter(([0,0,0,0,7,7,-7,-7,11.3,11.3,-11.3,-11.3]), ([3,-3,9,-9,9.8,-9.8,9.8,-9.8,4.3,-4.3,4.3,-4.3]),sz,'o','MarkerFaceColor',1/255*[0 0 0],'MarkerEdgeColor',MarkerEdgeColour);
%AC=scatter(([5.8,-5.8,5.8,-5.8,3.9,3.9,-3.9,-3.9]),([3.3,3.3,-3.3,-3.3,9.2,-9.2,9.2,-9.2]),sz,'d','MarkerFaceColor',1/255*[0 0 0],'MarkerEdgeColor',MarkerEdgeColour);
ZZ=scatter(([0,0,9.6,9.6,-9.6,-9.6]), ([6,-6,7.1,-7.1,7.1,-7.1]),sz,'o','MarkerFaceColor',1/255*[0 0 0],'MarkerEdgeColor',MarkerEdgeColour);
AC=scatter(([5.1,5.1,-5.1,-5.1]),([6.3,-6.3,6.3,-6.3]),sz,'d','MarkerFaceColor',1/255*[0 0 0],'MarkerEdgeColor',MarkerEdgeColour);
%% Ellipse
for b=3:3:9
xData=b*cos(angle);
yData=r*sin(angle);
plot(x+xData,y+yData,'Color',1/255*[0 0 0]);
end
%% Arc of circles
%% Lower Hemisphere
C=53;
r=-50;
angle=1.34:0.01:1.8;
ArcCircle(r,C,angle)
C=46;
r=-40;
angle=1.33:0.01:1.82;
ArcCircle(r,C,angle)
ArcCircle(r,C,angle)
C=39;
r=-30;
angle=1.34:0.01:1.8;
ArcCircle(r,C,angle)

C=-53;
r=50;
angle=1.34:0.01:1.8;
ArcCircle(r,C,angle)
C=-46;
r=40;
angle=1.33:0.01:1.82;
ArcCircle(r,C,angle)
ArcCircle(r,C,angle)
C=-39;
r=30;
angle=1.34:0.01:1.8;
ArcCircle(r,C,angle)
%{
C=-30.5;
r=20;
angle=1.335:0.01:1.81;
ArcCircle(r,C,angle)
C=-61.5;
r=60;
angle=1.375:0.01:1.77;
ArcCircle(r,C,angle)
C=30.5;
r=-20;
angle=1.335:0.01:1.81;
ArcCircle(r,C,angle)
C=61.5;
r=-60;
angle=1.375:0.01:1.77;
ArcCircle(r,C,angle)
%}

%% graphics
hold off
xlim([-13,13])
ylim([-13,13])
xticks([-12 -6 0 6 12])
xticklabels({'90','45','0','45','90'})
yticks([-12 -6 0 6 12])
yticklabels({'90','45','0','45','90'})
ylabel('\theta / degrees','FontSize',36,'FontName','Calibri');
xlabel('\rho / degrees','FontSize',36,'FontName','Calibri');
set(gca,'TickDir','out');
set(0,'defaultfigurecolor',[1 1 1])
legend([FO,SO,ZZ,AC],'Face-On','Side-On','Zigzag','Armchair','FontSize',20,'FontName','Calibri')
legend('boxoff')
legend('Location','southeastoutside')

%{
for r = 2:2:10
    if r == 2
        angle=0.08:0.01:3.06;
    elseif r == 4
        angle=0.16:0.01:2.99;
    elseif r == 6
        angle=0.25:0.01:2.9;
    elseif r == 8
            angle=0.34:0.01:2.81;
    elseif r == 10
            angle=0.43:0.01:2.72;
    end
    ArcCircle(r,C,angle);
end

C=12;
for r = 2:2:10
    if r == 2
        angle=0.08:0.01:3.06;
    elseif r == 4
        angle=0.16:0.01:2.99;
    elseif r == 6
        angle=0.25:0.01:2.9;
    elseif r == 8
            angle=0.34:0.01:2.81;
    elseif r == 10
            angle=0.43:0.01:2.72;
    end
    r= -r;
    ArcCircle(r,C,angle);
end
%}
function ArcCircle(r,C,angle)
xData=r*cos(angle);
yData=C+r*sin(angle);
plot(xData,yData,'Color',1/255*[0 0 0]);
end