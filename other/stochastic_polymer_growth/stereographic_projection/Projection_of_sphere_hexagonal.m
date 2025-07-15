%% Projection of a sphere
%% Variables
radius =12.7;

%% Code Start
set(0,'defaultfigurecolor',[1 1 1])
set(gca,'FontName','Calibri')
set(gca, 'linewidth', 2);
set(gca, 'FontSize', 28);
set(gca,'TickDir','out');

%% Lines of lattitude
N = 0.01; %increases number of data points in the lines of latitude
M=(pi/8); %increases the number of lines of lattitude
thetavec=0:M:pi; 
phivec = 0:N:2*pi; 
[th, ph] = meshgrid(thetavec,phivec);
R = ones(size(th));
xLat = R.*sin(th).*cos(ph);
yLat = R.*sin(th).*sin(ph);
zLat = R.*cos(th);

clear R N M theatvec phivec th ph;

%% Lines of longtitude
N=16; %changes number of lines of longitude
[xLong,yLong,zLong] = sphere(N);
clear N;

%% Circles seperated by phi degrees
%{
xOrigin = 0;
yOrigin = 0;
zOrigin = 0;
zData = zeros(length(angle),1);
radius =12.7;
for phi = 0:0.1:2*pi
angle=0:0.01:2*pi; 
xData=radius*cos(angle);
yData=radius*sin(angle);
%zData(phi) = radius*sin(phi);
plot3(xOrigin+xData,yOrigin+yData,zOrigin+zData,'Color',1/255*[0 0 0]);
end
%}

%% Coordinates of a circle
%xOrigin = 0;
%yOrigin = 0;
%angle=0:0.01:2*pi; 
%xData=radius*cos(angle);
%yData=radius*sin(angle);

%% Coordinates for scattered points on surface
% r, phi, theta
ScatterFaceOn = [0 0 1; 0 0 -1];
ScatterSideOn = [1 0 0;0 1 0; -1 0 0; 0 -1 0;0.7071 -0.7071 0; 0.7071 0.7071 0;-0.7071 0.7071 0;-0.7071 -0.7071 0];
ScatterAC = [ 0.7070 0 0.7070;0.7070 0 -0.7070;
   -0.7070         0    0.7070;
   -0.7070         0   -0.7070];
ScatterZZ = [    0    0.7070    0.7070;
         0    0.7070   -0.7070;
         0   -0.7070    0.7070;
         0   -0.7070   -0.7070];

%% COF-5 tilt for symposium
COF_5_coords=[0.2512    0.2993   -0.9205;
    0.1547    0.8775   -0.4540];

%% Projecting sphere
%Polar projection
XLatPolar=xLat./(1-zLat);
YLatPolar=yLat./(1-zLat);
XLongPolar=xLong./(1-zLong);
YLongPolar=yLong./(1-zLong);

ScatterFaceOnPolar = zeros(2,2);
ScatterFaceOnPolar(:,1) = ScatterFaceOn(:,1)./(1-ScatterFaceOn(:,3));
ScatterFaceOnPolar(:,2) = ScatterFaceOn(:,2)./(1-ScatterFaceOn(:,3));

ScatterSideOnPolar = zeros(8,2);
ScatterSideOnPolar(:,1) = ScatterSideOn(:,1)./(1-ScatterSideOn(:,3));
ScatterSideOnPolar(:,2) = ScatterSideOn(:,2)./(1-ScatterSideOn(:,3));

ScatterACPolar = zeros(4,2);
ScatterACPolar(:,1) = ScatterAC(:,1)./(1-ScatterAC(:,3));
ScatterACPolar(:,2) = ScatterAC(:,2)./(1-ScatterAC(:,3));

ScatterZZPolar = zeros(4,2);
ScatterZZPolar(:,1) = ScatterZZ(:,1)./(1-ScatterZZ(:,3));
ScatterZZPolar(:,2) = ScatterZZ(:,2)./(1-ScatterZZ(:,3));

COF5Polar =  zeros(2,2);
COF5Polar(:,1) = COF_5_coords(:,1)./(1-COF_5_coords(:,3));
COF5Polar(:,2) = COF_5_coords(:,2)./(1-COF_5_coords(:,3));

%Equatorial projection
XLatEq=xLat./(1-yLat);
ZLatEq=zLat./(1-yLat);
XLongEq=xLong./(1-yLong);
ZLongEq=zLong./(1-yLong);

ScatterFaceOnEq = zeros(2,2);
ScatterFaceOnEq(:,1) = ScatterFaceOn(:,1)./(1-ScatterFaceOn(:,2));
ScatterFaceOnEq(:,2) = ScatterFaceOn(:,3)./(1-ScatterFaceOn(:,2));

ScatterSideOnEq = zeros(8,2);
ScatterSideOnEq(:,1) = ScatterSideOn(:,1)./(1-ScatterSideOn(:,2));
ScatterSideOnEq(:,2) = ScatterSideOn(:,3)./(1-ScatterSideOn(:,2));

ScatterACEq = zeros(4,2);
ScatterACEq(:,1) = ScatterAC(:,1)./(1-ScatterAC(:,2));
ScatterACEq(:,2) = ScatterAC(:,3)./(1-ScatterAC(:,2));

ScatterZZEq = zeros(4,2);
ScatterZZEq(:,1) = ScatterZZ(:,1)./(1-ScatterZZ(:,2));
ScatterZZEq(:,2) = ScatterZZ(:,3)./(1-ScatterZZ(:,2));

%% Plotting projections
%% Spherical plot
subplot(2,2,2);
hold on;
%Mesh sphere:
plot3(xLong,yLong,zLong,'Color',1/255*[0 0 0]); %longtitude
plot3(xLat,yLat,zLat,'Color',1/255*[0 0 0]); %lattitude
%Surface Sphere
[X, Y, Z] = sphere(12);
s = surf(X,Y,Z);
s.FaceColor = 'white';
s.EdgeColor = 'none';
%Projections
scatter3(ScatterFaceOn(:,1),ScatterFaceOn(:,2),ScatterFaceOn(:,3),'o','MarkerFaceColor',1/255*[24 165 52],'MarkerEdgeColor',1/255*[0 0 0],'LineWidth',1,'SizeData',100);
scatter3(ScatterSideOn(:,1),ScatterSideOn(:,2),ScatterSideOn(:,3),'^','MarkerFaceColor',1/255*[214 219 62],'MarkerEdgeColor',1/255*[0 0 0],'LineWidth',1,'SizeData',100);
scatter3(ScatterAC(:,1),ScatterAC(:,2),ScatterAC(:,3),'s','MarkerFaceColor',1/255*[0 0 255],'MarkerEdgeColor',1/255*[0 0 0],'LineWidth',1,'SizeData',100);
scatter3(ScatterZZ(:,1),ScatterZZ(:,2),ScatterZZ(:,3),'d','MarkerFaceColor',1/255*[255 0 0],'MarkerEdgeColor',1/255*[0 0 0],'LineWidth',1,'SizeData',100);
scatter3(COF_5_coords(:,1),COF_5_coords(:,2),COF_5_coords(:,3));
view(40,35)
hold off;
axis equal;
box on;
set(gca,'Yticklabel',[]);%removes the y axis numbers
set(gca,'Xticklabel',[]);%removes the y axis numbers
set(gca,'Zticklabel',[]);%removes the y axis numbers
set(gca,'TickDir','out');

%% Polar plot
subplot(2,2,3);
hold on
%Lattitude: works fine
plot(XLatPolar,YLatPolar,'Color',1/255*[0 0 0]);
%Longitude: works fine
plot(XLongPolar,YLongPolar,'Color',1/255*[0 0 0]);
%Projections
scatter(ScatterFaceOnPolar(:,1),ScatterFaceOnPolar(:,2),'o','MarkerFaceColor',1/255*[24 165 52],'MarkerEdgeColor',1/255*[0 0 0],'LineWidth',1,'SizeData',100);
scatter(ScatterSideOnPolar(:,1),ScatterSideOnPolar(:,2),'^','MarkerFaceColor',1/255*[214 219 62],'MarkerEdgeColor',1/255*[0 0 0],'LineWidth',1,'SizeData',100);
scatter(ScatterACPolar(:,1),ScatterACPolar(:,2),'s','MarkerFaceColor',1/255*[0 0 255],'MarkerEdgeColor',1/255*[0 0 0],'LineWidth',1,'SizeData',100);
scatter(ScatterZZPolar(:,1),ScatterZZPolar(:,2),'d','MarkerFaceColor',1/255*[255 0 0],'MarkerEdgeColor',1/255*[0 0 0],'LineWidth',1,'SizeData',100);
scatter(COF5Polar(:,1),COF5Polar(:,2),'x','MarkerFaceColor',1/255*[0 0 0],'MarkerEdgeColor',1/255*[0 0 0],'LineWidth',1,'SizeData',100);
hold off
axis equal
xlim([-1.1,1.1]);
ylim([-1.1,1.1]);
box on;
set(gca,'Yticklabel',[]);%removes the y axis numbers
set(gca,'Xticklabel',[]);%removes the y axis numbers
set(gca,'TickDir','out');

%% Azimuthal plot
subplot(2,2,4);
hold on
%lines of lattitude
plot(XLatEq,ZLatEq,'Color',1/255*[0 0 0]);
%lines of longitude
plot(XLongEq,ZLongEq,'Color',1/255*[0 0 0]);
%Projection markers
scatter(ScatterFaceOnEq(:,1),ScatterFaceOnEq(:,2),'o','MarkerFaceColor',1/255*[24 165 52],'MarkerEdgeColor',1/255*[0 0 0],'LineWidth',1,'SizeData',100);
scatter(ScatterSideOnEq(:,1),ScatterSideOnEq(:,2),'^','MarkerFaceColor',1/255*[214 219 62],'MarkerEdgeColor',1/255*[0 0 0],'LineWidth',1,'SizeData',100);
scatter(ScatterACEq(:,1),ScatterACEq(:,2),'s','MarkerFaceColor',1/255*[0 0 255],'MarkerEdgeColor',1/255*[0 0 0],'LineWidth',1,'SizeData',100);
scatter(ScatterZZEq(:,1),ScatterZZEq(:,2),'d','MarkerFaceColor',1/255*[255 0 0],'MarkerEdgeColor',1/255*[0 0 0],'LineWidth',1,'SizeData',100);
axis equal
xlim([-1.1,1.1]);
ylim([-1.1,1.1]);
box on;
set(gca,'Yticklabel',[]);%removes the y axis numbers
set(gca,'Xticklabel',[]);%removes the y axis numbers
set(gca,'TickDir','out');

clear angle lattitude longitude radius Scattering1 Scattering2 Scattering3 thetavec xData xLat XLatEq
clear XLatPolar YLatPolar yLong YLongPolar yOrigin zLat ZLatEq zLong ZLongEq yLat xOrigin xLong
clear XLongEq XLongPolar yData Z Y X ScatterZZPolar ScatterZZEq
clear ScatterACPolar ScatterACEq ScatterDia ScatterDia ScatterSideOnPolar ScatterSideOnEq
clear ScatterSideOn ScatterFaceOnPolar ScatterFaceOnEq ScatterFaceOn ScatterSq s
clear ScatterZZ ScatterAC 
