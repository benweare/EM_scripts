%%Mean_free_path_one_calculation for carbon
Atomic_weight=12/1000; %atomic weight of element, in kg per mol
Avogad=6.02214076e23; %Avogadro's number, in atoms per mol
%density=(???)*1000; %density of element, kg per m^-3, amorphous carbon
density=(1.65)*1000; %density of element, kg per m^-3, C60
%density=(2.1)*1000; %density of element, kg per m^-3, graphite
%density=(3.5)*1000; %density of element, kg per m^-3, diamond
%cross_sec=(1.787180e-2)*(2.8001852e-21);%total atomic elastic scattering cross-section in m^2, from NIST, C 200 keV
%cross_sec=(1.906703e-2)*(2.8001852e-21);%total atomic elastic scattering cross-section in m^2, from NIST, C 180 keV
%cross_sec=(2.056732e-2)*(2.8001852e-21);%total atomic elastic scattering cross-section in m^2, from NIST, C 160 keV
%cross_sec=(2.250364e-2)*(2.8001852e-21);%total atomic elastic scattering cross-section in m^2, from NIST, C 140 keV
%cross_sec=(2.509427e-2)*(2.8001852e-21);%total atomic elastic scattering cross-section in m^2, from NIST, C 120 keV
%cross_sec=(2.873188e-2)*(2.8001852e-21);%total atomic elastic scattering cross-section in m^2, from NIST, C 100 keV
%cross_sec=(3.420123e-2)*(2.8001852e-21);%total atomic elastic scattering cross-section in m^2, from NIST, C 80 keV
%cross_sec=(4.333119e-2)*(2.8001852e-21);%total atomic elastic scattering cross-section in m^2, from NIST, C 60 keV
%cross_sec=(6.159630e-2)*(2.8001852e-21);%total atomic elastic scattering cross-section in m^2, from NIST, C 40 keV
cross_sec=(1.1622230e-1)*(2.8001852e-21);%total atomic elastic scattering cross-section in m^2, from NIST, C 20 keV
mean_free_path_m=(Atomic_weight)/(Avogad*cross_sec*density);
mean_free_path_nm=mean_free_path_m*(10^9);
disp(mean_free_path_nm);
clear Atomic_weight Avogad cross_sec density