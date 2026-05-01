%% Calculating Tmax for an element
% (the maximum transferrable energy from an electron beam of energy X keV to an element)
%% For Loop Control
x=1;
R = zeros(length(x),1);
X = zeros(length(x),1);
T= zeros(length(x),1);
for x =1:126
%% Defining parameters
% Atomic mass of element, (g mol^-1)
a = x; % Change this number
% Energy in keV of electron
%kev = 200000;
%kev = 100000;% Change this number
kev = 200; %Voltage in keV

%% Preliminary calculations
% Resting mass of electron in kg
m0 = 9.10938356*10^-31;
%mass of galium-69
%m0=1.14577*10^-25;
% Speed of light in m/s
c = 299792458;
% Planck's constant in m2kg/s
h = 6.62607004*10^-34;

% Mass of atom of element in kg ((= M/1000)/Na)
amass = (a/1000)/(6.0221409*10^23);
% Energy of incident electrons in J
e = kev*1000*(1.60217662*10^-19);

%% Calculating Tmax
t = (2*amass*e*(e+(2*m0*(c^2))))/((((amass+m0)^2)*(c^2))+(2*amass*e)); % In J
tmax = t*(6.242*10^18); % Convert to eV 
T(x)=t;
R(x)=tmax;
X(x)=x; % :p
x=x+1;
end
R=R.';
X=X.';
T=T.';
Results=table(X,R,T);
Results.Properties.VariableNames{1} = 'Atomic_Mass';
Results.Properties.VariableNames{2} = 'tmax_eV';
Results.Properties.VariableNames{3} = 'tmax_J';
Results_80V=Results; %enter table name here
%clear R X a amass c e h kev t T m0  tmax x Results
