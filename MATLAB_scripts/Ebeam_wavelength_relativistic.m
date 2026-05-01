%% Calculating Relativisitic Wavelength for Accelerating Voltage
% (the maximum transferrable energy from an electron beam of energy X keV to an element)
% Wavelength formula from Williams and Carter (p13 2nd ed.)
%
% Output is a table of wavelength versus voltage, and a graph of the same
%
%% Script starts here
x=1;
R = zeros(length(x),1);
X = zeros(length(x),1);
T= zeros(length(x),1);
%% Constants
% Resting mass of electron in kg
m0 = 9.10938356*10^-31;
% Speed of light in m/s
c = 299792458;
% Planck's constant in m2kg/s
h = 6.62607004*10^-34;
%%
for x =1:1000
kev = x*1000; % This is the accelerating voltage for the equation in keV
% Energy of incident electrons in J
e = (kev*(1.60217662*(10^-19)));
%Velocity of electrons
 v=(c - ((m0*c^2)/e)^2)^0.5;
% Calculating Wavelength
L=h/sqrt(2*m0*e*(1+(e/(2*m0*c^2))));

Ln=L*10^(9); %in nanometres
LA=L*10^(10); %in Angstroms
Lp=L*10^(12); %in picometres

T(x)=L; %wavelength in metres
Q(x)=Ln;%wavelength in nanometres
R(x)=LA;%wavelength in Angstroms
S(x)=Lp;%wavelength in picometres
X(x)=x; % :p
V(x)=v; %velocity
x=x+1;
end
R=R.';
X=X.';
T=T.';
Q=Q.';
S=S.';
velocity=V.';
empty_1=zeros([1000 1]);
empty_2=zeros([1000 1]);
empty_3=zeros([1000 1]);
%% Output results as table
Results=table(X,T,Q,R,S,empty_1,empty_2,velocity,empty_3);
Results.Properties.VariableNames{1} = 'Accelerating_Voltage_keV';
Results.Properties.VariableNames{2} = 'Wavelength_m';
Results.Properties.VariableNames{3} = 'Wavelength_nm';
Results.Properties.VariableNames{4} = 'Wavelength_A';
Results.Properties.VariableNames{5} = 'Wavelength_pm';
Results.Properties.VariableNames{6} = 'log_voltage';
Results.Properties.VariableNames{7} = 'log_wavelength_m';
Results.Properties.VariableNames{8} = 'velocity_ms';
Results.Properties.VariableNames{9} = 'velocity_fraction';
%Results.log_voltage=log10(Results.Accelerating_Voltage_keV);
%Results.log_wavelength_m=log10(Results.Wavelength_m);
Results.velocity_fraction=(Results.velocity_ms)./c;%velocity as a fraction of the speed of light
e_beam_wavelength_relativistic=Results; %enter table name here
clear R X a amass c e h kev t T m0  tmax x Results L LA Ln Q v Lp S empty_1 empty_2 V velocity empty_3
%% Plot Results
loglog(e_beam_wavelength_relativistic.Accelerating_Voltage_keV,e_beam_wavelength_relativistic.Wavelength_nm,'Color', 1/255*[255 0 0],'LineWidth',2);
%plot(e_beam_wavelength_relativistic.log_voltage,e_beam_wavelength_relativistic.log_wavelength_m,'Color', 1/255*[255 0 0],'LineWidth',2)
xlabel('Accelerating Voltage / keV','FontSize',36,'FontName','Calibri');
ylabel('Wavelength / nm','FontSize',36,'FontName','Calibri');
set(gca,'FontName','Calibri')
set(gca, 'linewidth', 2);
set(gca, 'FontSize', 28);
set(gca,'TickDir','out');
set(0,'defaultfigurecolor',[1 1 1]);