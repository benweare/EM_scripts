%% Length contraction for fast electrons
%% Variables 
% Length at 0 velocity in metres
LengthRest = 100e-9; 
% Energy of electrons
beamEnergy = 200e3;
%% Constants 
% Resting mass of electron in kg
electronMassRest = 9.10938356*10^-31;
% Speed of light in m/s
speedLight = 299792458;
% Planck's constant in m2kg/s
planck = 6.62607004*10^-34;
% Charge on the electron
electronCharge = 1.60217662*10^-19;
%% Preliminary calculations
% Energy of incident electrons in J
kineticEnergy = beamEnergy*electronCharge;
% Relativistic velocity of electrons
%relVelocity=((2*kineticEnergy)/electronMass)^(0.5);
relVelocity=sqrt((speedLight^2)*(1-((electronMassRest*(speedLight^2)/((beamEnergy*electronCharge)+electronMassRest*(speedLight^2)))^2)))
% LorentzFactor factor
LorentzFactor = 1/(1-((relVelocity^2)/(speedLight^2)))^0.5;
% Relativistic electron mass
electronMassRel = electronMassRest*LorentzFactor;
%% Relativisitic Quantities 
% Contracted length in nm
relLength = ((1/LorentzFactor) * LengthRest)*10^9
%% Troubleshooting
% Speed ratio
SpeedRatio = relVelocity/speedLight;